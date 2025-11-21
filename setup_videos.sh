#!/bin/bash
# Download video files for RaPiBot animations
# Works on Linux/Mac/Git Bash on Windows

echo "=========================================="
echo "Setting up Video Files for RaPiBot"
echo "=========================================="
echo ""

# Create assets directory if it doesn't exist
mkdir -p assets/animations

cd assets/animations

echo "📥 Downloading video files from original project..."
echo ""

# Base URL for raw files
BASE_URL="https://github.com/CodersCafeTech/PomodoroBot/raw/main/Code/animations"

# List of required videos
VIDEOS=(
    "blink.mp4"
    "speaking.mp4"
    "yellow.mp4"
    "red.mp4"
    "black.mp4"
)

# Download each video
for video in "${VIDEOS[@]}"; do
    if [ -f "$video" ]; then
        echo "✓ $video already exists, skipping..."
    else
        echo "⬇️  Downloading $video..."
        if command -v wget &> /dev/null; then
            wget "$BASE_URL/$video" -O "$video"
        elif command -v curl &> /dev/null; then
            curl -L "$BASE_URL/$video" -o "$video"
        else
            echo "❌ Error: Neither wget nor curl found. Please install one of them."
            exit 1
        fi
        
        if [ $? -eq 0 ] && [ -f "$video" ]; then
            echo "✅ $video downloaded successfully"
        else
            echo "❌ Failed to download $video"
        fi
    fi
    echo ""
done

# Verify all files
echo "=========================================="
echo "Verifying downloaded files..."
echo "=========================================="
echo ""

ALL_OK=true
for video in "${VIDEOS[@]}"; do
    if [ -f "$video" ]; then
        SIZE=$(ls -lh "$video" | awk '{print $5}')
        echo "✅ $video ($SIZE)"
    else
        echo "❌ $video - MISSING"
        ALL_OK=false
    fi
done

echo ""
if [ "$ALL_OK" = true ]; then
    echo "=========================================="
    echo "✅ All video files ready!"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "1. Run: flutter pub get"
    echo "2. Run: flutter run -d chrome (for web)"
    echo "   Or: flutter run (for desktop)"
    echo ""
else
    echo "=========================================="
    echo "⚠️  Some files are missing"
    echo "=========================================="
    echo ""
    echo "The app will work without videos, but will show"
    echo "'Video playback not available' message."
    echo ""
    echo "You can manually download videos from:"
    echo "https://github.com/CodersCafeTech/PomodoroBot/tree/main/Code/animations"
    echo ""
fi

