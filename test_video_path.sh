#!/bin/bash
# Test video file paths on Raspberry Pi

echo "=========================================="
echo "Testing Video File Paths"
echo "=========================================="
echo ""

cd ~/RaPiBot

echo "# 1. Check source files:"
ls -lh assets/animations/*.mp4 2>/dev/null || echo "❌ No files in assets/animations/"
echo ""

echo "# 2. Check build/web files:"
if [ -d "build/web/assets/animations" ]; then
    ls -lh build/web/assets/animations/*.mp4 2>/dev/null || echo "⚠️  No .mp4 files in build/web/assets/animations/"
else
    echo "❌ build/web/assets/animations/ directory not found"
    echo "   Run: flutter build web --release"
fi
echo ""

echo "# 3. Test URLs (if server is running on port 8080):"
echo "   Testing: http://localhost:8080/assets/animations/blink.mp4"
curl -I http://localhost:8080/assets/animations/blink.mp4 2>/dev/null | head -1 || echo "   ⚠️  Server not running or file not found"
echo ""

echo "# 4. Check what Uri.base would be:"
echo "   (This is what Flutter sees as the base URL)"
echo ""

echo "=========================================="
echo "If files are missing from build/web:"
echo "1. Run: flutter clean"
echo "2. Run: flutter pub get"
echo "3. Run: flutter build web --release"
echo "4. Check: ls -lh build/web/assets/animations/"
echo "=========================================="

