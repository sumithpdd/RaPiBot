import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// Mock voice service for testing without microphone
/// Simulates voice commands and TTS behavior
class MockVoiceService {
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _isInitialized = false;
  String _currentSpeechText = '';
  
  // Callbacks (same as real VoiceService)
  Function(String)? onTextRecognized;
  Function(bool)? onListeningStateChanged;
  Function(bool, String)? onSpeakingStateChanged;
  Function()? onWakeWordDetected;
  
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  bool get isInitialized => _isInitialized;
  
  // Mock data: predefined voice commands
  static final List<String> _mockCommands = [
    'start pomodoro for 25 minutes',
    'start pomodoro for 15 minutes',
    'start pomodoro for 5 minutes',
    'set timer for 10 minutes',
    'set timer for 30 minutes',
    'cancel timer',
    'dismiss notification',
    'show calendar',
    'what\'s happening',
    'hey google',
  ];
  
  // Mock use cases: realistic scenarios
  static final List<MockUseCase> _useCases = [
    MockUseCase(
      name: 'Quick Pomodoro',
      description: 'User wants to start a quick 5-minute focus session',
      commands: [
        'start pomodoro for 5 minutes',
      ],
      delay: Duration(seconds: 2),
    ),
    MockUseCase(
      name: 'Standard Pomodoro',
      description: 'User starts a standard 25-minute Pomodoro',
      commands: [
        'start pomodoro for 25 minutes',
      ],
      delay: Duration(seconds: 2),
    ),
    MockUseCase(
      name: 'Check Status',
      description: 'User asks what is currently happening',
      commands: [
        'what\'s happening',
      ],
      delay: Duration(seconds: 2),
    ),
    MockUseCase(
      name: 'Cancel and Restart',
      description: 'User cancels current timer and starts a new one',
      commands: [
        'cancel timer',
        'start pomodoro for 15 minutes',
      ],
      delays: [Duration(seconds: 2), Duration(seconds: 3)],
    ),
    MockUseCase(
      name: 'Wake Word Flow',
      description: 'User uses wake word and then gives a command',
      commands: [
        'hey google',
        'start pomodoro for 25 minutes',
      ],
      delays: [Duration(seconds: 2), Duration(seconds: 3)],
    ),
    MockUseCase(
      name: 'Multiple Queries',
      description: 'User asks multiple questions in sequence',
      commands: [
        'what\'s happening',
        'show calendar',
        'start pomodoro for 25 minutes',
      ],
      delays: [Duration(seconds: 2), Duration(seconds: 3), Duration(seconds: 4)],
    ),
  ];
  
  final Random _random = Random();
  
  /// Initialize mock voice service (always succeeds)
  Future<bool> initialize() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isInitialized = true;
    debugPrint('[MockVoiceService] Initialized successfully');
    
    // Speak welcome message after initialization (wait for UI to settle)
    // Use Future.microtask to ensure async execution doesn't block
    Future.delayed(const Duration(seconds: 3), () {
      if (_isInitialized) {
        _playWelcomeSequence();
      }
    });
    
    return true;
  }
  
  /// Play welcome sequence with proper async handling
  Future<void> _playWelcomeSequence() async {
    try {
      // First welcome message
      await speak('Welcome to DevFest London 2025! I am your photo booth assistant!');
      
      // Wait between messages
      await Future.delayed(const Duration(seconds: 2));
      
      // Second instruction message
      await speak('Say take a photo when you are ready, or start photo session for timed fun!');
    } catch (e) {
      debugPrint('[MockVoiceService] Error in welcome sequence: $e');
    }
  }
  
  /// Simulate listening for a random command
  Future<void> startListening() async {
    if (_isListening) return;
    
    _isListening = true;
    onListeningStateChanged?.call(true);
    debugPrint('[MockVoiceService] Started listening (mock)');
    
    // Simulate listening delay
    await Future.delayed(Duration(milliseconds: 500 + _random.nextInt(1000)));
    
    // Pick a random command
    final command = _mockCommands[_random.nextInt(_mockCommands.length)];
    
    debugPrint('[MockVoiceService] Mock recognized: "$command"');
    
    // Check for wake word
    if (command.contains('hey google')) {
      onWakeWordDetected?.call();
    }
    
    // Trigger recognition callback
    onTextRecognized?.call(command);
    
    // Stop listening
    await stopListening();
  }
  
  /// Simulate listening with a specific command
  Future<void> startListeningWithCommand(String command) async {
    if (_isListening) return;
    
    _isListening = true;
    onListeningStateChanged?.call(true);
    debugPrint('[MockVoiceService] Started listening (mock)');
    
    // Simulate listening delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    debugPrint('[MockVoiceService] Mock recognized: "$command"');
    
    // Check for wake word
    if (command.toLowerCase().contains('hey google')) {
      onWakeWordDetected?.call();
    }
    
    // Trigger recognition callback
    onTextRecognized?.call(command);
    
    // Stop listening
    await stopListening();
  }
  
  /// Stop listening
  Future<void> stopListening() async {
    if (!_isListening) return;
    
    await Future.delayed(const Duration(milliseconds: 200));
    _isListening = false;
    onListeningStateChanged?.call(false);
    debugPrint('[MockVoiceService] Stopped listening (mock)');
  }
  
  /// Simulate speaking with TTS
  Future<void> speak(String text) async {
    // If already speaking, wait for current speech to finish
    while (_isSpeaking) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    _isSpeaking = true;
    _currentSpeechText = text;
    
    // Trigger speaking animation IMMEDIATELY
    onSpeakingStateChanged?.call(true, text);
    debugPrint('[MockVoiceService] 🗣️ Speaking (mock): "$text"');
    
    // Simulate speech duration based on text length (minimum 3 seconds for demo)
    final baseDuration = (text.length * 60).clamp(3000, 15000);
    final duration = Duration(milliseconds: baseDuration);
    
    debugPrint('[MockVoiceService]   Duration: ${duration.inSeconds}s');
    
    await Future.delayed(duration);
    
    _isSpeaking = false;
    _currentSpeechText = '';
    
    // Clear speaking animation
    onSpeakingStateChanged?.call(false, '');
    debugPrint('[MockVoiceService] ✓ Finished speaking (mock)');
  }
  
  /// Stop speaking
  Future<void> stopSpeaking() async {
    if (!_isSpeaking) return;
    
    _isSpeaking = false;
    _currentSpeechText = '';
    onSpeakingStateChanged?.call(false, '');
    debugPrint('[MockVoiceService] Stopped speaking (mock)');
  }
  
  /// Enable continuous wake word detection (mock)
  Future<void> enableWakeWordDetection() async {
    debugPrint('[MockVoiceService] Wake word detection enabled (mock)');
    // In mock mode, we don't actually start continuous listening
  }
  
  /// Execute a predefined use case
  Future<void> executeUseCase(MockUseCase useCase) async {
    debugPrint('[MockVoiceService] Executing use case: ${useCase.name}');
    
    for (int i = 0; i < useCase.commands.length; i++) {
      final command = useCase.commands[i];
      final delay = useCase.delays != null && i < useCase.delays!.length
          ? useCase.delays![i]
          : useCase.delay;
      
      // Wait before next command
      await Future.delayed(delay);
      
      // Execute command
      await startListeningWithCommand(command);
      
      // Wait for processing
      await Future.delayed(const Duration(seconds: 1));
    }
    
    debugPrint('[MockVoiceService] Use case completed: ${useCase.name}');
  }
  
  /// Get all available mock commands
  List<String> getMockCommands() => List.from(_mockCommands);
  
  /// Get all predefined use cases
  List<MockUseCase> getUseCases() => List.from(_useCases);
  
  /// Dispose
  Future<void> dispose() async {
    await stopListening();
    await stopSpeaking();
    debugPrint('[MockVoiceService] Disposed');
  }
}

/// Represents a mock use case scenario
class MockUseCase {
  final String name;
  final String description;
  final List<String> commands;
  final Duration delay;
  final List<Duration>? delays; // Individual delays per command
  
  const MockUseCase({
    required this.name,
    required this.description,
    required this.commands,
    this.delay = const Duration(seconds: 2),
    this.delays,
  });
  
  @override
  String toString() => '$name: $description';
}

