# Video Playback Troubleshooting

If you're seeing "Video playback not available" even though files exist in `assets/animations/`, follow these steps:

## 1. Verify Files Exist

**Windows:**
```cmd
dir assets\animations\*.mp4
```

**Linux/Mac:**
```bash
ls -lh assets/animations/*.mp4
```

Should show: `blink.mp4`, `speaking.mp4`, `yellow.mp4`, `red.mp4`, `black.mp4`

## 2. Check pubspec.yaml

Make sure assets are declared:
```yaml
flutter:
  assets:
    - assets/animations/
```

## 3. Clean and Rebuild

```bash
flutter clean
flutter pub get
flutter run -d chrome  # or flutter run for desktop
```

## 4. Check Console Logs

Look for these debug messages:
- `[VideoPlayer] ✗ Initialization failed: ...`
- `[VideoPlayer] Video path: ...`
- `[VideoPlayer] Platform: ...`

## 5. Platform-Specific Issues

### Windows Desktop
- Video codecs should be installed automatically
- Try running as administrator if issues persist
- Check Windows Media Foundation is available

### Web
- Videos must be in `build/web/assets/animations/` after build
- Check browser console for 404 or CORS errors
- Verify server is serving files correctly

### Linux
- Install GStreamer: `sudo apt install gstreamer1.0-plugins-base gstreamer1.0-libav`
- Check EGL/OpenGL drivers are installed

## 6. Test Video File Directly

**Web:**
Open in browser: `http://localhost:8080/assets/animations/blink.mp4`

**Desktop:**
Try playing the file with system video player to verify it's not corrupted

## 7. Fallback: App Works Without Videos

The app is fully functional without videos:
- ✅ Timer works
- ✅ Voice commands work (mock panel)
- ✅ Notifications work
- ✅ All features work

Videos are optional enhancements for visual feedback.

