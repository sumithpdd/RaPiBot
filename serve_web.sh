#!/bin/bash
# Serve Flutter web app on Raspberry Pi 5

echo "=========================================="
echo "Starting Web Server for RaPiBot"
echo "=========================================="
echo ""

cd ~/RaPiBot/build/web

# Check if build exists
if [ ! -d "." ] || [ ! -f "index.html" ]; then
    echo "❌ Web build not found!"
    echo "Run './build_web.sh' first to build the app."
    exit 1
fi

echo "🌐 Starting web server on port 8080..."
echo "Access at: http://localhost:8080"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Start Python HTTP server
python3 -m http.server 8080

