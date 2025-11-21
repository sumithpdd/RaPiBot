#!/bin/bash
# Build Flutter app for web deployment on Raspberry Pi 5

echo "=========================================="
echo "Building Flutter App for Web"
echo "=========================================="
echo ""

cd ~/RaPiBot

# Enable web support
echo "📦 Enabling web support..."
flutter config --enable-web

# Clean previous builds
echo ""
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo ""
echo "📥 Getting dependencies..."
flutter pub get

# Build for web
echo ""
echo "🔨 Building web release..."
flutter build web --release --web-renderer html

# Verify assets were copied
echo ""
echo "📦 Verifying assets..."
if [ -d "build/web/assets/animations" ]; then
    echo "✅ Video assets found in build/web/assets/animations/"
    ls -lh build/web/assets/animations/*.mp4 2>/dev/null || echo "⚠️  No .mp4 files found (app will work but show 'Video playback not available')"
else
    echo "⚠️  Assets directory not found - videos may not work"
fi

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✅ Build successful!"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "1. Run: ./serve_web.sh (to start web server)"
    echo "2. Or run: ./launch_web_kiosk.sh (to start server + Chromium kiosk)"
    echo ""
else
    echo ""
    echo "=========================================="
    echo "❌ Build failed!"
    echo "=========================================="
    exit 1
fi

