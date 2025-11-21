#!/bin/bash
# Check all config files that might affect GPU memory on Raspberry Pi 5

echo "=========================================="
echo "Checking GPU Memory Configuration"
echo "=========================================="
echo ""

echo "# Current GPU Memory:"
vcgencmd get_mem gpu
echo ""

echo "# Checking /boot/firmware/config.txt:"
sudo grep -n "gpu_mem\|start_x\|dtoverlay.*vc4\|dtoverlay.*kms" /boot/firmware/config.txt 2>/dev/null || echo "File not found or no matches"
echo ""

echo "# Checking /boot/config.txt (legacy):"
sudo grep -n "gpu_mem\|start_x\|dtoverlay.*vc4\|dtoverlay.*kms" /boot/config.txt 2>/dev/null || echo "File not found or no matches"
echo ""

echo "# Checking /boot/firmware/usercfg.txt:"
sudo grep -n "gpu_mem\|start_x\|dtoverlay.*vc4\|dtoverlay.*kms" /boot/firmware/usercfg.txt 2>/dev/null || echo "File not found or no matches"
echo ""

echo "# Checking active overlays:"
vcgencmd get_config dtoverlay 2>/dev/null || echo "Command not available"
echo ""

echo "# Checking GPU driver info:"
dmesg | grep -i "vc4\|kms\|gpu" | tail -5
echo ""

echo "# Pi Model:"
cat /proc/device-tree/model 2>/dev/null || echo "Cannot read model"
echo ""

echo "=========================================="
echo "If gpu_mem still shows 8M on Pi 5, try:"
echo "1. Use Flutter web (recommended for Pi 5)"
echo "2. Or check if Pi 5 needs different settings"
echo "=========================================="

