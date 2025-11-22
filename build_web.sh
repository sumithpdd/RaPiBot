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
flutter build web --release

# Fix double assets/ path issue (Flutter web bug)
echo ""
echo "🔧 Fixing asset paths..."
FIXED=false

# Check for double assets path
if [ -d "build/web/assets/assets/animations" ]; then
    echo "   Found double assets/ path: build/web/assets/assets/animations/"
    echo "   Fixing..."
    
    # Create correct directory if it doesn't exist
    mkdir -p build/web/assets/animations
    
    # Copy all video files from double path to single path
    if ls build/web/assets/assets/animations/*.mp4 1> /dev/null 2>&1; then
        cp -v build/web/assets/assets/animations/*.mp4 build/web/assets/animations/
        echo "   ✅ Copied video files to correct location"
        FIXED=true
    fi
    
    # Remove the double assets directory
    rm -rf build/web/assets/assets
    echo "   ✅ Removed double assets/ directory"
fi

# Verify assets are in correct location
echo ""
echo "📦 Verifying assets..."
if [ -d "build/web/assets/animations" ] && ls build/web/assets/animations/*.mp4 1> /dev/null 2>&1; then
    echo "✅ Video assets found in build/web/assets/animations/"
    ls -lh build/web/assets/animations/*.mp4
    FIXED=true
elif [ -d "build/web/assets/assets/animations" ] && ls build/web/assets/assets/animations/*.mp4 1> /dev/null 2>&1; then
    echo "⚠️  Files still in double path - attempting manual fix..."
    mkdir -p build/web/assets/animations
    cp build/web/assets/assets/animations/*.mp4 build/web/assets/animations/ 2>/dev/null
    rm -rf build/web/assets/assets 2>/dev/null
    if ls build/web/assets/animations/*.mp4 1> /dev/null 2>&1; then
        echo "✅ Fixed! Files now in correct location:"
        ls -lh build/web/assets/animations/*.mp4
        FIXED=true
    else
        echo "❌ Fix failed - files may not work"
    fi
else
    echo "⚠️  No video assets found in build output"
    echo "   Expected: build/web/assets/animations/*.mp4"
    echo "   Check if source files exist: ls -lh assets/animations/*.mp4"
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

