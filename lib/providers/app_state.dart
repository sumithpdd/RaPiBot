import 'package:flutter/foundation.dart';

enum AppMode {
  video,
  timer,
  notification,
}

class AppState extends ChangeNotifier {
  AppMode _currentMode = AppMode.video;
  String _currentVideo = 'assets/animations/blink.mp4';
  int _timerSeconds = 0;
  bool _isTimerRunning = false;
  Map<String, dynamic>? _currentMeeting;
  bool _isListening = false;
  bool _isSpeaking = false;
  String _currentSpeechText = '';
  DateTime? _lastVideoChange;
  
  // Minimum delay between video switches (in seconds)
  static const int _minVideoSwitchDelay = 10;

  AppMode get currentMode => _currentMode;
  String get currentVideo => _currentVideo;
  int get timerSeconds => _timerSeconds;
  bool get isTimerRunning => _isTimerRunning;
  Map<String, dynamic>? get currentMeeting => _currentMeeting;
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  String get currentSpeechText => _currentSpeechText;

  void setVideoMode(String videoPath) {
    // Don't change video if currently speaking - speaking has priority
    if (_isSpeaking) {
      debugPrint('[AppState] 🛡️ Video change blocked - currently speaking');
      return;
    }
    
    // Check if enough time has passed since last video change
    if (_lastVideoChange != null && videoPath != _currentVideo) {
      final timeSinceLastChange = DateTime.now().difference(_lastVideoChange!);
      if (timeSinceLastChange.inSeconds < _minVideoSwitchDelay) {
        final remainingTime = _minVideoSwitchDelay - timeSinceLastChange.inSeconds;
        debugPrint('[AppState] ⏱️ Video change cooldown - wait ${remainingTime}s more');
        return;
      }
    }
    
    _currentMode = AppMode.video;
    _currentVideo = videoPath;
    _lastVideoChange = DateTime.now();
    notifyListeners();
  }

  void setTimerMode(int seconds) {
    _currentMode = AppMode.timer;
    _timerSeconds = seconds;
    _isTimerRunning = true;
    notifyListeners();
  }

  void updateTimerSeconds(int seconds) {
    _timerSeconds = seconds;
    if (seconds <= 0) {
      _isTimerRunning = false;
      // Only change video if not speaking
      if (!_isSpeaking) {
        setVideoMode('assets/animations/blink.mp4');
      }
    }
    notifyListeners();
  }

  void stopTimer() {
    _isTimerRunning = false;
    // Only change video if not speaking
    if (!_isSpeaking) {
      setVideoMode('assets/animations/blink.mp4');
    }
  }

  void showMeetingNotification(Map<String, dynamic> meeting) {
    _currentMode = AppMode.notification;
    _currentMeeting = meeting;
    notifyListeners();
  }

  void dismissNotification() {
    _currentMeeting = null;
    // Only change video if not speaking
    if (!_isSpeaking) {
      setVideoMode('assets/animations/blink.mp4');
    }
  }

  void handleSensorData(Map<String, dynamic> sensorData) {
    // Don't change videos if not in video mode or if speaking/listening
    if (_currentMode != AppMode.video || _isSpeaking || _isListening) {
      if (_isSpeaking) {
        debugPrint('[AppState] 🛡️ Sensors blocked - currently speaking');
      }
      return;
    }

    String videoPath = 'assets/animations/blink.mp4';

    // CO2 sensor logic
    if (sensorData.containsKey('eCO2')) {
      int co2 = sensorData['eCO2'];
      if (co2 >= 500 && co2 < 750) {
        videoPath = 'assets/animations/yellow.mp4';
      } else if (co2 >= 750 && co2 < 1500) {
        videoPath = 'assets/animations/red.mp4';
      }
    }

    // Light sensor logic
    if (sensorData.containsKey('light_intensity')) {
      double lightIntensity = sensorData['light_intensity'];
      if (lightIntensity < 10) {
        videoPath = 'assets/animations/black.mp4';
      }
    }

    if (_currentVideo != videoPath) {
      debugPrint('[AppState] 📊 Sensor triggered video change: $videoPath');
      setVideoMode(videoPath);
    }
  }
  
  /// Set listening state (microphone active)
  void setListening(bool listening) {
    _isListening = listening;
    notifyListeners();
  }
  
  /// Set speaking state (TTS active) - shows speaking animation
  void setSpeaking(bool speaking, {String text = ''}) {
    debugPrint('[AppState] setSpeaking called: speaking=$speaking, mode=$_currentMode, text="$text"');
    
    _isSpeaking = speaking;
    _currentSpeechText = text;
    
    // When speaking, switch to speaking animation (bypass cooldown)
    if (speaking && _currentMode == AppMode.video) {
      debugPrint('[AppState] 🎥 CHANGING VIDEO: ${_currentVideo} → speaking.mp4');
      _currentVideo = 'assets/animations/speaking.mp4';
      _lastVideoChange = DateTime.now(); // Reset cooldown timer
      debugPrint('[AppState] 🗣️ Switching to speaking animation');
    } else if (!speaking && _currentMode == AppMode.video) {
      // Return to default video when done speaking (bypass cooldown)
      debugPrint('[AppState] 🎥 CHANGING VIDEO: ${_currentVideo} → blink.mp4');
      _currentVideo = 'assets/animations/blink.mp4';
      _currentSpeechText = '';
      _lastVideoChange = DateTime.now(); // Reset cooldown timer
      debugPrint('[AppState] ✓ Returning to blink animation');
    }
    
    debugPrint('[AppState] Notifying listeners...');
    notifyListeners();
    debugPrint('[AppState] Current video is now: $_currentVideo');
  }
}

