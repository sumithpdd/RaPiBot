#!/bin/bash

# RaPiBot Web Runner Script
# This script sets up and runs the Flutter app in web mode

echo "🤖 RaPiBot - Starting Web Server..."
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null
then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://docs.flutter.dev/get-started/install"
    exit 1
fi

# Check Flutter version
echo "✅ Flutter found:"
flutter --version | head -n 1
echo ""

# Check if dependencies are installed
if [ ! -d ".dart_tool" ]; then
    echo "📦 Installing dependencies..."
    flutter pub get
    echo ""
fi

# Check if animation files exist
ANIMATION_DIR="assets/animations"
REQUIRED_FILES=("blink.mp4" "yellow.mp4" "red.mp4" "black.mp4")
MISSING_FILES=()

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$ANIMATION_DIR/$file" ]; then
        MISSING_FILES+=("$file")
    fi
done

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo "⚠️  Warning: Missing animation files:"
    for file in "${MISSING_FILES[@]}"; do
        echo "   - $ANIMATION_DIR/$file"
    done
    echo ""
    echo "The app will not display videos correctly without these files."
    echo "Download from: https://github.com/CodersCafeTech/PomodoroBot/tree/main/Code/animations"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Run the app in web mode
echo "🚀 Starting Flutter web server..."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  App Controls:"
echo "  • SPACE    - Start Pomodoro timer"
echo "  • ESC      - Cancel/Dismiss"
echo "  • F11      - Toggle fullscreen"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Run on Chrome
flutter run -d chrome

# Alternative: Run on web server
# flutter run -d web-server --web-port=8080

