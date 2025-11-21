#!/bin/bash
# Diagnose video playback issues

echo "=========================================="
echo "Video Playback Diagnostic"
echo "=========================================="
echo ""

echo "# 1. Checking video files in assets/animations/"
if [ -d "assets/animations" ]; then
    echo "✅ Directory exists"
    ls -lh assets/animations/*.mp4 2>/dev/null || echo "❌ No .mp4 files found"
else
    echo "❌ Directory does not exist"
fi
echo ""

echo "# 2. Checking pubspec.yaml"
if grep -q "assets/animations" pubspec.yaml; then
    echo "✅ Assets declared in pubspec.yaml"
    grep "assets/animations" pubspec.yaml
else
    echo "❌ Assets NOT declared in pubspec.yaml"
fi
echo ""

echo "# 3. Checking if build includes assets (web)"
if [ -d "build/web/assets/animations" ]; then
    echo "✅ Web build has assets directory"
    ls -lh build/web/assets/animations/*.mp4 2>/dev/null || echo "⚠️  No .mp4 files in build"
else
    echo "⚠️  Web build assets directory not found (run: flutter build web)"
fi
echo ""

echo "# 4. Video file sizes"
for file in assets/animations/*.mp4; do
    if [ -f "$file" ]; then
        size=$(ls -lh "$file" | awk '{print $5}')
        echo "  - $(basename $file): $size"
    fi
done
echo ""

echo "=========================================="
echo "Next Steps:"
echo "1. Run: flutter clean"
echo "2. Run: flutter pub get"
echo "3. Run: flutter run -d chrome (or flutter run)"
echo "4. Check console for [VideoPlayer] error messages"
echo "=========================================="

