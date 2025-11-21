#!/bin/bash
# Launch Flutter web app in Chromium kiosk mode on Raspberry Pi 5

echo "=========================================="
echo "Launching RaPiBot Web in Kiosk Mode"
echo "=========================================="
echo ""

cd ~/RaPiBot

# Check if build exists
if [ ! -d "build/web" ] || [ ! -f "build/web/index.html" ]; then
    echo "❌ Web build not found!"
    echo "Run './build_web.sh' first to build the app."
    exit 1
fi

# Check if Chromium is installed
if ! command -v chromium-browser &> /dev/null; then
    echo "📦 Installing Chromium..."
    sudo apt update
    sudo apt install -y chromium-browser
fi

# Kill any existing Chromium instances
echo "🛑 Stopping any existing Chromium instances..."
pkill -f chromium-browser 2>/dev/null
pkill -f "python3 -m http.server" 2>/dev/null
sleep 1

# Start web server in background
echo "🌐 Starting web server on port 8080..."
cd build/web
python3 -m http.server 8080 > /tmp/rapibot_web_server.log 2>&1 &
SERVER_PID=$!
sleep 3

# Check if server started successfully
if ! ps -p $SERVER_PID > /dev/null; then
    echo "❌ Failed to start web server!"
    cat /tmp/rapibot_web_server.log
    exit 1
fi

echo "✅ Web server started (PID: $SERVER_PID)"
echo ""

# Launch Chromium in kiosk mode
echo "🚀 Launching Chromium in kiosk mode..."
echo "Press Alt+F4 or Ctrl+Alt+F4 to exit"
echo ""

chromium-browser \
  --kiosk \
  --app=http://localhost:8080 \
  --noerrdialogs \
  --disable-translate \
  --disable-features=TranslateUI \
  --disk-cache-dir=/tmp/chrome-cache \
  --disable-infobars \
  --autoplay-policy=no-user-gesture-required \
  --disable-session-crashed-bubble \
  --disable-restore-session-state \
  --disable-pinch \
  --overscroll-history-navigation=0 \
  2>/dev/null

# Cleanup when Chromium exits
echo ""
echo "🛑 Stopping web server..."
kill $SERVER_PID 2>/dev/null
pkill -f "python3 -m http.server" 2>/dev/null

echo "✅ Kiosk mode stopped"

