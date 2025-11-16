import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

/// Voice service handles speech recognition and text-to-speech
/// Converts Python's pvporcupine + speech_recognition + gTTS to Flutter
class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _isInitialized = false;
  
  // Wake word detection (simplified for Flutter)
  String _wakeWord = 'hey google';
  bool _wakeWordDetected = false;
  
  // Callbacks
  Function(String)? onTextRecognized;
  Function(bool)? onListeningStateChanged;
  Function(bool, String)? onSpeakingStateChanged;
  Function()? onWakeWordDetected;
  
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  bool get isInitialized => _isInitialized;
  
  /// Initialize speech services
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        debugPrint('[VoiceService] Microphone permission denied');
        return false;
      }
      
      // Initialize speech to text
      _isInitialized = await _speechToText.initialize(
        onStatus: (status) {
          debugPrint('[VoiceService] Speech status: $status');
          if (status == 'listening') {
            _isListening = true;
            onListeningStateChanged?.call(true);
          } else if (status == 'notListening' || status == 'done') {
            _isListening = false;
            onListeningStateChanged?.call(false);
          }
        },
        onError: (error) {
          debugPrint('[VoiceService] Speech error: $error');
          _isListening = false;
          onListeningStateChanged?.call(false);
        },
      );
      
      if (!_isInitialized) {
        debugPrint('[VoiceService] Failed to initialize speech recognition');
        return false;
      }
      
      // Initialize TTS
      await _setupTts();
      
      debugPrint('[VoiceService] Voice service initialized successfully');
      return true;
    } catch (e) {
      debugPrint('[VoiceService] Initialization error: $e');
      return false;
    }
  }
  
  Future<void> _setupTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    
    String currentText = '';
    
    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
      onSpeakingStateChanged?.call(true, currentText);
      debugPrint('[VoiceService] TTS started');
    });
    
    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      onSpeakingStateChanged?.call(false, '');
      currentText = '';
      debugPrint('[VoiceService] TTS completed');
    });
    
    _flutterTts.setErrorHandler((msg) {
      _isSpeaking = false;
      onSpeakingStateChanged?.call(false, '');
      currentText = '';
      debugPrint('[VoiceService] TTS error: $msg');
    });
  }
  
  /// Start listening for voice commands
  /// Similar to Python's _record_audio + _speech_to_text
  Future<void> startListening() async {
    if (!_isInitialized) {
      debugPrint('[VoiceService] Not initialized');
      return;
    }
    
    if (_isListening) {
      debugPrint('[VoiceService] Already listening');
      return;
    }
    
    try {
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            final text = result.recognizedWords.toLowerCase();
            debugPrint('[VoiceService] Recognized: $text');
            
            // Check for wake word
            if (text.contains(_wakeWord)) {
              _wakeWordDetected = true;
              onWakeWordDetected?.call();
              debugPrint('[VoiceService] Wake word detected!');
            }
            
            onTextRecognized?.call(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        cancelOnError: true,
      );
    } catch (e) {
      debugPrint('[VoiceService] Start listening error: $e');
    }
  }
  
  /// Stop listening
  Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      _isListening = false;
      onListeningStateChanged?.call(false);
    }
  }
  
  /// Speak text using TTS
  /// Similar to Python's speak_tts function
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      debugPrint('[VoiceService] Not initialized');
      return;
    }
    
    try {
      debugPrint('[VoiceService] Speaking: $text');
      // Store text for callback
      await _setupTts(); // Re-setup to capture text in closure
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('[VoiceService] Speak error: $e');
    }
  }
  
  /// Stop speaking
  Future<void> stopSpeaking() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      _isSpeaking = false;
      onSpeakingStateChanged?.call(false, '');
    }
  }
  
  /// Enable continuous wake word detection (background listening)
  Future<void> enableWakeWordDetection() async {
    if (!_isInitialized) return;
    
    // Start continuous listening in background
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!_isListening && !_isSpeaking) {
        await startListening();
      }
    });
  }
  
  /// Dispose resources
  Future<void> dispose() async {
    await stopListening();
    await stopSpeaking();
    await _speechToText.cancel();
  }
}

