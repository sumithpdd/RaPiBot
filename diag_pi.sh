#!/bin/bash
# Diagnostic helper for Raspberry Pi Flutter/RaPiBot setup
#
# Usage:
#   chmod +x diag_pi.sh
#   ./diag_pi.sh          # runs checks and saves diag_pi.log
#   tail diag_pi.log
#   scp pi@<ip>:~/RaPiBot/diag_pi.log C:\path\to\logs\
#
# This script collects:
#   - System info
#   - Flutter doctor
#   - GStreamer versions
#   - OpenGL/EGL versions
#   - Installed package list (gstreamer/opengl)
#   - GPU memory allocation
#   - Flutter build + run log (release)
# Outputs go to ./diag_pi.log for easy copying off the Pi.

LOG_FILE="${PWD}/diag_pi.log"
exec > >(tee "${LOG_FILE}") 2>&1

echo "=========================================="
echo "Raspberry Pi Flutter Diagnostic - $(date)"
echo "=========================================="

echo ""
echo "# System Info"
uname -a
lsb_release -a 2>/dev/null || cat /etc/os-release

echo ""
echo "# GPU Memory"
vcgencmd get_mem gpu 2>/dev/null || echo "vcgencmd not available"

echo ""
echo "# Flutter Doctor"
flutter doctor -v

echo ""
echo "# GStreamer Versions"
gst-launch-1.0 --version
gst-inspect-1.0 playbin | head -n 40

echo ""
echo "# pkg-config Versions"
pkg-config --modversion gstreamer-1.0
pkg-config --modversion gl
pkg-config --modversion egl

echo ""
echo "# Installed Packages (gstreamer + mesa + egl)"
dpkg -l | grep -E "gstreamer1.0|libgst|libgl1|libegl1|libgles2|mesa" | awk '{print $1,$2,$3}'

echo ""
echo "# Flutter Build (release)"
cd ~/RaPiBot || exit 1
flutter clean
flutter pub get
flutter build linux --release

echo ""
echo "# Run Release Binary (log output)"
cd build/linux/arm64/release/bundle || exit 1
DISPLAY=${DISPLAY:-:0} ./rapibot > ~/RaPiBot/rapibot_run.log 2>&1 &
RUN_PID=$!
sleep 5
if ps -p ${RUN_PID} > /dev/null; then
  echo "rapibot is running (pid ${RUN_PID}). Capturing 80 lines of log and then stopping."
  tail -n 80 ~/RaPiBot/rapibot_run.log
  kill ${RUN_PID}
else
  echo "rapibot exited quickly. Showing entire log:"
  cat ~/RaPiBot/rapibot_run.log
fi

echo ""
echo "# Diagnostic complete"
echo "Log saved to ${LOG_FILE}"
echo "Run 'scp pi@<ip>:~/RaPiBot/diag_pi.log C:\\\\path\\\\' to copy to Windows."


