/// Intent recognition service
/// Converts Python's regex-based intent extraction
class IntentService {
  /// Intent patterns - Photo booth focused commands
  static final List<Map<String, dynamic>> _intentPatterns = [
    {
      'name': 'take_photo',
      'pattern': RegExp(
        r'(?:take|snap|capture)\s+(?:a\s+)?(?:photo|picture|selfie)',
        caseSensitive: false,
      ),
      'description': 'Take a photo',
    },
    {
      'name': 'start_photo_session',
      'pattern': RegExp(
        r'(?:start|begin)\s+(?:photo|picture)\s+(?:session|timer)\s+(?:for\s+)?(\d+)\s+minutes?',
        caseSensitive: false,
      ),
      'description': 'Start photo session',
    },
    {
      'name': 'ready_for_photo',
      'pattern': RegExp(
        r'(?:ready|prepared)\s+(?:for\s+)?(?:photo|picture|photoshoot)',
        caseSensitive: false,
      ),
      'description': 'User ready for photo',
    },
    {
      'name': 'use_photobooth',
      'pattern': RegExp(
        r'(?:use|try)\s+(?:the\s+)?(?:photo\s*booth|photobooth)',
        caseSensitive: false,
      ),
      'description': 'Use photo booth',
    },
    {
      'name': 'set_pomodoro',
      'pattern': RegExp(
        r'(?:start|begin)\s+(?:pomodoro|timer)\s+(?:for\s+)?(\d+)\s+minutes?',
        caseSensitive: false,
      ),
      'description': 'Start a timer',
    },
    {
      'name': 'set_timer',
      'pattern': RegExp(
        r'(?:set|start)\s+(?:a\s+)?timer\s+(?:for\s+)?(\d+)\s+(minutes?|seconds?)',
        caseSensitive: false,
      ),
      'description': 'Set a timer',
    },
    {
      'name': 'cancel_timer',
      'pattern': RegExp(
        r'(?:cancel|stop)\s+(?:timer|photo|session)',
        caseSensitive: false,
      ),
      'description': 'Cancel current session',
    },
    {
      'name': 'how_does_it_work',
      'pattern': RegExp(
        r'(?:how\s+does\s+(?:this|it)\s+work|how\s+to\s+use)',
        caseSensitive: false,
      ),
      'description': 'Explain how to use',
    },
    {
      'name': 'whats_happening',
      'pattern': RegExp(
        r"(?:what'?s\s+happening|status|what'?s\s+going\s+on|what\s+can\s+you\s+do)",
        caseSensitive: false,
      ),
      'description': 'Get current status',
    },
    {
      'name': 'show_calendar',
      'pattern': RegExp(
        r'(?:show|display)\s+(?:calendar|events|schedule)',
        caseSensitive: false,
      ),
      'description': 'Ready for photos',
    },
    {
      'name': 'dismiss',
      'pattern': RegExp(
        r'(?:dismiss|close)\s+(?:notification|window|alert)',
        caseSensitive: false,
      ),
      'description': 'Dismiss notification',
    },
  ];
  
  /// Extract intent from text using regex patterns
  Intent? extractIntent(String text) {
    final normalized = text.toLowerCase().trim();
    
    for (var intentPattern in _intentPatterns) {
      final pattern = intentPattern['pattern'] as RegExp;
      final match = pattern.firstMatch(normalized);
      
      if (match != null) {
        // Extract parameters from regex groups
        final params = <String>[];
        for (int i = 1; i <= match.groupCount; i++) {
          final group = match.group(i);
          if (group != null) {
            params.add(group);
          }
        }
        
        return Intent(
          name: intentPattern['name'] as String,
          parameters: params,
          confidence: 1.0,
          originalText: text,
        );
      }
    }
    
    return null;
  }
  
  /// Get all available intents (for help/documentation)
  List<String> getAvailableIntents() {
    return _intentPatterns
        .map((p) => '${p['name']}: ${p['description']}')
        .toList();
  }
}

/// Intent data class
class Intent {
  final String name;
  final List<String> parameters;
  final double confidence;
  final String originalText;
  
  Intent({
    required this.name,
    required this.parameters,
    required this.confidence,
    required this.originalText,
  });
  
  @override
  String toString() {
    return 'Intent(name: $name, params: $parameters, confidence: $confidence)';
  }
}

