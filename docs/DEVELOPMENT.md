# Development Guide - Architecture & Features

Complete guide to RaPiBot's architecture, voice features, and testing.

---

## 📚 Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Component Details](#component-details)
3. [Voice Assistant](#voice-assistant)
4. [Mock Voice Testing](#mock-voice-testing)
5. [Customization Examples](#customization-examples)
6. [Extension Points](#extension-points)

---

## Architecture Overview

### Design Pattern

RaPiBot uses **Provider** for state management with clean separation:

```
┌──────────────────────────────────────────────────────┐
│              Presentation Layer                       │
│   (Widgets: Screens, Video, Timer, Notifications)   │
└───────────────────┬──────────────────────────────────┘
                    │
              User Events & UI Updates
                    │
┌───────────────────▼──────────────────────────────────┐
│            Business Logic Layer                       │
│         (Provider: AppState Manager)                  │
│  - Manages application state                         │
│  - Processes sensor data                             │
│  - Coordinates timer logic                           │
│  - Handles notifications & voice                     │
└───────────────────┬──────────────────────────────────┘
                    │
           Data Requests & Stream Updates
                    │
┌───────────────────▼──────────────────────────────────┐
│                Data Layer                             │
│    (Services: Sensors, Calendar, Voice, Intent)      │
│  - Generate/fetch sensor data                        │
│  - Generate/fetch calendar events                    │
│  - Process voice commands                            │
│  - Stream updates to business logic                  │
└──────────────────────────────────────────────────────┘
```

### State Machine

```
┌──────────────┐
│  Video Mode  │ ◄───────────────────────┐
│  (default)   │                         │
└──────┬───────┘                         │
       │                                 │
       │ Space/Button/Voice             │
       │                                 │
       ▼                                 │
┌──────────────┐    Timer Complete      │
│  Timer Mode  │    or ESC Key          │
│  (25:00)     │ ───────────────────────┤
└──────────────┘                         │
                                        │
┌──────────────┐    Dismiss or          │
│ Notification │    ESC Key             │
│    Mode      │ ───────────────────────┘
└──────────────┘
```

---

## Component Details

### 1. Main Application (`main.dart`)

**Purpose:** Initialize app, configure system UI, setup dependency injection

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        Provider(create: (_) => SensorService()),
        Provider(create: (_) => CalendarService()),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 2. App State (`providers/app_state.dart`)

**Central state management with these responsibilities:**

- Track current mode (video/timer/notification)
- Process sensor data and select video
- Manage timer countdown
- Handle meeting notifications
- Control voice state (speaking/listening)

**Key Methods:**

| Method | Purpose |
|--------|---------|
| `setVideoMode(path)` | Switch to video playback |
| `setTimerMode(seconds)` | Start Pomodoro timer |
| `updateTimerSeconds(secs)` | Countdown tick |
| `showMeetingNotification(meeting)` | Display alert |
| `handleSensorData(data)` | Process CO2/light |
| `setSpeaking(speaking, text)` | Control TTS state |
| `setListening(listening)` | Control STT state |

**Video Selection Logic:**

```dart
void handleSensorData(Map<String, dynamic> sensorData) {
  // 🛡️ Protected - speaking has priority
  if (_isSpeaking || _isListening) return;
  
  String videoPath = 'assets/animations/blink.mp4'; // Default
  
  // CO2 thresholds
  if (co2 >= 500 && co2 < 750) {
    videoPath = 'assets/animations/yellow.mp4'; // Warning
  } else if (co2 >= 750 && co2 < 1500) {
    videoPath = 'assets/animations/red.mp4'; // Alert
  }
  
  // Light sensor (overrides CO2)
  if (lightIntensity < 10) {
    videoPath = 'assets/animations/black.mp4'; // Dark mode
  }
  
  if (_currentVideo != videoPath) {
    setVideoMode(videoPath);
  }
}
```

### 3. Sensor Service (`services/sensor_service.dart`)

**Mock sensor data generation:**

- Updates every **5 seconds**
- CO2 levels: 400-1500 ppm
- Light intensity: 0-100

**Probability Distribution:**
- Normal (CO2 < 500): 60%
- Warning (500-750): 25%
- Alert (750-1500): 15%
- Dark (light < 10): 15%

### 4. Calendar Service (`services/calendar_service.dart`)

**Mock meeting generation:**

- Checks every **1 minute**
- 30% chance of generating event
- 15-minute advance notification
- 10 meeting templates

### 5. Video Player Widget (`widgets/video_player_widget.dart`)

**FutureBuilder-based video playback:**

```dart
FutureBuilder(
  future: _initializeVideoPlayerFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return VideoPlayer(_controller); // ✅ Show video
    } else {
      return CircularProgressIndicator(); // ⏳ Loading
    }
  },
)
```

**Video Switching:**
- Speaking starts → `speaking.mp4` (🔒 locked)
- Speaking ends → Return to previous video
- Sensors update → Change based on CO2/light (blocked while speaking)

---

## Voice Assistant

### Overview

Voice assistant features converted from Python to Flutter:

| Feature | Python | Flutter |
|---------|--------|---------|
| **Speech-to-Text** | `speech_recognition` | `speech_to_text` |
| **Text-to-Speech** | `gTTS` + `mpg321` | `flutter_tts` |
| **Wake Word** | `pvporcupine` | Pattern matching |
| **Intent Parsing** | Regex | Regex (same) |

### Architecture

```
User speaks
    ↓
VoiceService (STT)
    ↓
IntentService (Parse command)
    ↓
VoiceCommandHandler (Execute action)
    ↓
AppState (Update UI)
    ↓
VoiceService (TTS response)
    ↓
speaking.mp4 animation
```

### Supported Commands

**Timer Commands:**
```
✅ "start pomodoro for 25 minutes"
✅ "start pomodoro for 15 minutes"
✅ "set timer for 10 minutes"
✅ "cancel timer"
```

**Notification Commands:**
```
✅ "dismiss notification"
✅ "show calendar"
```

**Status Commands:**
```
✅ "what's happening"
✅ "what's going on"
```

**Wake Word:**
```
✅ "hey google"
```

### Intent Recognition (`services/intent_service.dart`)

Uses regex patterns to extract intents:

```dart
static final List<Map<String, dynamic>> _intentPatterns = [
  {
    'name': 'set_pomodoro',
    'pattern': RegExp(
      r'(?:start|begin)\s+(?:a\s+)?pomodoro\s+(?:for\s+)?(\d+)\s+minutes?',
      caseSensitive: false,
    ),
    'extract': (match) => int.parse(match.group(1)!) * 60,
  },
  // ... more patterns
];
```

### Voice Services

#### Real Voice (`services/voice_service.dart`)

**Features:**
- Real speech recognition (requires microphone)
- Native TTS
- Permission handling
- Continuous listening mode
- Wake word detection

**Usage:**
```dart
final voiceService = VoiceService();
await voiceService.initialize();
voiceService.enableWakeWordDetection();

voiceService.onTextRecognized = (text) {
  processCommand(text);
};
```

#### Mock Voice (`services/mock_voice_service.dart`)

**Features:**
- Simulated speech recognition
- Simulated TTS timing
- Predefined command list
- Automated use cases
- No hardware required

**Usage:**
```dart
final mockVoice = MockVoiceService();
await mockVoice.initialize();

mockVoice.onTextRecognized = (text) {
  processCommand(text);
};

// Simulate command
mockVoice.simulateCommand("start pomodoro for 25 minutes");
```

### Voice Command Handler (`services/voice_command_handler.dart`)

**Processes intents and executes actions:**

```dart
Future<String> processCommand(String text) async {
  final intent = _intentService.extractIntent(text);
  
  switch (intent['name']) {
    case 'set_pomodoro':
      final seconds = intent['value'];
      _appState.setTimerMode(seconds);
      return 'Starting $minutes minute Pomodoro timer';
      
    case 'cancel_timer':
      _appState.stopTimer();
      return 'Timer cancelled';
      
    case 'whats_happening':
      return _getStatusMessage();
      
    // ... more intents
  }
}
```

### Speaking Animation

**Priority System:**

```
Speaking state = HIGHEST PRIORITY
    ↓
🔒 Lock to speaking.mp4
    ↓
🛡️ Block all other video changes:
   - Sensors blocked
   - Timer can't interrupt
   - Notifications can't interrupt
    ↓
Speaking completes
    ↓
🔓 Release lock
    ↓
Return to appropriate video
```

---

## Mock Voice Testing

### Why Mock Voice?

✅ **No hardware** - Test without microphone
✅ **Fast development** - Instant command testing
✅ **Automated scenarios** - Run use cases
✅ **Demo-ready** - Show features without speaking
✅ **Cross-platform** - Works everywhere

### Enable Mock Mode

In `lib/screens/home_screen.dart`:

```dart
bool _useMockVoice = true; // Enable mock voice
```

### Mock Voice Panel

**Orange button at bottom-left opens panel with:**

**Quick Commands Tab:**
- Single-click voice commands
- Instant execution
- See listening → recognition → action → TTS flow

**Use Cases Tab:**
- Multi-step scenarios
- Automated command sequences
- Customizable delays

### Available Commands

```
📢 "start pomodoro for 25 minutes"
📢 "start pomodoro for 15 minutes"
📢 "start pomodoro for 5 minutes"
📢 "set timer for 10 minutes"
📢 "set timer for 30 minutes"
📢 "cancel timer"
📢 "dismiss notification"
📢 "show calendar"
📢 "what's happening"
📢 "hey google"
```

### Use Cases

**1. Quick Pomodoro**
- Start 5-minute timer
- Test short duration

**2. Standard Pomodoro**
- Start 25-minute timer
- Standard workflow

**3. Check Status**
- Ask "what's happening"
- Get current state

**4. Cancel and Restart**
- Start timer → Cancel → Start new
- Test interruption handling

**5. Wake Word Flow**
- Say "hey google"
- Then give command
- Test wake word detection

**6. Multiple Queries**
- Ask multiple questions
- Test conversation flow

### Console Debug Output

```
[MockVoiceService] 🗣️ Speaking: "Starting 25 minute Pomodoro"
[MockVoiceService]   Duration: 3s
[AppState] 🗣️ Switching to speaking animation
[VideoPlayer] ✓ Video ready: speaking.mp4
[AppState] 🛡️ Sensors blocked - currently speaking
[MockVoiceService] ✓ Finished speaking
[AppState] ✓ Returning to blink animation
```

---

## Customization Examples

### Change Timer Duration

**File:** `lib/screens/home_screen.dart`

```dart
void _startPomodoroTimer() {
  // Change from 25 to 15 minutes
  final duration = 15 * 60; // 15 minutes in seconds
  appState.setTimerMode(duration);
}
```

### Adjust CO2 Thresholds

**File:** `lib/providers/app_state.dart`

```dart
void handleSensorData(Map<String, dynamic> sensorData) {
  if (co2 >= 600 && co2 < 900) {    // Changed from 500-750
    videoPath = 'assets/animations/yellow.mp4';
  } else if (co2 >= 900) {           // Changed from 750
    videoPath = 'assets/animations/red.mp4';
  }
}
```

### Change Sensor Update Frequency

**File:** `lib/services/sensor_service.dart`

```dart
Stream<Map<String, dynamic>> getSensorDataStream() {
  return Stream.periodic(const Duration(seconds: 10), (_) { // Changed from 5
    return _getMockSensorData();
  });
}
```

### Add Custom Voice Command

**File:** `lib/services/intent_service.dart`

```dart
{
  'name': 'take_break',
  'pattern': RegExp(
    r'(?:take|start)\s+(?:a\s+)?break',
    caseSensitive: false,
  ),
  'description': 'Start a break',
},
```

**File:** `lib/services/voice_command_handler.dart`

```dart
case 'take_break':
  _appState.setTimerMode(5 * 60); // 5-minute break
  return 'Starting a 5-minute break';
```

### Add New Video State

**1. Add video file:**
```
assets/animations/break.mp4
```

**2. Update pubspec.yaml:**
```yaml
flutter:
  assets:
    - assets/animations/break.mp4
```

**3. Add logic in `app_state.dart`:**
```dart
if (_isOnBreak) {
  _currentVideo = 'assets/animations/break.mp4';
}
```

### Customize TTS Voice

**File:** `lib/services/mock_voice_service.dart` or `voice_service.dart`

```dart
Future<void> speak(String text) async {
  // Adjust speech rate
  await _flutterTts.setSpeechRate(0.5); // Slower (0.5-1.5)
  
  // Adjust pitch
  await _flutterTts.setPitch(1.2); // Higher pitch
  
  // Adjust volume
  await _flutterTts.setVolume(0.8); // 80% volume
  
  await _flutterTts.speak(text);
}
```

---

## Extension Points

### Add Real Sensors

**Replace `SensorService` with Viam client:**

```dart
import 'package:viam_sdk/viam_sdk.dart';

class RealSensorService {
  late RobotClient robot;
  late Sensor ens160;
  late Sensor temt6000;
  
  Future<void> initialize() async {
    robot = await RobotClient.atAddress('robot.local');
    ens160 = Sensor.fromRobot(robot, 'ENS160');
    temt6000 = Sensor.fromRobot(robot, 'TEMT6000');
  }
  
  Stream<Map<String, dynamic>> getSensorDataStream() async* {
    while (true) {
      final co2 = await ens160.getReadings();
      final light = await temt6000.getReadings();
      
      yield {
        'eCO2': co2['eCO2'],
        'light_intensity': light['intensity'],
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
```

### Add Real Calendar

**Replace `CalendarService` with Google Calendar API:**

```dart
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

class RealCalendarService {
  late CalendarApi calendarApi;
  
  Future<void> initialize() async {
    final credentials = await obtainCredentials();
    final client = authenticatedClient(httpClient, credentials);
    calendarApi = CalendarApi(client);
  }
  
  Stream<Map<String, dynamic>?> getUpcomingMeetingStream() async* {
    while (true) {
      final now = DateTime.now();
      final events = await calendarApi.events.list(
        'primary',
        timeMin: now,
        timeMax: now.add(const Duration(minutes: 15)),
      );
      
      if (events.items != null && events.items!.isNotEmpty) {
        final event = events.items!.first;
        yield {
          'summary': event.summary,
          'start': event.start?.dateTime?.toIso8601String(),
          'end': event.end?.dateTime?.toIso8601String(),
          'id': event.id,
        };
      }
      
      await Future.delayed(const Duration(minutes: 1));
    }
  }
}
```

### Add GPIO Button (Raspberry Pi)

```dart
import 'package:gpio/gpio.dart';

class ButtonService {
  late GpioPin button;
  
  void initialize() {
    button = GpioPin(17, GpioPinDirection.input);
    button.listenForInterrupt(GpioInterrupt.fallingEdge)
      .listen((event) {
        _onButtonPressed();
      });
  }
  
  void _onButtonPressed() {
    // Start Pomodoro when button pressed
    appState.setTimerMode(25 * 60);
  }
}
```

---

## 📚 Additional Resources

- **Original Project:** [CodersCafeTech/PomodoroBot](https://github.com/CodersCafeTech/PomodoroBot)
- **Flutter Provider:** [pub.dev/packages/provider](https://pub.dev/packages/provider)
- **Speech to Text:** [pub.dev/packages/speech_to_text](https://pub.dev/packages/speech_to_text)
- **Flutter TTS:** [pub.dev/packages/flutter_tts](https://pub.dev/packages/flutter_tts)
- **Video Player:** [pub.dev/packages/video_player](https://pub.dev/packages/video_player)

---

[← Back to Documentation](README.md) | [Setup Guide →](SETUP.md) | [References →](REFERENCES.md)

