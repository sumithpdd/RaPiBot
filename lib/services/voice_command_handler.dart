import 'package:flutter/foundation.dart';
import '../providers/app_state.dart';
import 'intent_service.dart';

/// Handles voice commands and executes corresponding actions
/// Similar to Python's _handle_intent function
/// Works with both real VoiceService and MockVoiceService
class VoiceCommandHandler {
  final AppState appState;
  final dynamic voiceService; // Can be VoiceService or MockVoiceService
  final IntentService intentService;
  
  VoiceCommandHandler({
    required this.appState,
    required this.voiceService,
    required this.intentService,
  });
  
  /// Process voice command text
  Future<void> processCommand(String text) async {
    debugPrint('[VoiceCommandHandler] Processing: $text');
    
    // Extract intent from text
    final intent = intentService.extractIntent(text);
    
    if (intent != null) {
      debugPrint('[VoiceCommandHandler] Intent: ${intent.name}');
      await _handleIntent(intent);
    } else {
      debugPrint('[VoiceCommandHandler] No intent matched');
      await voiceService.speak('Sorry, I didn\'t understand. Try saying: start photo timer or take a photo!');
    }
  }
  
  /// Handle specific intents
  Future<void> _handleIntent(Intent intent) async {
    try {
      switch (intent.name) {
        case 'take_photo':
          await _handleTakePhoto();
          break;
          
        case 'start_photo_session':
          await _handlePhotoSession(intent);
          break;
          
        case 'ready_for_photo':
          await _handleReadyForPhoto();
          break;
          
        case 'use_photobooth':
          await _handleUsePhotoBooth();
          break;
          
        case 'how_does_it_work':
          await _handleHowItWorks();
          break;
          
        case 'set_pomodoro':
          await _handleSetPomodoro(intent);
          break;
          
        case 'set_timer':
          await _handleSetTimer(intent);
          break;
          
        case 'cancel_timer':
          await _handleCancelTimer();
          break;
          
        case 'dismiss':
          await _handleDismiss();
          break;
          
        case 'show_calendar':
          await _handleShowCalendar();
          break;
          
        case 'whats_happening':
          await _handleStatus();
          break;
          
        default:
          await voiceService.speak('Try saying: take a photo, or start photo session!');
      }
    } catch (e) {
      debugPrint('[VoiceCommandHandler] Error handling intent: $e');
      await voiceService.speak('Oops! Photo booth had a glitch. Please try again!');
    }
  }
  
  /// Take a photo now
  Future<void> _handleTakePhoto() async {
    await voiceService.speak('Perfect! Get ready to smile! Photo in 3... 2... 1... Say cheese!');
    // Could trigger camera countdown here
  }
  
  /// User wants to start photo session
  Future<void> _handlePhotoSession(Intent intent) async {
    if (intent.parameters.isEmpty) {
      await voiceService.speak('How many minutes for your photo session?');
      return;
    }
    
    final minutes = int.tryParse(intent.parameters[0]);
    if (minutes == null || minutes <= 0) {
      await voiceService.speak('Please tell me how many minutes you need.');
      return;
    }
    
    final seconds = minutes * 60;
    appState.setTimerMode(seconds);
    
    await voiceService.speak('Awesome! Starting your $minutes minute photo session at DevFest London! Strike your best pose!');
  }
  
  /// User says they're ready
  Future<void> _handleReadyForPhoto() async {
    await voiceService.speak('Great! Let me get you set up! Say take a photo when you are ready!');
  }
  
  /// User wants to use photo booth
  Future<void> _handleUsePhotoBooth() async {
    await voiceService.speak('Welcome to our interactive photo booth at DevFest London 2025! Just say take a photo or start photo session and I will help you!');
  }
  
  /// Explain how it works
  Future<void> _handleHowItWorks() async {
    await voiceService.speak('It is super easy! Just say take a photo for instant fun, or start photo session to set a timer. I am here to help you capture amazing moments at DevFest London!');
  }
  
  /// Start photo session timer
  Future<void> _handleSetPomodoro(Intent intent) async {
    if (intent.parameters.isEmpty) {
      await voiceService.speak('How many minutes for your photo session?');
      return;
    }
    
    final minutes = int.tryParse(intent.parameters[0]);
    if (minutes == null || minutes <= 0) {
      await voiceService.speak('Please specify a valid number of minutes.');
      return;
    }
    
    final seconds = minutes * 60;
    appState.setTimerMode(seconds);
    
    await voiceService.speak('Starting $minutes minute photo countdown! Get ready!');
  }
  
  /// Set custom photo timer
  Future<void> _handleSetTimer(Intent intent) async {
    if (intent.parameters.length < 2) {
      await voiceService.speak('Please specify duration for your photo session.');
      return;
    }
    
    final value = int.tryParse(intent.parameters[0]);
    final unit = intent.parameters[1].toLowerCase();
    
    if (value == null || value <= 0) {
      await voiceService.speak('Please specify a valid duration.');
      return;
    }
    
    final seconds = unit.startsWith('minute') ? value * 60 : value;
    appState.setTimerMode(seconds);
    
    await voiceService.speak('Photo timer set for $value $unit. Smile!');
  }
  
  /// Cancel current photo timer
  Future<void> _handleCancelTimer() async {
    if (appState.currentMode == AppMode.timer) {
      appState.stopTimer();
      await voiceService.speak('Photo timer cancelled.');
    } else {
      await voiceService.speak('No timer is currently running.');
    }
  }
  
  /// Dismiss notification
  Future<void> _handleDismiss() async {
    if (appState.currentMode == AppMode.notification) {
      appState.dismissNotification();
      await voiceService.speak('Notification dismissed.');
    } else {
      await voiceService.speak('No notification to dismiss.');
    }
  }
  
  /// Show calendar events
  Future<void> _handleShowCalendar() async {
    // Photo booth ready message
    await voiceService.speak('Photo booth is ready at DevFest London 2025! Strike a pose!');
  }
  
  /// Get current status
  Future<void> _handleStatus() async {
    String status;
    
    switch (appState.currentMode) {
      case AppMode.timer:
        final minutes = appState.timerSeconds ~/ 60;
        final seconds = appState.timerSeconds % 60;
        status = 'Photo countdown: $minutes minutes and $seconds seconds. Get ready for your picture!';
        break;
        
      case AppMode.notification:
        final meeting = appState.currentMeeting;
        if (meeting != null) {
          status = 'Next photo session: ${meeting['summary']}.';
        } else {
          status = 'Ready for photos!';
        }
        break;
        
      case AppMode.video:
      default:
        status = 'Welcome to DevFest London 2025 photo booth! Ready to take amazing photos!';
    }
    
    await voiceService.speak(status);
  }
}

