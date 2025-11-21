#!/bin/bash
# Setup autostart for Flutter web app on Raspberry Pi 5

echo "=========================================="
echo "Setting up RaPiBot Web Autostart"
echo "=========================================="
echo ""

# Get the user's home directory
USER_HOME=$(eval echo ~$USER)
SCRIPT_PATH="$USER_HOME/RaPiBot/launch_web_kiosk.sh"

# Create autostart directory if it doesn't exist
AUTOSTART_DIR="$USER_HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

# Create desktop entry
DESKTOP_FILE="$AUTOSTART_DIR/rapibot-web.desktop"

echo "📝 Creating autostart entry..."
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Type=Application
Name=RaPiBot Web
Comment=Launch RaPiBot Flutter Web App in Kiosk Mode
Exec=$SCRIPT_PATH
Icon=chromium-browser
Terminal=false
Categories=Utility;
X-GNOME-Autostart-enabled=true
EOF

chmod +x "$DESKTOP_FILE"

echo "✅ Autostart configured!"
echo ""
echo "The app will launch automatically on login."
echo ""
echo "To disable autostart:"
echo "  rm $DESKTOP_FILE"
echo ""
echo "To test autostart:"
echo "  $SCRIPT_PATH"

