# Raspberry Pi Deployment Guide

Complete guide to deploy your DevFest London 2025 Photo Booth to Raspberry Pi using **SnappX (snapp_installer)**.

---

## 📋 What You Need

### Hardware
- **Raspberry Pi 4 Model B** (4GB RAM recommended, 2GB works)
- **Display** - Monitor with micro HDMI cable OR official 7" Pi display
- **SD Card** - 32GB Class 10 microSD card
- **Power Supply** - 5.0V / 3.0A (official Pi power supply recommended)
- **Input** - USB/Bluetooth keyboard and mouse

### Software
- **Raspberry Pi OS** or **Ubuntu** installed on SD card
- **SSH access** (for remote deployment)
- **Internet connection** on Raspberry Pi

---

## 🌐 Remote Connection to Raspberry Pi

### Enable SSH (First Time Setup)

**Option 1: Using Raspberry Pi Imager (Easiest)**
1. Download [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
2. Insert SD card into computer
3. Click "Choose OS" → Select Raspberry Pi OS
4. Click gear icon ⚙️ for advanced options
5. Enable SSH ✅
6. Set username/password
7. Configure WiFi (optional)
8. Write to SD card

**Option 2: Enable SSH on Running Pi**
```bash
# On Raspberry Pi directly
sudo raspi-config
# Select: Interface Options → SSH → Enable
```

### Find Your Pi's IP Address

**On the Raspberry Pi:**
```bash
hostname -I
# Example output: 192.168.1.100
```

**On your computer (same network):**
```bash
# Windows
arp -a | findstr b8-27-eb

# Linux/Mac
arp -a | grep b8:27:eb
```

### Connect via SSH

**From your computer:**
```bash
# Replace with your Pi's IP
ssh pi@192.168.1.100

# Default password: raspberry (change this!)
```

**Change default password:**
```bash
passwd
```

### Copy Files to Pi

**Using SCP (from your computer):**
```bash
# Copy entire project
scp -r /path/to/RaPiBot pi@192.168.1.100:~/

# Copy built bundle only
scp -r build/linux/arm64/release/bundle pi@192.168.1.100:~/photobooth-app
```

**Using Git (on Pi):**
```bash
git clone https://github.com/your-repo/RaPiBot.git
cd RaPiBot
```

---

## 🚀 Quick Deployment with SnappX

**SnappX (snapp_installer)** is a command-line tool that simplifies Flutter deployment on Raspberry Pi, including automatic kiosk mode setup.

### Step 1: Install SnappX on Raspberry Pi

```bash
# SSH into your Pi
ssh pi@192.168.1.100

# Install snapp_installer
bash <(curl -fSL https://snappembedded.io/installer) && source ~/.bashrc
```

### Step 2: Verify Installation

```bash
snapp_installer doctor
```

**Expected output:**
```
✓ snapp_installer is installed
✓ curl is installed
✓ git is installed
✓ Dependencies are ready
```

### Step 3: Install Flutter Environment

```bash
snapp_installer install
```

This will:
- ✅ Install Linux dependencies
- ✅ Clone Flutter from GitHub
- ✅ Set up PATH variables
- ✅ Install development dependencies
- ✅ Run flutter doctor
- ✅ Precache Linux assets

### Step 4: Build Your App

**Option A: Build on Pi (slower but simpler)**
```bash
cd ~/RaPiBot
flutter pub get
flutter build linux --release
```

**Option B: Cross-compile on your computer (faster)**
```bash
# On your development machine
flutter build linux --release --target-platform linux-arm64

# Copy to Pi
scp -r build/linux/arm64/release/bundle pi@192.168.1.100:~/photobooth-app
```

### Step 5: Deploy in Kiosk Mode

```bash
# Enable kiosk mode (will auto-login and run fullscreen)
snapp_installer kiosk /home/pi/RaPiBot/build/linux/arm64/release/bundle/rapibot

# Or if you copied just the bundle
snapp_installer kiosk /home/pi/photobooth-app/rapibot
```

**The Pi will now:**
- ✅ Auto-login on boot
- ✅ Launch photo booth in fullscreen
- ✅ Hide mouse cursor
- ✅ Disable screensaver
- ✅ Run 24/7

---

## 🔧 Manual Deployment (Alternative Method)

If you prefer manual control without SnappX:

### Install Flutter-elinux

```bash
# Install dependencies
sudo apt update
sudo apt install curl unzip git clang cmake pkg-config libx11-dev

# Clone flutter-elinux
git clone https://github.com/sony/flutter-elinux.git
sudo mv flutter-elinux /opt/

# Add to PATH
echo 'export PATH=$PATH:/opt/flutter-elinux/bin' >> ~/.bashrc
source ~/.bashrc

# Verify
flutter-elinux doctor
```

### Build and Run

```bash
cd ~/RaPiBot
flutter-elinux build linux --release
flutter-elinux run -d elinux-x11 --release
```

### Manual Kiosk Setup

**Create systemd service:**
```bash
sudo nano /etc/systemd/system/photobooth.service
```

**Add content:**
```ini
[Unit]
Description=DevFest Photo Booth
After=graphical.target

[Service]
Type=simple
User=pi
Environment="DISPLAY=:0"
Environment="XAUTHORITY=/home/pi/.Xauthority"
WorkingDirectory=/home/pi/photobooth-app
ExecStart=/home/pi/photobooth-app/rapibot
Restart=always

[Install]
WantedBy=graphical.target
```

**Enable service:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable photobooth.service
sudo systemctl start photobooth.service
```

---

## 🎛️ Kiosk Mode Management

### Disable Kiosk Mode

```bash
# Exit fullscreen: Press Alt+F4 or F11
# Then disable kiosk
snapp_installer disable_kiosk
```

### Enable/Disable Auto-Login

```bash
# Enable auto-login
snapp_installer autologin

# Disable auto-login
snapp_installer disable_autologin
```

### Check Service Status

```bash
# View logs
journalctl -u photobooth.service -f

# Restart service
sudo systemctl restart photobooth.service

# Stop service
sudo systemctl stop photobooth.service
```

---

## 🐛 Troubleshooting

### SSH Connection Issues

**Can't connect:**
```bash
# Verify SSH is running on Pi
sudo systemctl status ssh

# Restart SSH
sudo systemctl restart ssh
```

**Connection refused:**
- Check firewall: `sudo ufw status`
- Verify Pi is on same network
- Try direct Ethernet connection

### Build Errors

**Missing dependencies:**
```bash
sudo apt update
sudo apt install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev libblkid-dev liblzma-dev
```

**Out of memory:**
```bash
# Create swap file (if building on Pi)
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### Video Playback Issues

**Videos not playing:**
```bash
# Install codecs
sudo apt install -y \
  libavcodec-dev libavformat-dev \
  libavutil-dev libswscale-dev

# Install GStreamer
sudo apt install -y \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-libav
```

### Display Issues

**Black screen after kiosk enable:**
```bash
# SSH into Pi
ssh pi@192.168.1.100

# Check logs
journalctl -u photobooth.service -n 50

# Disable kiosk and retry
snapp_installer disable_kiosk
```

**Wrong resolution:**
```bash
# Edit config
sudo nano /boot/config.txt

# Add/modify:
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=82  # 1920x1080 60Hz
```

### Performance Issues

**Slow/laggy app:**
1. Reduce video resolution (720p recommended)
2. Use H.264 codec for videos
3. Lower video bitrate
4. Increase GPU memory:
   ```bash
   sudo raspi-config
   # Performance Options → GPU Memory → 256
   ```

---

## 📊 Performance Optimization

### GPU Memory Allocation

```bash
sudo raspi-config
# Performance Options → GPU Memory → 256MB
```

### Overclock (Carefully!)

```bash
sudo nano /boot/config.txt

# Add (increases risk of instability)
over_voltage=2
arm_freq=1750
```

### Reduce Boot Time

```bash
# Disable unnecessary services
sudo systemctl disable bluetooth
sudo systemctl disable hciuart
sudo systemctl disable avahi-daemon
```

---

## 🔄 Remote Updates

### Update App Remotely

```bash
# From your computer
cd /path/to/RaPiBot

# Make changes, then push
git add .
git commit -m "Update photo booth"
git push

# On Pi
ssh pi@192.168.1.100
cd ~/RaPiBot
git pull
flutter build linux --release
sudo systemctl restart photobooth.service
```

### Automated Updates Script

Create on Pi:
```bash
nano ~/update-photobooth.sh
```

Add:
```bash
#!/bin/bash
cd ~/RaPiBot
git pull
flutter pub get
flutter build linux --release
sudo systemctl restart photobooth.service
echo "Photo booth updated!"
```

Make executable:
```bash
chmod +x ~/update-photobooth.sh
```

Run updates:
```bash
ssh pi@192.168.1.100 './update-photobooth.sh'
```

---

## 🌐 Remote Access Tools

### VNC (Visual Desktop Access)

**Enable on Pi:**
```bash
sudo raspi-config
# Interface Options → VNC → Enable
```

**Connect from computer:**
- Download [RealVNC Viewer](https://www.realvnc.com/en/connect/download/viewer/)
- Connect to: `192.168.1.100:5900`

### VS Code Remote SSH

```bash
# Install Remote-SSH extension in VS Code
# Press F1 → "Remote-SSH: Connect to Host"
# Enter: pi@192.168.1.100
```

---

## 📚 References & Resources

### Official Documentation

1. **SnappX Installer**
   - Website: https://snappembedded.io
   - GitHub: https://github.com/Snapp-Embedded/snapp_installer
   - Tutorial: [Flutter on Raspberry Pi (snapp_installer)](https://medium.com/snapp-x/flutter-on-raspberry-pi-raspi-flutter-e1760818ba0c)

2. **Flutter-elinux**
   - GitHub: https://github.com/sony/flutter-elinux
   - Tutorial: [Flutter on Embedded Devices](https://medium.com/snapp-x/flutter-on-embedded-devices-7070b5907b91)

3. **Raspberry Pi**
   - Official Site: https://www.raspberrypi.com
   - Documentation: https://www.raspberrypi.com/documentation/
   - SSH Guide: https://www.raspberrypi.com/documentation/computers/remote-access.html

4. **Flutter**
   - Flutter Docs: https://docs.flutter.dev
   - Linux Desktop: https://docs.flutter.dev/platform-integration/linux/building
   - Video Player: https://pub.dev/packages/video_player

### Original Project

- **PomodoroBot** (Python)
  - GitHub: https://github.com/CodersCafeTech/PomodoroBot
  - Animations: https://github.com/CodersCafeTech/PomodoroBot/tree/main/Code/animations

### Community Resources

- **Snapp Embedded**: https://www.snappembedded.io
- **Snapp X (Medium)**: https://medium.com/snapp-x
- **Payam Zahedi**: https://twitter.com/payamzahedi95
- **Moritz Theis**: Contributing author to SnappX guides

---

## ✅ Deployment Checklist

### Pre-Deployment
- [ ] Raspberry Pi 4 (4GB+ RAM) ready
- [ ] SD card flashed with Raspberry Pi OS/Ubuntu
- [ ] SSH enabled and tested
- [ ] Pi connected to network
- [ ] Display connected and working

### Installation
- [ ] SnappX installer installed
- [ ] `snapp_installer doctor` passes
- [ ] Flutter environment installed
- [ ] App built successfully
- [ ] Videos copied to assets folder

### Kiosk Setup
- [ ] Kiosk mode enabled
- [ ] Auto-login configured
- [ ] App launches in fullscreen
- [ ] Touch/mouse input working
- [ ] Sound output tested (if needed)

### Production Ready
- [ ] Remote SSH access working
- [ ] Update script configured
- [ ] Service starts on boot
- [ ] Logs accessible remotely
- [ ] Performance acceptable
- [ ] Backup/recovery plan ready

---

## 🎯 Quick Commands Reference

```bash
# Installation
bash <(curl -fSL https://snappembedded.io/installer) && source ~/.bashrc
snapp_installer install

# Deployment
snapp_installer kiosk /home/pi/photobooth-app/rapibot

# Management
snapp_installer disable_kiosk
snapp_installer autologin
snapp_installer disable_autologin

# Monitoring
sudo systemctl status photobooth
journalctl -u photobooth -f

# Remote Connection
ssh pi@192.168.1.100
scp -r build/bundle pi@192.168.1.100:~/app
```

---

## 🎉 Success!

Your DevFest London 2025 Photo Booth should now be running on Raspberry Pi!

**Key Benefits:**
- ✅ Easy installation with SnappX
- ✅ Automatic kiosk mode
- ✅ Remote management via SSH
- ✅ Professional fullscreen experience
- ✅ Auto-start on boot
- ✅ Perfect for events!

**Need Help?**
- Check [SnappX Documentation](https://snappembedded.io)
- Review [Troubleshooting](#-troubleshooting) section
- Open issue on GitHub

---

[← Back to Documentation](README.md) | [Setup Guide →](SETUP.md) | [Development →](DEVELOPMENT.md)

**Made with ❤️ for DevFest London 2025**
