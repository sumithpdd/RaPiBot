# DevFest London 2025 Photo Booth 📸🎉

An interactive Flutter-based photo booth for DevFest London 2025 with voice control, environmental monitoring, and animated visual feedback.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-blue.svg" alt="Flutter">
  <img src="https://img.shields.io/badge/Platform-Web%20%7C%20Windows%20%7C%20Linux%20%7C%20RaspberryPi-green.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Event-DevFest%20London%202025-orange.svg" alt="DevFest">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
</p>

## 🎯 What is This?

An intelligent photo booth experience for DevFest London 2025 featuring:
- 📸 **Photo Session Timer** - Countdown for perfect photo moments
- 🎤 **Voice Control** - "Start photo timer!" hands-free operation
- 🌡️ **Environmental Monitoring** - CO2 and light sensor visualization
- 🎥 **Animated Feedback** - Dynamic visual status indicators
- 🤖 **AI Companion** - Interactive voice assistant

Built with Flutter for DevFest London 2025. Based on [CodersCafeTech/PomodoroBot](https://github.com/CodersCafeTech/PomodoroBot).

## ⚡ Quick Start

### Run on Web (Testing)

```bash
# 1. Install dependencies
flutter pub get

# 2. Run on web
flutter run -d chrome

# Or use helper scripts:
# Windows:
run_web.bat

# Linux/Mac:
./run_web.sh
```

### Welcome Message

On startup, you'll hear:
> **"Welcome to DevFest London 2025! Ready to use our photo booth?"**

### Controls

- **Space** - Start photo session timer
- **Mic Button** - Voice commands
- **ESC** - Cancel/Dismiss
- **F11** - Fullscreen
- **Orange Panel** - Test voice commands

### Voice Commands

Try saying:
- "Start photo session for 5 minutes"
- "Set timer for 10 minutes"
- "Cancel timer"
- "What's happening"
- "Ready for photos?"

## 🎮 Features

| Feature | Description |
|---------|-------------|
| 📸 **Photo Timer** | Countdown for photo sessions |
| 🎤 **Voice Control** | Hands-free photo booth operation |
| 🎥 **Visual Feedback** | Animations based on CO2/light levels |
| 📅 **Session Alerts** | Upcoming session notifications |
| 🔧 **Mock Data** | Works without hardware sensors |
| 🖥️ **Multi-Platform** | Web, Windows, Linux, Raspberry Pi |

## 📁 Project Structure

```
DevFest-PhotoBooth/
├── lib/                    # Flutter app source code
│   ├── main.dart          # Entry point
│   ├── providers/         # State management
│   ├── services/          # Mock sensors, calendar & voice
│   ├── screens/           # UI screens
│   └── widgets/           # Reusable components
├── assets/
│   └── animations/        # MP4 video files
├── docs/                  # Documentation
│   ├── README.md          # Documentation index
│   ├── SETUP.md           # Complete setup guide
│   ├── DEVELOPMENT.md     # Architecture & dev guide
│   └── RASPBERRY_PI.md    # Raspberry Pi deployment
├── run_web.bat/.sh        # Quick launch scripts
├── pubspec.yaml           # Dependencies
└── README.md              # This file
```

## 📚 Documentation

All documentation is in the [`docs/`](docs/) folder:

| Document | Purpose |
|----------|---------|
| **[Setup Guide](docs/SETUP.md)** | Installation & configuration (5-15 min) |
| **[Development Guide](docs/DEVELOPMENT.md)** | Architecture & customization (20-30 min) |
| **[Raspberry Pi Setup](docs/RASPBERRY_PI.md)** | Deploy to Pi with Snapp-X (30 min) |
| **[References](docs/REFERENCES.md)** | Credits & external links |

## 🚀 Platform Support

| Platform | Status | Command |
|----------|--------|---------|
| **Web** | ✅ Testing | `flutter run -d chrome` |
| **Windows** | ✅ Desktop | `flutter run -d windows` |
| **Linux** | ✅ Desktop | `flutter run -d linux` |
| **Raspberry Pi** | ✅ Kiosk | See [Pi Setup with SnappX](docs/RASPBERRY_PI.md) |

## 🎨 Video States

The photo booth displays different animations based on environment:

| Video | Condition | Meaning |
|-------|-----------|---------|
| 🔵 `blink.mp4` | Normal | Ready for photos! |
| 🗣️ `speaking.mp4` | Voice active | AI assistant speaking |
| 🟡 `yellow.mp4` | CO2 warning | Environment warming up |
| 🔴 `red.mp4` | CO2 alert | Take a break! |
| ⚫ `black.mp4` | Dark | Low light detected |

## 🔄 How It Works

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐
│   Sensors   │────→│  App State   │────→│   UI Display    │
│ (Mock Data) │     │  (Provider)  │     │ (Video/Timer)   │
└─────────────┘     └──────────────┘     └─────────────────┘
     ↓                     ↓                      ↓
  Every 15s           Process Data         Update Visuals
  - CO2 levels        - Select video       - Animations
  - Light             - Timer state        - Countdown

┌─────────────┐     ┌──────────────┐     ┌─────────────────┐
│    Voice    │────→│  Intent AI   │────→│    Actions      │
│   Commands  │     │  (Recognize) │     │ (Timer/Photos)  │
└─────────────┘     └──────────────┘     └─────────────────┘
     ↓                     ↓                      ↓
  "Start timer"      Extract intent        Execute command
  Voice/Mock         Parse parameters      Speak response
```

## 🛠️ Requirements

- **Flutter SDK** 3.0+
- **Dart** 3.0+
- For Raspberry Pi: **SnappX installer** or **flutter-elinux** (see [Pi Setup](docs/RASPBERRY_PI.md))

## 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  video_player: ^2.8.1       # Video playback
  provider: ^6.1.1           # State management
  intl: ^0.18.1              # Date formatting
  speech_to_text: ^6.6.0     # Voice recognition
  flutter_tts: ^3.8.5        # Text-to-speech
  permission_handler: ^11.0.1 # Microphone permission
```

## 🎓 Getting Started

### For Event Attendees
1. Press **Space** or say **"Start photo timer"**
2. Get ready for your photo!
3. Pose when the countdown reaches zero! 📸

### For Setup/Testing
1. Read [Setup Guide](docs/SETUP.md) - Get running in 5 minutes
2. Test features using mock voice panel
3. Deploy to Raspberry Pi for event

### For Developers
1. Study [Development Guide](docs/DEVELOPMENT.md) - Architecture & code
2. Customize timer durations and messages
3. Add new voice commands and features

## 🎤 Voice Commands Reference

```
📸 Photo Session Commands:
   "Start photo session for 25 minutes"
   "Set timer for 10 minutes"
   "Cancel timer"

📊 Status Commands:
   "What's happening"
   "Ready for photos?"

🔊 Wake Word:
   "Hey Google" (then give command)
```

## 🙏 Credits & References

**Original Inspiration**:
- **PomodoroBot**: [CodersCafeTech/PomodoroBot](https://github.com/CodersCafeTech/PomodoroBot)

**Raspberry Pi Deployment**:
- **SnappX Installer**: [snappembedded.io](https://snappembedded.io) - One-line deployment tool
- **Tutorial**: [Flutter on Raspberry Pi (snapp_installer)](https://medium.com/snapp-x/flutter-on-raspberry-pi-raspi-flutter-e1760818ba0c)
- **Authors**: Payam Zahedi & Moritz Theis
- **Alternative**: [Flutter on Embedded Devices](https://medium.com/snapp-x/flutter-on-embedded-devices-7070b5907b91)
- **flutter-elinux**: [github.com/sony/flutter-elinux](https://github.com/sony/flutter-elinux)

**Complete References**: See [docs/REFERENCES.md](docs/REFERENCES.md) for all links and resources

## 📄 License

See [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Want to improve the photo booth experience?
1. Fork the repository
2. Create a feature branch
3. Test your changes
4. Submit a pull request

## 📞 Support

- **Setup Issues**: Check [docs/SETUP.md](docs/SETUP.md)
- **Development Questions**: See [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)
- **Pi Deployment**: Read [docs/RASPBERRY_PI.md](docs/RASPBERRY_PI.md)
- **GitHub Issues**: Open an issue for bugs/features

---

**Made with ❤️ for DevFest London 2025**

[Get Started →](docs/SETUP.md) | [Raspberry Pi Setup →](docs/RASPBERRY_PI.md) | [Documentation →](docs/README.md)

## 📸 Ready to Take Amazing Photos at DevFest London 2025! 🎉
