import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/sensor_service.dart';
import '../services/calendar_service.dart';
import '../services/voice_service.dart';
import '../services/mock_voice_service.dart';
import '../services/intent_service.dart';
import '../services/voice_command_handler.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/timer_widget.dart';
import '../widgets/meeting_notification_widget.dart';
import '../widgets/voice_indicator_widget.dart';
import '../widgets/mock_voice_panel.dart';
import '../widgets/subtitle_widget.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription? _sensorSubscription;
  StreamSubscription? _calendarSubscription;
  Timer? _timerCountdown;
  final Set<String> _shownEventIds = {};
  
  // Voice services
  VoiceService? _voiceService;
  MockVoiceService? _mockVoiceService;
  late IntentService _intentService;
  late VoiceCommandHandler _commandHandler;
  bool _voiceInitialized = false;
  bool _useMockVoice = false; // ✅ ENABLED: Now using real TTS with audio output!

  @override
  void initState() {
    super.initState();
    _startMonitoring();
    _initializeVoiceServices();
  }

  void _startMonitoring() {
    final sensorService = context.read<SensorService>();
    final calendarService = context.read<CalendarService>();
    final appState = context.read<AppState>();

    // Monitor sensor data
    _sensorSubscription = sensorService.getSensorDataStream().listen((data) {
      appState.handleSensorData(data);
    });

    // Monitor calendar events
    _calendarSubscription = calendarService.getUpcomingEventsStream().listen((events) {
      for (var event in events) {
        if (calendarService.isEventUpcoming(event)) {
          // Check if we haven't already shown this event
          String eventId = event['id'] ?? event['summary'];
          if (!_shownEventIds.contains(eventId)) {
            _shownEventIds.add(eventId);
            appState.showMeetingNotification(event);
            
            // Announce meeting via voice
            if (_voiceInitialized) {
              if (_useMockVoice) {
                _mockVoiceService?.speak('You have an upcoming meeting: ${event['summary']}');
              } else {
                _voiceService?.speak('You have an upcoming meeting: ${event['summary']}');
              }
            }
            
            // Clear old event IDs after 20 minutes to prevent memory leak
            Future.delayed(const Duration(minutes: 20), () {
              _shownEventIds.remove(eventId);
            });
            break; // Only show one notification at a time
          }
        }
      }
    });
  }
  
  /// Initialize voice services (real or mock)
  Future<void> _initializeVoiceServices() async {
    final appState = context.read<AppState>();
    _intentService = IntentService();
    
    if (_useMockVoice) {
      // Use mock voice service for testing
      _mockVoiceService = MockVoiceService();
      
      _commandHandler = VoiceCommandHandler(
        appState: appState,
        voiceService: _mockVoiceService!,
        intentService: _intentService,
      );
      
      // ⚠️ CRITICAL: Setup callbacks BEFORE initialize() is called
      // This ensures welcome messages trigger speaking animation
      debugPrint('[HomeScreen] Setting up mock voice callbacks...');
      
      _mockVoiceService!.onListeningStateChanged = (listening) {
        debugPrint('[HomeScreen] 🎤 Listening: $listening');
        appState.setListening(listening);
      };
      
      _mockVoiceService!.onSpeakingStateChanged = (speaking, text) {
        debugPrint('[HomeScreen] 🗣️ Speaking: $speaking, Text: "$text"');
        appState.setSpeaking(speaking, text: text);
      };
      
      _mockVoiceService!.onTextRecognized = (text) {
        debugPrint('[HomeScreen] Mock voice command: $text');
        _commandHandler.processCommand(text);
      };
      
      _mockVoiceService!.onWakeWordDetected = () {
        debugPrint('[HomeScreen] Mock wake word detected!');
        _mockVoiceService!.speak('Yes, how can I help?');
      };
      
      debugPrint('[HomeScreen] Callbacks set up, now initializing...');
      
      // Initialize mock service (will trigger welcome messages)
      _voiceInitialized = await _mockVoiceService!.initialize();
      
      if (_voiceInitialized) {
        debugPrint('[HomeScreen] ✅ Mock voice service initialized');
      }
    } else {
      // Use real voice service
      _voiceService = VoiceService();
      
      _commandHandler = VoiceCommandHandler(
        appState: appState,
        voiceService: _voiceService!,
        intentService: _intentService,
      );
      
      // Setup callbacks for real service
      _voiceService!.onListeningStateChanged = (listening) {
        appState.setListening(listening);
      };
      
      _voiceService!.onSpeakingStateChanged = (speaking, text) {
        appState.setSpeaking(speaking, text: text);
      };
      
      _voiceService!.onTextRecognized = (text) {
        debugPrint('[HomeScreen] Voice command: $text');
        _commandHandler.processCommand(text);
      };
      
      _voiceService!.onWakeWordDetected = () {
        debugPrint('[HomeScreen] Wake word detected!');
        _voiceService!.speak('Yes, how can I help?');
      };
      
      // Initialize real service
      _voiceInitialized = await _voiceService!.initialize();
      
      if (_voiceInitialized) {
        debugPrint('[HomeScreen] Real voice services initialized');
        _voiceService!.enableWakeWordDetection();
      } else {
        debugPrint('[HomeScreen] Real voice services failed to initialize');
      }
    }
  }

  void _startPomodoroTimer() {
    final appState = context.read<AppState>();
    const pomodoroSeconds = 1500; // 25 minutes
    
    appState.setTimerMode(pomodoroSeconds);
    
    _timerCountdown?.cancel();
    _timerCountdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentSeconds = appState.timerSeconds;
      if (currentSeconds > 0) {
        appState.updateTimerSeconds(currentSeconds - 1);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _sensorSubscription?.cancel();
    _calendarSubscription?.cancel();
    _timerCountdown?.cancel();
    if (_voiceInitialized) {
      if (_useMockVoice) {
        _mockVoiceService?.dispose();
      } else {
        _voiceService?.dispose();
      }
    }
    super.dispose();
  }
  
  /// Manually trigger voice listening
  void _startVoiceListening() {
    if (_voiceInitialized) {
      if (_useMockVoice) {
        _mockVoiceService?.startListening();
      } else {
        _voiceService?.startListening();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Focus(
        autofocus: true,
        onKey: (node, event) {
          // Handle keyboard shortcuts
          if (event is RawKeyDownEvent) {
            // Escape key to exit fullscreen or dismiss
            if (event.logicalKey == LogicalKeyboardKey.escape) {
              final appState = context.read<AppState>();
              if (appState.currentMode == AppMode.notification) {
                appState.dismissNotification();
              } else if (appState.currentMode == AppMode.timer) {
                appState.stopTimer();
              }
              return KeyEventResult.handled;
            }
            // Space bar to start Pomodoro timer (simulates button press)
            if (event.logicalKey == LogicalKeyboardKey.space) {
              _startPomodoroTimer();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Stack(
          children: [
            // Main content based on current mode
            Consumer<AppState>(
              builder: (context, appState, child) {
                switch (appState.currentMode) {
                  case AppMode.video:
                    return VideoPlayerWidget(videoPath: appState.currentVideo);
                  case AppMode.timer:
                    return TimerWidget(
                      seconds: appState.timerSeconds,
                      onCancel: () => appState.stopTimer(),
                    );
                  case AppMode.notification:
                    return MeetingNotificationWidget(
                      meeting: appState.currentMeeting!,
                      onDismiss: () => appState.dismissNotification(),
                    );
                }
              },
            ),
            
            // Floating action buttons (for testing)
            Positioned(
              bottom: 20,
              right: 20,
              child: Consumer<AppState>(
                builder: (context, appState, child) {
                  // Only show FABs in video mode
                  if (appState.currentMode != AppMode.video) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Voice button
                      if (_voiceInitialized)
                        FloatingActionButton(
                          onPressed: _startVoiceListening,
                          backgroundColor: appState.isListening 
                              ? Colors.red 
                              : Colors.blue,
                          child: Icon(
                            appState.isListening 
                                ? Icons.mic 
                                : Icons.mic_none,
                          ),
                          heroTag: 'voice',
                        ),
                      const SizedBox(height: 10),
                      // Timer button
                      FloatingActionButton.extended(
                        onPressed: _startPomodoroTimer,
                        backgroundColor: Colors.deepPurple,
                        icon: const Icon(Icons.timer),
                        label: const Text('Start Pomodoro'),
                        heroTag: 'timer',
                      ),
                    ],
                  );
                },
              ),
            ),
            
            // Voice indicator overlay
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Consumer<AppState>(
                builder: (context, appState, child) {
                  if (!appState.isListening && !appState.isSpeaking) {
                    return const SizedBox.shrink();
                  }
                  return VoiceIndicatorWidget(
                    isListening: appState.isListening,
                    isSpeaking: appState.isSpeaking,
                  );
                },
              ),
            ),
            
            // Subtitle overlay (when speaking)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Consumer<AppState>(
                builder: (context, appState, child) {
                  if (!appState.isSpeaking || appState.currentSpeechText.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return SubtitleWidget(text: appState.currentSpeechText);
                },
              ),
            ),
            
            // Mock voice panel (only show if using mock service)
            if (_useMockVoice && _mockVoiceService != null && _voiceInitialized)
              MockVoicePanel(mockVoiceService: _mockVoiceService!),
          ],
        ),
      ),
    );
  }
}

