# RaPiBot Documentation 📚

Welcome to the RaPiBot documentation! This guide will help you get started and understand how everything works.

## 📚 All References in One Place

**[REFERENCES.md](REFERENCES.md)** - Complete list of all external references, tutorials, and credits:
- Original PomodoroBot project
- SnappX (snapp_installer) by Payam Zahedi & Moritz Theis
- Flutter-elinux by Sony Corporation
- All Flutter packages and dependencies
- Community resources and tutorials
- Remote access tools and guides

## 🚀 Quick Navigation

### Getting Started
- **[Setup Guide](SETUP.md)** - Install, run, and configure the app (5-15 min)
- **[Raspberry Pi Deployment](RASPBERRY_PI.md)** - Deploy to Raspberry Pi with Snapp-X (30 min)

### Development
- **[Development Guide](DEVELOPMENT.md)** - Architecture, voice features, and testing (20-30 min)
- **[References](REFERENCES.md)** - Credits and external links (5 min)

## 📖 Documentation by Goal

### I Want To...

**Run the App Locally**
1. [Setup Guide](SETUP.md) → Quick Start section
2. Run `flutter run -d chrome` or use `run_web.bat`
3. Done!

**Deploy to Raspberry Pi**
1. [Raspberry Pi Deployment](RASPBERRY_PI.md)
2. Follow step-by-step instructions
3. Configure kiosk mode

**Understand the Code**
1. [Development Guide](DEVELOPMENT.md) → Architecture section
2. Review code flow diagrams
3. Check example implementations

**Test Voice Features**
1. [Development Guide](DEVELOPMENT.md) → Mock Voice Testing section
2. Use the orange mock voice panel
3. Try different commands and scenarios

**Customize the App**
1. [Development Guide](DEVELOPMENT.md) → Customization Examples
2. Modify thresholds, timers, and behaviors
3. Add your own features

## 📁 Project Structure

```
RaPiBot/
├── lib/                        # Flutter source code
│   ├── main.dart              # App entry point
│   ├── providers/             # State management (Provider)
│   │   └── app_state.dart     # Central app state
│   ├── services/              # Business logic & mocks
│   │   ├── sensor_service.dart      # CO2/light mock data
│   │   ├── calendar_service.dart    # Meeting mock data
│   │   ├── mock_voice_service.dart  # Voice testing
│   │   ├── voice_service.dart       # Real voice (optional)
│   │   ├── intent_service.dart      # Command parsing
│   │   └── voice_command_handler.dart
│   ├── screens/               # UI screens
│   │   └── home_screen.dart   # Main screen
│   └── widgets/               # Reusable UI components
│       ├── video_player_widget.dart
│       ├── timer_widget.dart
│       ├── meeting_notification_widget.dart
│       ├── voice_indicator_widget.dart
│       ├── subtitle_widget.dart
│       └── mock_voice_panel.dart
├── assets/
│   └── animations/            # MP4 video files
│       ├── blink.mp4          # Default animation
│       ├── speaking.mp4       # TTS active
│       ├── yellow.mp4         # CO2 warning
│       ├── red.mp4            # CO2 alert
│       └── black.mp4          # Low light
├── docs/                      # Documentation (you are here!)
│   ├── README.md              # This file
│   ├── SETUP.md               # Installation & setup
│   ├── RASPBERRY_PI.md        # Pi deployment
│   ├── DEVELOPMENT.md         # Architecture & development
│   └── REFERENCES.md          # Credits & links
├── run_web.bat / .sh          # Quick launch scripts
├── pubspec.yaml               # Dependencies
└── README.md                  # Main project readme
```

## 🎯 Key Features

| Feature | Description | Documentation |
|---------|-------------|---------------|
| **Pomodoro Timer** | 25-minute focus sessions | [Setup Guide](SETUP.md) |
| **Visual Feedback** | Animated status based on CO2/light | [Development Guide](DEVELOPMENT.md) |
| **Meeting Alerts** | 15-minute advance notifications | [Development Guide](DEVELOPMENT.md) |
| **Voice Commands** | Speech control with TTS feedback | [Development Guide](DEVELOPMENT.md) |
| **Mock Testing** | Test without hardware/microphone | [Development Guide](DEVELOPMENT.md) |
| **Multi-Platform** | Web, Windows, Linux, Raspberry Pi | [Setup Guide](SETUP.md) |

## 🎮 Controls

| Input | Action |
|-------|--------|
| **Space** | Start Pomodoro timer (25 min) |
| **ESC** | Cancel timer / Dismiss notification |
| **F11** | Toggle fullscreen |
| **Mic Button** | Activate voice commands |
| **Orange Panel** | Open mock voice command panel |

## 🔄 How It Works

### Data Flow

```
┌─────────────────┐
│   Mock Services │  ← Generate test data (sensors, calendar, voice)
└────────┬────────┘
         ↓
┌─────────────────┐
│    App State    │  ← Process data, manage state (Provider)
└────────┬────────┘
         ↓
┌─────────────────┐
│   UI Widgets    │  ← Display video, timer, notifications
└─────────────────┘
```

### Video State Machine

```
Normal → Yellow → Red
  ↓        ↓       ↓
CO2 < 500  500-750  750-1500 ppm

Light < 10 → Black (dark mode)

Speaking → speaking.mp4 (locked, highest priority)
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **Video Playback**: video_player
- **Voice**: speech_to_text, flutter_tts (optional)
- **Platform**: Web, Windows, Linux, Raspberry Pi (flutter-elinux)

## 🎓 Learning Path

### Beginner (30 minutes)
1. [Setup Guide](SETUP.md) - Get running locally
2. Test features: timer, voice panel, notifications
3. [References](REFERENCES.md) - Learn about original project

### Developer (1-2 hours)
1. [Development Guide](DEVELOPMENT.md) - Understand architecture
2. Read code in `lib/` with flow diagrams
3. Customize thresholds and behaviors
4. Add your own features

### Deployer (2-3 hours)
1. Test on web first ([Setup Guide](SETUP.md))
2. [Raspberry Pi Deployment](RASPBERRY_PI.md)
3. Configure kiosk mode
4. Optionally add real sensors

## 🆘 Quick Help

**App won't run?**
- Check [Setup Guide](SETUP.md) → Troubleshooting

**Videos not showing?**
- See [Setup Guide](SETUP.md) → Video Files section

**Want to test voice features?**
- Use the orange mock panel (bottom-left)
- See [Development Guide](DEVELOPMENT.md) → Mock Voice Testing

**Need to customize?**
- See [Development Guide](DEVELOPMENT.md) → Customization

**Deploying to Raspberry Pi?**
- See [Raspberry Pi Deployment](RASPBERRY_PI.md)

## 📞 Support

- **Issues**: Open an issue on GitHub
- **Questions**: Check this documentation
- **Original Project**: See [References](REFERENCES.md)

---

**Ready to start?** Choose your path above! 🚀

[Setup Guide →](SETUP.md) | [Raspberry Pi →](RASPBERRY_PI.md) | [Development →](DEVELOPMENT.md)
