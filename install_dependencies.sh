#!/bin/bash
# Install all dependencies for Flutter app on Raspberry Pi
# Run this script on your Raspberry Pi after setting up Flutter

echo "=========================================="
echo "Installing Flutter Dependencies for Pi"
echo "=========================================="
echo ""

# Update package list
echo "📦 Updating package list..."
sudo apt update

# Install build tools
echo ""
echo "🔧 Installing build tools..."
sudo apt install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev libx11-dev libxrandr-dev libxinerama-dev \
  libxcursor-dev libxi-dev libxext-dev \
  libblkid-dev liblzma-dev

# Install GStreamer (required for video_player plugin on Linux)
echo ""
echo "🎥 Installing GStreamer (for video playback)..."
sudo apt install -y \
  gstreamer1.0-tools \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-libav \
  libgstreamer1.0-dev \
  libgstreamer-plugins-base1.0-dev

# Install video codecs
echo ""
echo "📹 Installing video codecs..."
sudo apt install -y \
  libavcodec-dev \
  libavformat-dev \
  libavutil-dev \
  libswscale-dev \
  libswresample-dev

# Install OpenGL/EGL libraries (required for graphics)
echo ""
echo "🖼️  Installing OpenGL/EGL libraries (for graphics)..."
sudo apt install -y \
  libgl1-mesa-dev \
  libegl1-mesa-dev \
  libgles2-mesa-dev \
  libglu1-mesa-dev \
  libgbm-dev \
  libdrm-dev \
  mesa-common-dev

echo ""
echo "=========================================="
echo "✅ All dependencies installed!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Rebuild your app:"
echo "   cd ~/RaPiBot"
echo "   flutter clean"
echo "   flutter pub get"
echo "   flutter build linux --release"
echo ""
echo "2. Test your app:"
echo "   cd ~/RaPiBot/build/linux/arm64/release/bundle"
echo "   ./rapibot"
echo ""

