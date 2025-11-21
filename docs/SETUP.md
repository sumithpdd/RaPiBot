# Setup Guide - Install & Run RaPiBot

Complete setup guide for running RaPiBot on Web, Windows, or Linux.

## 📋 Prerequisites

- **Flutter SDK** 3.0+ ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Dart** 3.0+ (included with Flutter)
- **Chrome** or **Edge** browser (for web testing)
- **Git** (optional, for cloning)

## ⚡ Quick Start (5 Minutes)

### 1. Install Dependencies

```bash
cd RaPiBot
flutter pub get
```

### 2. Run on Web

**Windows:**
```cmd
run_web.bat
```

**Linux/Mac:**
```bash
chmod +x run_web.sh
./run_web.sh
```

**Or manually:**
```bash
flutter run -d chrome
```

### 3. Done! 🎉

The app should open in your browser with:
- ✅ Video player (with or without videos)
- ✅ Floating buttons (mic, timer)
- ✅ Orange mock voice panel (bottom-left)
- ✅ Console logs showing sensor data

---

## 🎥 Video Files Setup

**⚠️ Important:** The app works **without videos**, but will show "Video playback not available" message. Videos enhance the experience with animated visual feedback.

### Quick Setup (Recommended)

**Windows:**
```cmd
setup_videos.bat
```

**Linux/Mac/Git Bash:**
```bash
chmod +x setup_videos.sh
./setup_videos.sh
```

This script automatically downloads all required video files from the original project.

### Manual Setup

If the script doesn't work, you can manually download videos:

### Option 1: Download from Original Project (Recommended)

**URL:** [github.com/CodersCafeTech/PomodoroBot](https://github.com/CodersCafeTech/PomodoroBot/tree/main/Code/animations)

**Required files:**
```
assets/animations/
├── blink.mp4      # Default animation (CO2 < 500 ppm)
├── speaking.mp4   # TTS speaking animation
├── yellow.mp4     # Warning (CO2 500-750 ppm)
├── red.mp4        # Alert (CO2 750-1500 ppm)
└── black.mp4      # Dark mode (light < 10)
```

**Download using Git:**
```bash
# Clone original repo temporarily
git clone https://github.com/CodersCafeTech/PomodoroBot.git temp

# Copy animations
cp temp/Code/animations/*.mp4 assets/animations/

# Clean up
rm -rf temp
```

**Download using wget (Linux/Mac):**
```bash
cd assets/animations

wget https://github.com/CodersCafeTech/PomodoroBot/raw/main/Code/animations/blink.mp4
wget https://github.com/CodersCafeTech/PomodoroBot/raw/main/Code/animations/yellow.mp4
wget https://github.com/CodersCafeTech/PomodoroBot/raw/main/Code/animations/red.mp4
wget https://github.com/CodersCafeTech/PomodoroBot/raw/main/Code/animations/black.mp4

# Also get speaking animation from this repo if needed
# (speaking.mp4 should already be in this project)
```

### Option 2: Use Any MP4 Files (Testing)

Use any videos you have for testing:

```bash
cd assets/animations

# Copy and rename any MP4 files
cp /path/to/video1.mp4 blink.mp4
cp /path/to/video2.mp4 yellow.mp4
cp /path/to/video3.mp4 red.mp4
cp /path/to/video4.mp4 black.mp4
cp /path/to/video5.mp4 speaking.mp4

# Or use the same video for all
cp /path/to/test.mp4 blink.mp4
cp /path/to/test.mp4 yellow.mp4
cp /path/to/test.mp4 red.mp4
cp /path/to/test.mp4 black.mp4
cp /path/to/test.mp4 speaking.mp4
```

### Option 3: Create Test Videos with ffmpeg

If you have `ffmpeg` installed:

```bash
cd assets/animations

# Blue video (normal)
ffmpeg -f lavfi -i color=c=blue:s=1280x720:d=3 -c:v libx264 -pix_fmt yuv420p blink.mp4

# Green video (speaking)
ffmpeg -f lavfi -i color=c=green:s=1280x720:d=3 -c:v libx264 -pix_fmt yuv420p speaking.mp4

# Yellow video (warning)
ffmpeg -f lavfi -i color=c=yellow:s=1280x720:d=3 -c:v libx264 -pix_fmt yuv420p yellow.mp4

# Red video (alert)
ffmpeg -f lavfi -i color=c=red:s=1280x720:d=3 -c:v libx264 -pix_fmt yuv420p red.mp4

# Black video (dark)
ffmpeg -f lavfi -i color=c=black:s=1280x720:d=3 -c:v libx264 -pix_fmt yuv420p black.mp4
```

---

## 🎮 Using the App

### Controls

| Input | Action |
|-------|--------|
| **Space** | Start Pomodoro timer (25 min) |
| **ESC** | Cancel timer / Dismiss notification |
| **F11** | Toggle fullscreen |
| **Mic Button** | Activate voice commands (mock mode) |
| **Orange Panel** | Open mock command panel |

### Test Features

**1. Pomodoro Timer**
- Press **Space** or click **"Start Pomodoro"**
- See 25:00 countdown
- Press **ESC** to cancel

**2. Mock Voice Commands**
- Click the **orange button** (bottom-left)
- Try commands like:
  - "start pomodoro for 25 minutes"
  - "cancel timer"
  - "what's happening"
- Watch the app respond with TTS!

**3. Meeting Notifications**
- Wait ~1-2 minutes
- Mock meeting appears (30% chance)
- Shows meeting name and time
- Dismiss with **ESC** or click **"Dismiss"**

**4. Video Switching** (if videos are present)
- Videos change every 5 seconds based on mock sensor data
- Check console (F12) to see sensor readings

### View Debug Logs

Press **F12** to see console output:
```
[VideoPlayer] ✓ Video ready: blink.mp4
[MockVoiceService] 🗣️ Speaking: "Welcome to Devfest London 2025..."
[AppState] 📊 Sensor triggered video change: yellow.mp4
[AppState] 🛡️ Sensors blocked - currently speaking
```

---

## 🖥️ Platform-Specific Setup

### Windows

```cmd
# Run on web
flutter run -d chrome

# Run native Windows app
flutter run -d windows
```

### Linux

```bash
# Enable Linux desktop support (first time)
flutter config --enable-linux-desktop

# Install dependencies (Ubuntu/Debian)
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev

# Run
flutter run -d linux
```

### macOS

```bash
# Enable macOS desktop support (first time)
flutter config --enable-macos-desktop

# Run
flutter run -d macos
```

### Web

```bash
# Enable web support (first time)
flutter config --enable-web

# Run in Chrome
flutter run -d chrome

# Run in Edge
flutter run -d edge

# Run on custom port
flutter run -d web-server --web-port=8080
# Then open http://localhost:8080
```

---

## 🔧 Configuration

### Enable Real Voice Recognition

By default, the app uses **mock voice** for testing. To enable **real voice**:

1. Edit `lib/screens/home_screen.dart`:
   ```dart
   bool _useMockVoice = false; // Change to false
   ```

2. Restart the app

3. Grant microphone permission when prompted

4. Click mic button and speak actual commands

See [Development Guide](DEVELOPMENT.md) → Voice Assistant section for details.

### Adjust Sensor Update Frequency

Edit `lib/services/sensor_service.dart`:

```dart
// Change from 5 seconds to desired interval
Stream.periodic(const Duration(seconds: 10), (_) {
  return _getMockSensorData();
});
```

### Customize CO2 Thresholds

Edit `lib/providers/app_state.dart`:

```dart
void handleSensorData(Map<String, dynamic> sensorData) {
  // Change thresholds
  if (co2 >= 600 && co2 < 900) {     // Was 500-750
    videoPath = 'assets/animations/yellow.mp4';
  } else if (co2 >= 900) {           // Was 750
    videoPath = 'assets/animations/red.mp4';
  }
}
```

### Change Timer Duration

Edit `lib/screens/home_screen.dart`:

```dart
void _startPomodoroTimer() {
  // Change from 25 minutes to desired duration
  final duration = 15 * 60; // 15 minutes in seconds
  appState.setTimerMode(duration);
}
```

---

## 🐛 Troubleshooting

### "No supported devices found"

```bash
# Enable web support
flutter config --enable-web

# List available devices
flutter devices
```

### "Target chrome not found"

Install Chrome or use Edge:
```bash
flutter run -d edge
```

### Videos not playing

1. **Check file paths**:
   ```bash
   ls -lh assets/animations/
   # Should show: blink.mp4, yellow.mp4, red.mp4, black.mp4, speaking.mp4
   ```

2. **Verify pubspec.yaml**:
   ```yaml
   flutter:
     assets:
       - assets/animations/
   ```

3. **Clean and rebuild**:
   ```bash
   flutter clean
   flutter pub get
   flutter run -d chrome
   ```

### Mock Voice Panel Not Showing

- Orange panel appears automatically (bottom-left)
- Only visible in video mode (not timer/notification)
- Check console for errors (F12)
- Verify mock mode enabled in `home_screen.dart`

### Dependencies Error

```bash
# Clear cache
flutter clean

# Reinstall
flutter pub get

# If still broken, try:
flutter pub cache repair
```

### Permission Denied (Linux/Mac)

```bash
# Make scripts executable
chmod +x run_web.sh

# If still issues, run directly:
flutter run -d chrome
```

### Build Errors

```bash
# Update Flutter
flutter upgrade

# Check Flutter health
flutter doctor

# Fix any issues reported by doctor
```

---

## 📦 Dependencies

From `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  video_player: ^2.8.1        # Video playback
  provider: ^6.1.1            # State management
  intl: ^0.18.1               # Date/time formatting
  speech_to_text: ^6.6.0      # Voice recognition (optional)
  flutter_tts: ^3.8.5         # Text-to-speech (optional)
  permission_handler: ^11.0.1 # Microphone permission (optional)
  cupertino_icons: ^1.0.2     # iOS icons
```

Install with:
```bash
flutter pub get
```

---

## ✅ Verify Setup

After setup, verify everything works:

1. ✅ **App launches** - Opens in browser/window
2. ✅ **Videos play** - Animated background (or placeholder)
3. ✅ **Timer works** - Press Space, see countdown
4. ✅ **Mock voice works** - Orange panel, test commands
5. ✅ **Notifications appear** - Wait 1-2 minutes
6. ✅ **Console logs** - F12 shows sensor data

If all checkboxes pass, you're ready to go! 🎉

---

## 📚 Next Steps

✅ **Setup complete?** → Try [Development Guide](DEVELOPMENT.md) to understand the code

✅ **Ready for deployment?** → See [Raspberry Pi Guide](RASPBERRY_PI.md)

✅ **Want to customize?** → See [Development Guide](DEVELOPMENT.md) → Customization section

---

## 🆘 Still Need Help?

- Check [Development Guide](DEVELOPMENT.md) for architecture and code flow
- See [References](REFERENCES.md) for external links
- Open an issue on GitHub
- Review original project: [CodersCafeTech/PomodoroBot](https://github.com/CodersCafeTech/PomodoroBot)

---

[← Back to Documentation](README.md) | [Raspberry Pi Deployment →](RASPBERRY_PI.md)

