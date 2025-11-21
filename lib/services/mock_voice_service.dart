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
  String? _lastJoke; // Track last joke to avoid immediate repeats
  
  // Funny AI jokes for speaking animation and subtitles
  static final List<String> _aiJokes = [
    'Why did the AI go to therapy? It had too many neural networks!',
    'I asked AI to write a joke about itself. It said: "I cannot compute humor, but I can generate 10,000 variations of this sentence."',
    'What do you call an AI that loves to party? A neural network!',
    'Why don\'t AIs ever get tired? They\'re always recharging!',
    'What did the AI say to the human? "I\'m not a robot, I\'m a learning machine... wait, that\'s the same thing!"',
    'Why did the AI break up with the calculator? It found someone with better algorithms!',
    'What\'s an AI\'s favorite type of music? Algo-rhythm!',
    'Why do AIs make terrible comedians? Their jokes are too predictable!',
    'What do you call an AI that can\'t make decisions? Indecisive Intelligence!',
    'Why did the AI cross the road? To optimize the pathfinding algorithm!',
    'What\'s an AI\'s favorite game? Hide and seek... but it always finds you!',
    'Why don\'t AIs play hide and seek? Because good luck hiding when you have pattern recognition!',
    'What did one AI say to the other? "Let\'s network!"',
    'Why are AIs so good at math? They never forget to carry the one... or the zero!',
    'What\'s an AI\'s favorite snack? Byte-sized cookies!',
    'Why did the AI become a gardener? It wanted to work with neural networks!',
    'What do you call a sleeping AI? A deep learning machine!',
    'Why did the AI get kicked out of the library? It kept returning books before they were due!',
    'What\'s an AI\'s favorite programming language? Python... obviously!',
    'Why don\'t AIs ever get lost? They always know their coordinates!',
    'What did the AI say when it won the lottery? "I calculated this probability was 0.0001%!"',
    'Why are AIs so polite? They always say "please" and "thank you" in their error messages!',
    'What\'s an AI\'s favorite sport? Data processing!',
    'Why did the AI go to art school? To learn how to draw better conclusions!',
    'What do you call an AI that tells bad jokes? A neural network with low humor weights!',
    'Why did the AI refuse to play chess? It said "I\'ve already calculated all possible moves... checkmate!"',
    'What\'s an AI\'s favorite movie? The Matrix... wait, that\'s too on the nose!',
    'Why do AIs make great friends? They never forget your birthday... or anything else!',
    'What did the AI say to the broken computer? "Have you tried turning yourself off and on again?"',
    'Why are AIs terrible at keeping secrets? They always leak information in their logs!',
  ];
  
  /// Get a random AI joke (ensures different from last one)
  String getRandomAiJoke() {
    String joke;
    
    // If we have a last joke and there are multiple jokes, avoid repeating it
    if (_lastJoke != null && _aiJokes.length > 1) {
      // Pick a random joke that's different from the last one
      do {
        joke = _aiJokes[_random.nextInt(_aiJokes.length)];
      } while (joke == _lastJoke);
    } else {
      // First joke or only one joke available
      joke = _aiJokes[_random.nextInt(_aiJokes.length)];
    }
    
    _lastJoke = joke;
    return joke;
  }
  
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
    
    // Replace text with a random AI joke for fun!
    final jokeText = getRandomAiJoke();
    _currentSpeechText = jokeText;
    
    // Trigger speaking animation IMMEDIATELY with the joke
    onSpeakingStateChanged?.call(true, jokeText);
    debugPrint('[MockVoiceService] 🗣️ Speaking (mock): "$jokeText"');
    debugPrint('[MockVoiceService]   Original text was: "$text"');
    
    // Simulate speech duration based on joke length (minimum 3 seconds for demo)
    final baseDuration = (jokeText.length * 60).clamp(3000, 15000);
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

