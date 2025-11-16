# References & Credits

This document contains all external references, credits, and useful links for the RaPiBot project.

## 📚 Primary References

### Original PomodoroBot Project

**Repository**: [CodersCafeTech/PomodoroBot](https://github.com/CodersCafeTech/PomodoroBot)

This Flutter app is a complete reimplementation of the original Python-based PomodoroBot:

- **Original Language**: Python
- **Original Platform**: Raspberry Pi (Linux only)
- **Original UI**: Tkinter + OpenCV
- **Original Sensors**: Viam SDK with ENS160 (CO2) and TEMT6000 (light)
- **Original Calendar**: Viam Calendar Service (Google Calendar)
- **Original Input**: GPIO button on pin 17

**Key Files from Original**:
- `main.py` - Main application logic
- `animations/` - MP4 video files for visual feedback
  - `blink.mp4` - Default/normal state
  - `yellow.mp4` - CO2 warning (500-750 ppm)
  - `red.mp4` - CO2 alert (750-1500 ppm)
  - `black.mp4` - Dark/low light state

**Original Features Preserved**:
- ✅ 25-minute Pomodoro timer
- ✅ CO2-based video switching
- ✅ Light-based video switching
- ✅ Meeting notifications (15-minute advance)
- ✅ Full-screen display
- ✅ Button/keyboard trigger

**New Features in Flutter Version**:
- ✅ Multi-platform support (Web, Windows, Linux, Raspberry Pi)
- ✅ Mock data for testing without hardware
- ✅ Modern state management (Provider pattern)
- ✅ Better UI/UX with Flutter widgets
- ✅ Easier deployment and configuration

### Snapp-X Flutter on Raspberry Pi Guides

#### SnappX (snapp_installer) - Recommended Method

**Tool**: [snapp_installer](https://github.com/Snapp-Embedded/snapp_installer)  
**Website**: [snappembedded.io](https://snappembedded.io)  
**Article**: [Flutter on Raspberry Pi (snapp_installer)](https://medium.com/snapp-x/flutter-on-raspberry-pi-raspi-flutter-e1760818ba0c)  
**Authors**: Payam Zahedi & Moritz Theis  
**Published**: October 2023

SnappX (snapp_installer) is a command-line tool that simplifies Flutter deployment on Raspberry Pi.

**Features**:
- ✅ One-line installation: `bash <(curl -fSL https://snappembedded.io/installer)`
- ✅ Automatic Flutter environment setup
- ✅ Built-in kiosk mode support
- ✅ Auto-login configuration
- ✅ System diagnostics with `doctor` command
- ✅ Easy enable/disable for kiosk mode

**Key Commands**:
- `snapp_installer doctor` - Check installation status
- `snapp_installer install` - Install Flutter environment
- `snapp_installer kiosk <path>` - Enable kiosk mode
- `snapp_installer disable_kiosk` - Disable kiosk mode
- `snapp_installer autologin` - Enable auto-login

See [RASPBERRY_PI.md](RASPBERRY_PI.md) for complete deployment guide.

#### Flutter-elinux - Alternative Method

**Tool**: [flutter-elinux](https://github.com/sony/flutter-elinux)  
**Article**: [Flutter on Embedded Devices](https://medium.com/snapp-x/flutter-on-embedded-devices-7070b5907b91)  
**Authors**: Payam Zahedi & Moritz Theis  
**Developer**: Sony Corporation  
**Published**: July 2023

Flutter-elinux provides Flutter runtime for embedded Linux devices.

**Features**:
- ✅ Works on Raspberry Pi and other ARM64 devices
- ✅ Supports Wayland and X11 backends
- ✅ Compatible with standard Flutter code
- ✅ Regular updates from Sony
- ✅ Production-ready for industrial projects

**Backends**:
- `elinux-wayland` - Modern compositor (recommended)
- `elinux-x11` - Traditional X server

**Installation**:
```bash
git clone https://github.com/sony/flutter-elinux.git
sudo mv flutter-elinux /opt/
export PATH=$PATH:/opt/flutter-elinux/bin
flutter-elinux doctor
```

See [RASPBERRY_PI.md](RASPBERRY_PI.md) for manual deployment guide.

## 🛠️ Technology Stack

### Flutter Framework

**Website**: [flutter.dev](https://flutter.dev)  
**GitHub**: [flutter/flutter](https://github.com/flutter/flutter)  
**Documentation**: [docs.flutter.dev](https://docs.flutter.dev)

**Why Flutter?**:
- Cross-platform (Web, Desktop, Mobile, Embedded)
- Single codebase for all platforms
- Beautiful UI with Material Design
- Hot reload for fast development
- Strong community support

**Flutter Version Used**: 3.0+  
**Dart Version Used**: 3.0+

### Flutter Packages

#### video_player (^2.8.1)
**Package**: [pub.dev/packages/video_player](https://pub.dev/packages/video_player)  
**Purpose**: Play MP4 videos in the app  
**Used for**: Animation playback based on sensor data and AI states

#### provider (^6.1.1)
**Package**: [pub.dev/packages/provider](https://pub.dev/packages/provider)  
**Purpose**: State management  
**Used for**: Managing app state (video mode, timer, notifications, voice states)

#### intl (^0.18.1)
**Package**: [pub.dev/packages/intl](https://pub.dev/packages/intl)  
**Purpose**: Internationalization and date formatting  
**Used for**: Formatting meeting times

#### speech_to_text (^6.6.0)
**Package**: [pub.dev/packages/speech_to_text](https://pub.dev/packages/speech_to_text)  
**Purpose**: Speech recognition (STT)  
**Used for**: Voice command detection and wake word recognition

#### flutter_tts (^3.8.5)
**Package**: [pub.dev/packages/flutter_tts](https://pub.dev/packages/flutter_tts)  
**Purpose**: Text-to-speech (TTS)  
**Used for**: AI voice responses and speaking animations

#### permission_handler (^11.3.0)
**Package**: [pub.dev/packages/permission_handler](https://pub.dev/packages/permission_handler)  
**Purpose**: Runtime permissions  
**Used for**: Requesting microphone access for voice features

### flutter-elinux (Raspberry Pi)

**GitHub**: [sony/flutter-elinux](https://github.com/sony/flutter-elinux)  
**Developer**: Sony Corporation  
**Purpose**: Flutter runtime for embedded Linux systems

**Platforms Supported**:
- Raspberry Pi (ARM64)
- Other ARM-based Linux devices
- x64 Linux embedded systems

**Why flutter-elinux?**:
- Official Flutter doesn't support Raspberry Pi directly
- Optimized for embedded systems
- Compatible with standard Flutter code
- Regular updates and maintenance

## 🔧 Hardware Components

### Sensors (Original Project)

#### ENS160 - CO2 Sensor
**Type**: Indoor Air Quality Sensor  
**Manufacturer**: ScioSense (formerly AMS)  
**Measures**: eCO2, TVOC, AQI  
**Interface**: I2C  
**Range**: 400-65000 ppm eCO2

**In Our Project**: Simulated with mock data (400-1500 ppm)

#### TEMT6000 - Light Sensor
**Type**: Ambient Light Sensor  
**Manufacturer**: Vishay  
**Measures**: Light intensity  
**Interface**: Analog  
**Range**: 0-1000 lux

**In Our Project**: Simulated with mock data (0-100)

### Hardware Platform

#### Raspberry Pi
**Recommended Models**:
- Raspberry Pi 4 (4GB+ RAM)
- Raspberry Pi 3 B+
- Raspberry Pi 400

**Operating System**: Raspberry Pi OS (64-bit)  
**Display**: HDMI-connected monitor or touchscreen

#### GPIO Button (Original)
**Pin**: GPIO 17  
**Type**: Push button (normally open)  
**Wiring**: Button between GPIO 17 and GND

**In Our Project**: Simulated with Space bar key

## 📖 Related Documentation

### Viam Robotics Platform

**Website**: [viam.com](https://www.viam.com)  
**Docs**: [docs.viam.com](https://docs.viam.com)  
**GitHub**: [viamrobotics](https://github.com/viamrobotics)

The original project used Viam SDK for sensor and calendar integration.

**Key Services Used (Original)**:
- Sensor components (ENS160, TEMT6000)
- Generic service (Calendar integration)
- Robot client (Connection management)

**In Our Project**: Replaced with mock services for testing

### Google Calendar API

**Docs**: [developers.google.com/calendar](https://developers.google.com/calendar)  
**API**: [calendar.google.com/calendar/r/settings/export](https://calendar.google.com/calendar/r/settings/export)

**Original Integration**: Via Viam Calendar Service  
**Our Implementation**: Mock calendar with random events

**To Integrate Real Calendar**:
1. Get Google Calendar API credentials
2. Add `googleapis` package
3. Replace mock service in `lib/services/calendar_service.dart`

### Pomodoro Technique

**Inventor**: Francesco Cirillo  
**Website**: [francescocirillo.com/pages/pomodoro-technique](https://francescocirillo.com/pages/pomodoro-technique)

**The Technique**:
1. Choose a task
2. Set timer for 25 minutes (one "pomodoro")
3. Work without interruption
4. Take a 5-minute break
5. After 4 pomodoros, take a longer break (15-30 minutes)

**Our Implementation**: 25-minute timer with fullscreen countdown

## 🎓 Learning Resources

### Flutter Learning

- [Flutter Documentation](https://docs.flutter.dev)
- [Flutter Codelabs](https://docs.flutter.dev/codelabs)
- [Flutter YouTube Channel](https://www.youtube.com/c/flutterdev)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)

### Raspberry Pi Resources

- **Official Website**: [raspberrypi.com](https://www.raspberrypi.com)
- **Documentation**: [raspberrypi.com/documentation](https://www.raspberrypi.com/documentation/)
- **SSH Guide**: [Remote Access Documentation](https://www.raspberrypi.com/documentation/computers/remote-access.html)
- **Raspberry Pi Imager**: [raspberrypi.com/software](https://www.raspberrypi.com/software/)
- **GPIO Pin Guide**: [pinout.xyz](https://pinout.xyz)
- **Forums**: [forums.raspberrypi.com](https://forums.raspberrypi.com)

### Remote Access Tools

- **RealVNC Viewer**: [realvnc.com/en/connect/download/viewer](https://www.realvnc.com/en/connect/download/viewer/)
- **VS Code Remote SSH**: [code.visualstudio.com/docs/remote/ssh](https://code.visualstudio.com/docs/remote/ssh)
- **PuTTY (Windows SSH)**: [putty.org](https://www.putty.org)

### State Management (Provider)

- [Provider Package Docs](https://pub.dev/packages/provider)
- [Flutter State Management](https://docs.flutter.dev/development/data-and-backend/state-mgmt/intro)
- [Provider Tutorial](https://docs.flutter.dev/development/data-and-backend/state-mgmt/simple)

## 🌟 Acknowledgments

### Original Project Team

**CodersCafe Tech**: Thank you for the original PomodoroBot concept and implementation!

- Provided the inspiration for this project
- Created the animation files
- Developed the sensor integration logic
- Demonstrated Viam SDK usage

### Snapp Embedded & Snapp-X Team

**Company**: [Snapp Embedded](https://www.snappembedded.io)  
**Medium**: [medium.com/snapp-x](https://medium.com/snapp-x)  
**Twitter**: [@SnappEmbedded](https://twitter.com/SnappEmbedded)

Thank you for creating snapp_installer and comprehensive Flutter on Raspberry Pi guides!

- **Payam Zahedi**: [payamzahedi.com](https://payamzahedi.com) | [@payamzahedi95](https://twitter.com/payamzahedi95)
- **Moritz Theis**: Co-author of SnappX tutorials

**Contributions**:
- Created snapp_installer tool
- Detailed flutter-elinux installation steps
- Performance optimization tips
- Kiosk mode configuration
- Remote deployment guides
- Community support

### Flutter & Dart Teams

Google's Flutter and Dart teams for creating an amazing framework.

### Open Source Community

- All package maintainers
- Flutter community contributors
- Stack Overflow helpers
- GitHub issue reporters and PR contributors

## 📄 Licenses

### This Project
See [LICENSE](../LICENSE) file

### Dependencies
All packages used are licensed under permissive licenses:
- Flutter SDK: BSD 3-Clause License
- video_player: BSD License
- provider: MIT License
- intl: BSD License

### Original PomodoroBot
Check the [original repository](https://github.com/CodersCafeTech/PomodoroBot) for license information.

## 🔗 Additional Links

### Useful Tools

- **Flutter DevTools**: [docs.flutter.dev/development/tools/devtools](https://docs.flutter.dev/development/tools/devtools)
- **Dart Pad**: [dartpad.dev](https://dartpad.dev)
- **VS Code Flutter Extension**: [marketplace.visualstudio.com](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

### Community

- **Flutter Discord**: [discord.gg/flutter](https://discord.gg/flutter)
- **Flutter Reddit**: [reddit.com/r/FlutterDev](https://www.reddit.com/r/FlutterDev/)
- **Flutter Twitter**: [@FlutterDev](https://twitter.com/FlutterDev)

### Related Projects

- **snapp_installer**: [github.com/Snapp-Embedded/snapp_installer](https://github.com/Snapp-Embedded/snapp_installer) - CLI tool for Raspberry Pi deployment
- **flutter-elinux**: [github.com/sony/flutter-elinux](https://github.com/sony/flutter-elinux) - Sony's embedded Linux support
- **flutter-pi**: Alternative Raspberry Pi Flutter runtime
- **Flutter Desktop Embedding**: Desktop platform support
- **Snapp Embedded Platform**: [snappembedded.io](https://www.snappembedded.io) - Device management for embedded Flutter

## 📝 Citation

If you use this project in your work, please cite both:

**This Project**:
```
RaPiBot - Flutter Pomodoro Timer for Raspberry Pi
https://github.com/[your-username]/RaPiBot
```

**Original Project**:
```
PomodoroBot by CodersCafe Tech
https://github.com/CodersCafeTech/PomodoroBot
```

## 🤝 Contributing to References

Found a broken link or have a useful resource to add? Please:
1. Open an issue
2. Submit a pull request
3. Update this file

---

**Last Updated**: November 2025

[← Back to Documentation Index](README.md) | [← Back to Main README](../README.md)

