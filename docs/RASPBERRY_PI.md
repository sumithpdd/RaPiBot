# Raspberry Pi Deployment Guide

Complete guide to deploy your DevFest London 2025 Photo Booth to Raspberry Pi using **SnappX (snapp_installer)**.

---

## 📋 What You Need

### Hardware
- **Raspberry Pi 5** (recommended) or **Raspberry Pi 4 Model B** (4GB RAM recommended, 2GB works)
- **Display** - Monitor with micro HDMI cable (Pi 5) or micro HDMI (Pi 4) OR official 7" Pi display
- **SD Card** - 32GB Class 10 microSD card (64GB+ recommended for Pi 5)
- **Power Supply** - 
  - **Pi 5**: 5.0V / 5.0A (27W) with USB-C connector (official Pi 5 power supply required)
  - **Pi 4**: 5.0V / 3.0A (15W) with USB-C connector
- **Input** - USB/Bluetooth keyboard and mouse (optional for headless setup)

### Software
- **Raspberry Pi OS 64-bit** (Raspbian) - Required for SnappX installer
  - Note: SnappX officially supports Raspberry Pi 4, but also works on Raspberry Pi 5
- **Bash shell** (version 4.0 or higher) - Included by default
- **Curl** - Included by default (if not, install with `sudo apt install curl`)
- **SSH access** (for remote deployment)
- **Internet connection** on Raspberry Pi
- **Windows PC** with SSH client (Windows 10/11 includes OpenSSH by default)

---

## 🌐 Remote Connection from Windows PC to Raspberry Pi

This section covers connecting to your Raspberry Pi from a Windows PC, including initial setup, SSH configuration, and file transfer.

### Step 1: Prepare Raspberry Pi OS Image (First Time Setup)

**Using Raspberry Pi Imager (Recommended for Windows):**

1. **Download Raspberry Pi Imager**
   - Visit: https://www.raspberrypi.com/software/
   - Download and install on your Windows PC

2. **Insert SD Card**
   - Insert microSD card into your Windows PC (using adapter if needed)
   - Note: Windows may format it - that's okay, Imager will overwrite it

3. **Configure OS Image**
   - Open Raspberry Pi Imager
   - Click **"Choose OS"** → Select **"Raspberry Pi OS (64-bit)"** (recommended for Pi 5)
   - Click **"Choose Storage"** → Select your SD card
   - Click the **gear icon ⚙️** (bottom-right) for **Advanced Options**

4. **Configure Advanced Options (Critical for Remote Access)**
   
   **General Tab:**
   - ✅ **Enable SSH** - Check this box
   - **Set username** - Enter your desired username (e.g., `pi`, `admin`, `user`)
   - **Set password** - Enter a secure password (remember this!)
   - ✅ **Configure wireless LAN** (if using WiFi)
     - SSID: Your WiFi network name
     - Password: Your WiFi password
     - Country: Select your country code (e.g., GB for UK, US for USA)
   - ✅ **Set locale settings**
     - Timezone: Select your timezone
     - Keyboard layout: Select your keyboard

   **Services Tab:**
   - ✅ **Enable SSH** (should already be checked)
   - ✅ **Use password authentication** (recommended for first-time setup)

5. **Write Image to SD Card**
   - Click **"Write"** button
   - Wait for image to be written (5-10 minutes)
   - Click **"Continue"** when done
   - Safely eject SD card from Windows

6. **Insert SD Card into Raspberry Pi**
   - Insert SD card into Raspberry Pi
   - Connect power supply (Pi 5 requires 27W USB-C power supply)
   - Connect to network (Ethernet or WiFi if configured)
   - Wait 1-2 minutes for first boot

### Step 2: Find Your Raspberry Pi's IP Address

**Method 1: From Your Router/Network (Easiest)**
- Log into your router's admin panel (usually http://192.168.1.1 or http://192.168.0.1)
- Look for connected devices
- Find device named "raspberrypi" or your configured hostname
- Note the IP address (e.g., 192.168.1.100)

**Method 2: Using Windows Command Prompt**
```cmd
# Open Command Prompt or PowerShell on Windows
# Scan your network for Raspberry Pi
arp -a | findstr "b8-27-eb"
# Or for Pi 5 (different MAC prefix)
arp -a | findstr "dc-a6-32"
```

**Method 3: Using Advanced IP Scanner (Windows Tool)**
1. Download [Advanced IP Scanner](https://www.advanced-ip-scanner.com/) (free)
2. Scan your network (192.168.1.1-192.168.1.254)
3. Look for device with hostname "raspberrypi"

**Method 4: If You Have Physical Access to Pi**
- Connect keyboard/monitor to Pi
- Log in with your username/password
- Run: `hostname -I`
- Note the IP address shown

### Step 3: Connect via SSH from Windows

**Windows 10/11 (Built-in OpenSSH):**

1. **Open PowerShell or Command Prompt**
   - Press `Win + X` → Select "Windows PowerShell" or "Terminal"
   - Or search for "PowerShell" in Start menu

2. **Test SSH Connection**
   ```powershell
   # Replace with your Pi's IP and username
   ssh pi@192.168.1.100
   # Or if you set a different username:
   ssh yourusername@192.168.1.100
   ```

3. **First Connection - Accept Host Key**
   - You'll see: "The authenticity of host '192.168.1.100' can't be established..."
   - Type: `yes` and press Enter
   - Enter your password (the one you set in Imager)
   - You should now be connected!

4. **If SSH is Not Available on Windows**
   ```powershell
   # Install OpenSSH Client (Windows 10/11)
   # Open PowerShell as Administrator
   Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
   ```

**Alternative: Using PuTTY (Windows)**

1. **Download PuTTY**
   - Visit: https://www.putty.org/
   - Download and install

2. **Connect with PuTTY**
   - Open PuTTY
   - **Host Name**: `192.168.1.100` (your Pi's IP)
   - **Port**: `22`
   - **Connection Type**: SSH
   - Click **"Open"**
   - Enter username: `pi` (or your username)
   - Enter password when prompted

**Alternative: Using Windows Terminal (Recommended)**

1. **Install Windows Terminal** (if not already installed)
   - Available from Microsoft Store
   - Or included in Windows 11

2. **Add SSH Profile**
   - Open Windows Terminal
   - Click dropdown arrow → Settings
   - Add new profile:
     ```json
     {
       "name": "Raspberry Pi",
       "commandline": "ssh pi@192.168.1.100",
       "icon": "ms-appx:///Assets/Terminal.png"
     }
     ```

### Step 4: Secure Your Connection

**Change Default Password (Important!)**
```bash
# Once connected via SSH
passwd
# Enter new password twice
```

**Set Up SSH Key Authentication (Optional but Recommended)**

**On Windows:**
```powershell
# Generate SSH key pair (if you don't have one)
ssh-keygen -t ed25519 -C "your_email@example.com"
# Press Enter to accept default location
# Enter passphrase (optional but recommended)

# Copy public key to Raspberry Pi
ssh-copy-id pi@192.168.1.100
# Enter password when prompted
```

**On Raspberry Pi (after key is copied):**
```bash
# Disable password authentication (optional, more secure)
sudo nano /etc/ssh/sshd_config
# Find: PasswordAuthentication yes
# Change to: PasswordAuthentication no
# Save and exit (Ctrl+X, Y, Enter)
sudo systemctl restart ssh
```

### Step 5: Transfer Files from Windows to Raspberry Pi

**Method 1: Using SCP (Secure Copy) from Windows PowerShell**

```powershell
# Copy entire project folder
scp -r C:\code\flutter\RaPiBot pi@192.168.1.100:~/

# Copy specific file
scp C:\code\flutter\RaPiBot\pubspec.yaml pi@192.168.1.100:~/RaPiBot/

# Copy built application bundle
scp -r C:\code\flutter\RaPiBot\build\linux\arm64\release\bundle pi@192.168.1.100:~/photobooth-app
```

**Method 2: Using WinSCP (Windows GUI Tool)**

1. **Download WinSCP**
   - Visit: https://winscp.net/
   - Download and install

2. **Connect to Raspberry Pi**
   - Open WinSCP
   - **File protocol**: SFTP
   - **Host name**: `192.168.1.100`
   - **Port number**: `22`
   - **User name**: `pi` (or your username)
   - **Password**: Your password
   - Click **"Login"**

3. **Transfer Files**
   - Drag and drop files from Windows (left panel) to Pi (right panel)
   - Or use the transfer buttons

**Method 3: Using Git (Recommended for Code)**

**On Raspberry Pi (via SSH):**
```bash
# Install Git if not already installed
sudo apt update
sudo apt install git -y

# Clone your repository
git clone https://github.com/your-username/RaPiBot.git
cd RaPiBot
```

**Method 4: Using VS Code Remote SSH (Best for Development)**

1. **Install VS Code Remote SSH Extension**
   - Open VS Code
   - Go to Extensions (Ctrl+Shift+X)
   - Search for "Remote - SSH"
   - Install extension

2. **Connect to Raspberry Pi**
   - Press `F1` or `Ctrl+Shift+P`
   - Type: "Remote-SSH: Connect to Host"
   - Enter: `pi@192.168.1.100`
   - Select platform: Linux
   - Enter password when prompted

3. **Open Project Folder**
   - File → Open Folder
   - Navigate to `/home/pi/RaPiBot`
   - Now you can edit files directly on Pi from Windows!

### Step 6: Install Requirements from Windows to Raspberry Pi

**Option A: Install via SSH Commands (Recommended)**

**On Windows PowerShell (connected via SSH):**
```powershell
# Connect to Pi
ssh pi@192.168.1.100

# Update package list
sudo apt update

# Install basic development tools
sudo apt install -y curl wget git build-essential

# Install Flutter dependencies (will be done by SnappX, but manual install if needed)
sudo apt install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev libblkid-dev liblzma-dev \
  libx11-dev libxrandr-dev libxinerama-dev \
  libxcursor-dev libxi-dev libxext-dev

# Install video codecs (for video playback)
sudo apt install -y \
  libavcodec-dev libavformat-dev \
  libavutil-dev libswscale-dev \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-libav

# Verify installations
which git
which curl
clang --version
```

**Option B: Create Installation Script on Windows, Transfer and Run**

**On Windows:**
1. Create file `install-requirements.sh`:
   ```bash
   #!/bin/bash
   sudo apt update
   sudo apt install -y curl wget git build-essential
   sudo apt install -y clang cmake ninja-build pkg-config
   sudo apt install -y libgtk-3-dev libx11-dev
   sudo apt install -y libavcodec-dev gstreamer1.0-plugins-base
   echo "Requirements installed!"
   ```

2. Transfer to Pi:
   ```powershell
   scp install-requirements.sh pi@192.168.1.100:~/
   ```

3. Run on Pi:
   ```powershell
   ssh pi@192.168.1.100
   chmod +x install-requirements.sh
   ./install-requirements.sh
   ```

**Option C: Use Ansible (Advanced, for Multiple Pis)**

1. **Install Ansible on Windows**
   ```powershell
   # Using WSL (Windows Subsystem for Linux)
   wsl --install
   # Then in WSL:
   sudo apt install ansible
   ```

2. **Create Ansible Playbook** (`install-pi-requirements.yml`):
   ```yaml
   - hosts: raspberrypi
     become: yes
     tasks:
       - name: Update apt cache
         apt:
           update_cache: yes
       - name: Install development tools
         apt:
           name:
             - curl
             - wget
             - git
             - build-essential
             - clang
             - cmake
   ```

3. **Run Playbook**:
   ```bash
   ansible-playbook -i 192.168.1.100, install-pi-requirements.yml
   ```

### Troubleshooting Windows to Pi Connection

**"Connection Refused" Error:**
```powershell
# Check if SSH is running on Pi
ssh pi@192.168.1.100 "sudo systemctl status ssh"

# If not running, enable it (requires physical access or alternative connection)
```

**"Host Key Verification Failed":**
```powershell
# Remove old host key from Windows
ssh-keygen -R 192.168.1.100
# Then reconnect
```

**"Permission Denied":**
- Verify username is correct
- Check password (case-sensitive)
- Ensure SSH is enabled on Pi

**Can't Find Pi on Network:**
- Verify Pi and Windows PC are on same network
- Check firewall settings on Windows
- Try pinging Pi: `ping 192.168.1.100`
- Check router's connected devices list

**Slow File Transfers:**
- Use Ethernet instead of WiFi if possible
- Check network speed
- Consider using `rsync` instead of `scp` for large transfers:
  ```powershell
  # Install rsync on Windows (via WSL or Git Bash)
  rsync -avz C:\code\flutter\RaPiBot\ pi@192.168.1.100:~/RaPiBot/
  ```

---

## 🚀 Quick Deployment with SnappX

**SnappX (snapp_installer)** is a command-line tool that simplifies Flutter deployment on Raspberry Pi, including automatic kiosk mode setup. According to the [official repository](https://github.com/Snapp-X/snapp_installer), it officially supports Raspberry Pi 4 with Raspberry Pi OS 64-bit, but also works on Raspberry Pi 5.

### What is SnappX?

**snapp_installer** is a Bash script that automates the process of setting up the Flutter environment on your Raspberry Pi. It:

- ✅ Installs Flutter SDK optimized for Raspberry Pi
- ✅ Sets up all required dependencies automatically
- ✅ Configures environment variables (PATH)
- ✅ Provides kiosk mode management
- ✅ Handles auto-login configuration
- ✅ Installs essential Linux packages (curl, git, etc.)
- ✅ Clones Flutter from GitHub
- ✅ Installs development dependencies
- ✅ Runs Flutter Doctor to verify setup
- ✅ Precaches Linux-specific assets

### 📋 Quick Installation Summary

Here's the complete process in 4 steps:

1. **Install SnappX**: `bash <(curl -fSL https://raw.githubusercontent.com/Snapp-X/snapp_installer/main/installer.sh) && source ~/.bashrc`
2. **Verify**: `snapp_installer doctor`
3. **Install Flutter**: `snapp_installer install` (then run `source ~/.bashrc`)
4. **Verify Flutter**: `flutter --version` and `flutter doctor`

**Total time: ~15-25 minutes** (depending on internet speed and Pi model)

---

### Step 1: Connect to Your Raspberry Pi

**From Windows PowerShell:**
```powershell
# Connect via SSH (replace with your Pi's IP)
ssh pi@192.168.1.100
# Enter your password when prompted
```

### Step 2: Install SnappX on Raspberry Pi

**On Raspberry Pi (via SSH):**

```bash
# Install snapp_installer (one command!)
bash <(curl -fSL https://raw.githubusercontent.com/Snapp-X/snapp_installer/main/installer.sh) && source ~/.bashrc
```

**What this does:**
- Downloads the SnappX installer script
- Installs snapp_installer to your system
- Adds it to your PATH
- Reloads your shell configuration

**Installation takes 1-2 minutes.**

**If you get "curl: command not found":**
```bash
# Install curl first
sudo apt update
sudo apt install curl -y
# Then retry SnappX installation
bash <(curl -fSL https://raw.githubusercontent.com/Snapp-X/snapp_installer/main/installer.sh) && source ~/.bashrc
```

**If you get permission errors:**
```bash
# Make sure you're using a user with sudo privileges
# The default 'pi' user should work
```

**If you get SSL/TLS errors (like "error:0A000438:SSL routines::tlsv1 alert internal error"):**

This error usually means your curl/OpenSSL is outdated or there's an SSL certificate issue. Try these solutions:

**Solution 1: Update curl and OpenSSL (Recommended)**
```bash
# Update package list
sudo apt update

# Upgrade curl and OpenSSL
sudo apt upgrade curl openssl -y

# Try installation again
bash <(curl -fSL https://raw.githubusercontent.com/Snapp-X/snapp_installer/main/installer.sh) && source ~/.bashrc
```

**Solution 2: Use wget instead of curl**
```bash
# Install wget if not already installed
sudo apt install wget -y

# Download installer script with wget
wget -O installer.sh https://raw.githubusercontent.com/Snapp-X/snapp_installer/main/installer.sh

# Run the installer
bash installer.sh && source ~/.bashrc

# Clean up
rm installer.sh
```

**Solution 3: Use curl with insecure flag (Temporary workaround)**
```bash
# Use --insecure flag (not recommended for production, but works)
bash <(curl -fSLk https://raw.githubusercontent.com/Snapp-X/snapp_installer/main/installer.sh) && source ~/.bashrc
```

**Solution 4: Download manually and run**
```bash
# Download the installer script
curl -fSL https://raw.githubusercontent.com/Snapp-X/snapp_installer/main/installer.sh -o snappx-installer.sh

# Make it executable
chmod +x snappx-installer.sh

# Run it
bash snappx-installer.sh && source ~/.bashrc

# Clean up
rm snappx-installer.sh
```

**Solution 5: Check system time (SSL certificates are time-sensitive)**
```bash
# Check current date/time
date

# If date is wrong, sync time (requires internet)
sudo apt install ntpdate -y
sudo ntpdate -s time.nist.gov

# Or set timezone
sudo timedatectl set-timezone UTC
# Or your timezone: sudo timedatectl set-timezone America/New_York

# Try installation again
bash <(curl -fSL https://raw.githubusercontent.com/Snapp-X/snapp_installer/main/installer.sh) && source ~/.bashrc
```

**Solution 6: Update CA certificates**
```bash
# Update certificate store
sudo apt update
sudo apt install ca-certificates -y
sudo update-ca-certificates

# Try installation again
bash <(curl -fSL https://raw.githubusercontent.com/Snapp-X/snapp_installer/main/installer.sh) && source ~/.bashrc
```

**If none of these work:**
- Check your internet connection: `ping -c 3 google.com`
- Check if GitHub is accessible: `curl -I https://github.com`
- Try from a different network (some corporate networks block SSL)
- Check firewall settings: `sudo ufw status`

### Step 3: Verify SnappX Installation

```bash
# Check if snapp_installer is installed
snapp_installer doctor
```

**Expected output:**
```
✓ snapp_installer is installed
✓ curl is installed
✓ git is installed
✓ Dependencies are ready
```

**Available SnappX Commands** (from [official repository](https://github.com/Snapp-X/snapp_installer)):

| Command | Description |
|---------|-------------|
| `snapp_installer doctor` | Check installation status and dependencies |
| `snapp_installer install` | Install Flutter and set up the environment |
| `snapp_installer uninstall` | Uninstall Flutter (Note: Not implemented yet) |
| `snapp_installer kiosk [path]` | Run a Flutter app bundle in kiosk mode |
| `snapp_installer disable_kiosk` | Disable the kiosk mode |
| `snapp_installer autologin` | Enable auto login on your device |
| `snapp_installer disable_autologin` | Disable auto login on your device |
| `snapp_installer enable_fullscreen` | Enable Full Screen in your Flutter project |

**If you see errors:**
```bash
# Reload shell configuration
source ~/.bashrc

# Or open a new SSH session
exit
ssh pi@192.168.1.100
snapp_installer doctor
```

### Step 4: Install Flutter Environment with SnappX

**This is the main installation step - it installs Flutter and all dependencies:**

```bash
snapp_installer install
```

**What this command does (according to [official documentation](https://github.com/Snapp-X/snapp_installer)):**

1. **Installs Linux Dependencies**
   - Ensures essential Linux packages are installed (curl, git, and more)
   - Installs build tools and compilers

2. **Clones Flutter from GitHub**
   - Fetches the Flutter repository from GitHub
   - Places it in your specified directory

3. **Sets Up PATH**
   - Configures your system's PATH environment variable
   - Makes the `flutter` command globally executable

4. **Installs Development Dependencies**
   - Installs necessary Linux development dependencies
   - Includes compilers and libraries required for Flutter app development

5. **Chooses Flutter Channel**
   - You can specify your preferred Flutter channel (stable, beta, etc.)
   - Ensures you're using the desired Flutter release

6. **Runs Flutter Doctor**
   - Checks your Flutter installation
   - Displays any missing components or configuration issues

7. **Precaches Assets**
   - Precaches Linux-specific assets
   - Ensures a smooth development experience

**Installation takes 10-20 minutes** depending on your internet speed and Pi model.

**Progress indicators:**
- Package installation progress
- Flutter repository clone progress
- Flutter doctor output
- Final success message

**Important Note:**
After running the "install" command, you need to restart your terminal or run `source ~/.bashrc` to apply the changes to your PATH environment variable.

**If installation fails:**
```bash
# Check internet connection
ping -c 3 google.com

# Check disk space (need at least 5GB free)
df -h

# Check if Flutter was partially installed
ls -la ~/snap/flutter/common/flutter

# Retry installation
snapp_installer install
```

### Step 5: Verify Flutter Installation

```bash
# Check Flutter version
flutter --version

# Run Flutter doctor
flutter doctor

# Expected output should show:
# ✓ Flutter (Channel stable)
# ✓ Linux toolchain
# ✓ Android toolchain (optional)
```

**If Flutter is not found:**
```bash
# First, reload shell configuration (required after install)
source ~/.bashrc

# Or restart your terminal/SSH session
exit
ssh pi@192.168.1.100

# Check if Flutter is in PATH
echo $PATH | grep flutter

# Check where Flutter was installed (varies by installation method)
which flutter
flutter --version

# If still not found, check common installation locations
ls -la ~/snap/flutter/common/flutter/bin/flutter
ls -la ~/flutter/bin/flutter

# Manually add to PATH if needed (adjust path based on actual installation location)
# Common locations:
# export PATH="$PATH:$HOME/snap/flutter/common/flutter/bin"
# export PATH="$PATH:$HOME/flutter/bin"
# Then add to ~/.bashrc to make permanent:
# echo 'export PATH="$PATH:$HOME/snap/flutter/common/flutter/bin"' >> ~/.bashrc
```

### Step 6: Enable Linux Desktop Support (If Not Already Done)

**Before preparing your project, ensure Linux desktop support is enabled:**

```bash
# Navigate to your project (if you already cloned/transferred it)
cd ~/RaPiBot

# Enable Linux desktop support
flutter create --platforms=linux .

# Verify linux/ folder was created
ls -la linux/
```

**Note:** If you're cloning a fresh project, you can enable Linux support after cloning. If you transferred from Windows and the project already has a `linux/` folder, you can skip this step.

### Step 7: Prepare Your Project on Raspberry Pi

**Option A: Clone from Git (Recommended)**

```bash
# On Raspberry Pi (via SSH)
cd ~
git clone https://github.com/your-username/RaPiBot.git
cd RaPiBot

# Install Flutter dependencies
flutter pub get
```

**Updating Project with Git Pull:**

If you already have the project cloned and want to pull latest changes:

```bash
# Navigate to project directory
cd ~/RaPiBot

# Pull latest changes from GitHub
git pull

# If you get authentication errors, you might need to set up credentials
# Or use HTTPS with a personal access token

# After pulling, get updated dependencies
flutter pub get
```

**Configure Git (if not already done):**

```bash
# Set up git user information (one-time setup)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Then you can pull updates
git pull origin main
# or
git pull origin master
```

**Option B: Transfer from Windows**

**From Windows PowerShell:**
```powershell
# Copy entire project folder
scp -r C:\code\flutter\RaPiBot pi@192.168.1.100:~/

# Then on Pi
ssh pi@192.168.1.100
cd ~/RaPiBot
flutter pub get
```

**Option C: Use VS Code Remote SSH**

1. Connect VS Code to Pi (see Step 5 in Remote Connection section)
2. Open folder: `/home/pi/RaPiBot`
3. Open terminal in VS Code (Ctrl+`)
4. Run: `flutter pub get`

### Step 7: Enable Linux Desktop Support

**Important:** Before building, you need to enable Linux desktop support for your Flutter project.

**On Raspberry Pi (via SSH):**
```bash
# Navigate to your project
cd ~/RaPiBot

# Enable Linux desktop support (creates linux/ folder and necessary files)
flutter create --platforms=linux .

# If you get a warning about overwriting files, type 'y' to confirm
```

**Verify Linux support is enabled:**
```bash
# Check if linux/ folder was created
ls -la linux/

# You should see files like:
# - CMakeLists.txt
# - main.cpp
# - my_application.cc
# - flutter/ directory
```

**If you get "No Linux desktop project configured" error:**
- This means Linux support isn't enabled yet
- Run `flutter create --platforms=linux .` from your project directory
- Then try building again

### Step 8: Build Your App

**Option A: Build on Raspberry Pi (Simpler, but slower)**

**On Raspberry Pi (via SSH):**
```bash
cd ~/RaPiBot

# Get dependencies
flutter pub get

# Build for Linux ARM64 (Raspberry Pi)
flutter build linux --release
```

**Build time:**
- Raspberry Pi 4: 15-30 minutes
- Raspberry Pi 5: 5-15 minutes (much faster!)

**The built app will be at:**
```
~/RaPiBot/build/linux/arm64/release/bundle/rapibot
```

**Option B: Cross-compile on Windows (Faster, but more complex)**

**Prerequisites on Windows:**
- Flutter SDK installed
- Linux toolchain for cross-compilation

**On Windows:**
```powershell
# Navigate to project
cd C:\code\flutter\RaPiBot

# Build for Linux ARM64
flutter build linux --release --target-platform linux-arm64

# Copy built bundle to Pi
scp -r build\linux\arm64\release\bundle pi@192.168.1.100:~/photobooth-app
```

**Note:** Cross-compilation from Windows to ARM64 Linux may require additional setup. Building on Pi is recommended for simplicity.

### Step 9: Install Required Dependencies for App Runtime

**Before testing, install all required dependencies for video playback and graphics on Raspberry Pi:**

**Option 1: Use the installation script (Recommended)**

```bash
# Copy the script to your Raspberry Pi
# From Windows, you can use SCP:
# scp install_dependencies.sh pi@192.168.1.100:~/RaPiBot/

# Or create it directly on Pi:
cd ~/RaPiBot
nano install_dependencies.sh
# Paste the script content (see below), then save (Ctrl+X, Y, Enter)

# Make it executable and run
chmod +x install_dependencies.sh
./install_dependencies.sh
```

**Option 2: Install manually**

```bash
# Install all dependencies needed for Flutter apps on Raspberry Pi
sudo apt update
sudo apt install -y \
  # Build tools
  clang cmake ninja-build pkg-config \
  libgtk-3-dev libx11-dev libxrandr-dev libxinerama-dev \
  libxcursor-dev libxi-dev libxext-dev \
  libblkid-dev liblzma-dev \
  # Video playback (GStreamer) - REQUIRED for video_player plugin
  gstreamer1.0-tools \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-libav \
  libgstreamer1.0-dev \
  libgstreamer-plugins-base1.0-dev \
  # Video codecs
  libavcodec-dev libavformat-dev libavutil-dev \
  libswscale-dev libswresample-dev \
  # Graphics/OpenGL - REQUIRED for EGL support
  libgl1-mesa-dev libegl1-mesa-dev \
  libgles2-mesa-dev libglu1-mesa-dev \
  libgbm-dev libdrm-dev \
  mesa-common-dev
```

**Verify installations:**
```bash
# Check GStreamer
gst-launch-1.0 --version

# Check OpenGL
pkg-config --modversion gl
pkg-config --modversion egl
```

### Step 10: Test Your App (Before Kiosk Mode)

**Before deploying in kiosk mode, test your app to make sure it works:**

**On Raspberry Pi (via SSH or directly on Pi):**

```bash
cd ~/RaPiBot

# Clean and rebuild (after installing dependencies)
flutter clean
flutter pub get
flutter build linux --release

# Test by running the built binary (more stable than flutter run)
cd build/linux/arm64/release/bundle
./rapibot
```

**Or test with flutter run (with logging):**
```bash
cd ~/RaPiBot
flutter run -d linux --verbose 2>&1 | tee flutter_run.log
```

**Logging Flutter Run Errors:**

If you encounter errors when running `flutter run`, capture them to a log file:

**Method 1: Save output to file (Recommended)**
```bash
# Run flutter and save all output to a log file
flutter run -d linux 2>&1 | tee flutter_run.log

# Or save to file only (no console output)
flutter run -d linux > flutter_run.log 2>&1
```

**Method 2: Verbose logging**
```bash
# Run with verbose output and save to file
flutter run -d linux --verbose 2>&1 | tee flutter_run_verbose.log
```

**Method 3: Run in background and log**
```bash
# Run in background and log everything
nano ~/run_app.sh
```

Add this content:
```bash
#!/bin/bash
cd ~/RaPiBot
flutter run -d linux > flutter_run.log 2>&1
```

Make executable and run:
```bash
chmod +x ~/run_app.sh
nohup ~/run_app.sh &

# Check the log
tail -f ~/RaPiBot/flutter_run.log

# To stop, find the process and kill it
ps aux | grep flutter
kill <process_id>
```

**Viewing Logs:**
```bash
# View the log file
cat flutter_run.log

# View last 50 lines (usually where the error is)
tail -n 50 flutter_run.log

# Follow log in real-time
tail -f flutter_run.log
```

**Copy Log from Pi to Windows:**
```powershell
# From Windows PowerShell
scp pi@192.168.1.100:~/RaPiBot/flutter_run.log C:\code\flutter\RaPiBot\
```

**Common Issues When Running:**

**"No devices found":**
```bash
# List available devices
flutter devices

# Make sure you're running on a device with display
# For headless Pi, you'll need to build and run the binary directly
```

**"Display not available":**
```bash
# If running via SSH without X11 forwarding, you need a display
# Either:
# 1. Connect directly to Pi with monitor/keyboard
# 2. Use VNC to access desktop
# 3. Build release version and run the binary
```

**Run Built Binary Directly:**
```bash
# After building, run the binary directly
cd ~/RaPiBot/build/linux/arm64/release/bundle
./rapibot
```

### Step 11: Deploy in Kiosk Mode

**Kiosk mode makes your app run automatically in fullscreen on boot - perfect for a photo booth!**

According to the [official SnappX documentation](https://github.com/Snapp-X/snapp_installer), you can enable kiosk mode in two ways:

#### Option A: By Flutter Project Directory

If you have a Flutter project on your Raspberry Pi, you can enable kiosk mode directly from the project directory:

```bash
# Navigate to your Flutter project
cd ~/RaPiBot

# Enable kiosk mode (snapp_installer will build and run automatically)
snapp_installer kiosk
```

#### Option B: By Flutter App Bundle (Recommended for Production)

1. **Build Your Flutter App First:**
   ```bash
   cd ~/RaPiBot
   flutter build linux --release
   ```

2. **Enable Kiosk Mode with Full Path:**
   ```bash
   # Enable kiosk mode with full path to your app bundle
   snapp_installer kiosk /home/pi/RaPiBot/build/linux/arm64/release/bundle/rapibot
   
   # Or if you copied just the bundle to a different location
   snapp_installer kiosk /home/pi/photobooth-app/rapibot
   ```

**Important:** Ensure that the specified file path:
- ✅ Exists
- ✅ Points to an executable file
- ✅ Is the path to your Flutter app bundle (the compiled binary)

**What kiosk mode does:**
- ✅ Configures auto-login (Pi logs in automatically on boot)
  - If auto-login is not already enabled, snapp_installer will enable it for you
- ✅ Creates systemd service to launch your app
- ✅ Sets app to run in fullscreen mode
- ✅ Hides mouse cursor when idle
- ✅ Disables screensaver/power management
- ✅ Restarts app if it crashes
- ✅ Launches app automatically on boot

**After enabling kiosk mode:**
```bash
# Reboot to test
sudo reboot

# Your app should launch automatically after reboot!
```

**To test without rebooting:**
```bash
# Start the kiosk service manually
sudo systemctl start photobooth.service

# Check status
sudo systemctl status photobooth.service

# View logs
journalctl -u photobooth.service -f
```

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

**Auto-login is required for kiosk mode.** According to the [official documentation](https://github.com/Snapp-X/snapp_installer), you can manage it manually:

```bash
# Enable auto-login (required for kiosk mode)
snapp_installer autologin

# Disable auto-login
snapp_installer disable_autologin
```

**Note:** When you enable kiosk mode, snapp_installer will automatically enable auto-login if it's not already enabled.

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

### SnappX Installation Errors

**SSL/TLS Error when installing SnappX:**
```
curl: (35) OpenSSL/3.0.17: error:0A000438:SSL routines::tlsv1 alert internal error
```

**Quick Fix - Update curl and OpenSSL:**
```bash
sudo apt update
sudo apt upgrade curl openssl ca-certificates -y
bash <(curl -fSL https://raw.githubusercontent.com/Snapp-X/snapp_installer/main/installer.sh) && source ~/.bashrc
```

**Alternative - Use wget:**
```bash
sudo apt install wget -y
wget -O installer.sh https://raw.githubusercontent.com/Snapp-X/snapp_installer/main/installer.sh
bash installer.sh && source ~/.bashrc
rm installer.sh
```

**Check system time (SSL certificates require correct time):**
```bash
date  # Check if date is correct
sudo timedatectl set-timezone UTC  # Set timezone if needed
sudo ntpdate -s time.nist.gov  # Sync time
```

See [Step 2: Install SnappX](#step-2-install-snappx-on-raspberry-pi) section above for more detailed solutions.

**"curl: command not found":**
```bash
sudo apt update
sudo apt install curl -y
```

**"snapp_installer: command not found" after installation:**
```bash
# Reload shell configuration
source ~/.bashrc

# Or check if it's in PATH
echo $PATH | grep snapp

# Manually add to PATH if needed (check installation location)
export PATH="$PATH:$HOME/.local/bin"
source ~/.bashrc
```

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

**"No Linux desktop project configured" Error:**
```bash
# Enable Linux desktop support first
cd ~/RaPiBot
flutter create --platforms=linux .

# Then try building again
flutter build linux --release
```

**Missing dependencies:**
```bash
sudo apt update
sudo apt install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev libblkid-dev liblzma-dev
```

**"flutter run" Errors - How to Log:**
```bash
# Capture all output to log file
flutter run -d linux --verbose 2>&1 | tee flutter_run_$(date +%Y%m%d_%H%M%S).log

# View the log
cat flutter_run_*.log

# Or view last 30 lines (where errors usually appear)
tail -n 30 flutter_run_*.log
```

**Flutter Doctor Issues:**
```bash
# Check Flutter setup and log results
flutter doctor -v > flutter_doctor.log 2>&1
cat flutter_doctor.log
```

**Common Runtime Errors Summary:**

| Error | Cause | Solution |
|-------|-------|----------|
| `UnimplementedError: init() has not been implemented` | Video player plugin missing Linux dependencies | Install GStreamer and codecs (see above) |
| `MissingPluginException` (permissions) | Permission handler not fully supported on Linux | **EXPECTED** - App uses mock voice mode (this is correct behavior) |
| `Real voice services failed to initialize` | Permission handler not available on Linux | **EXPECTED** - App automatically uses mock voice (this is correct) |
| `No provider of eglCreateImage found` | Missing OpenGL/EGL libraries | Install `libgl1-mesa-dev`, `libegl1-mesa-dev`, `libgbm-dev` |
| `Lost connection to device` | App crashed | Check logs, install missing dependencies, try release mode |

**Complete Dependency Installation (Fix All Common Errors):**

**Quick Fix Script (Recommended for Raspberry Pi):**

```bash
# On your Raspberry Pi, run:
cd ~/RaPiBot

# If you have the install_dependencies.sh script:
chmod +x install_dependencies.sh
./install_dependencies.sh

# Or install manually:
sudo apt update
sudo apt install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev libx11-dev libxrandr-dev libxinerama-dev \
  libxcursor-dev libxi-dev libxext-dev libblkid-dev liblzma-dev \
  gstreamer1.0-tools gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly gstreamer1.0-libav \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
  libavcodec-dev libavformat-dev libavutil-dev \
  libswscale-dev libswresample-dev \
  libgl1-mesa-dev libegl1-mesa-dev \
  libgles2-mesa-dev libglu1-mesa-dev \
  libgbm-dev libdrm-dev mesa-common-dev

# Rebuild after installing
cd ~/RaPiBot
flutter clean
flutter pub get
flutter build linux --release
```

**Note:** The `install_dependencies.sh` script is included in the project root for easy installation on Raspberry Pi.

**Out of memory:**
```bash
# Create swap file (if building on Pi)
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### Runtime Errors (When Running `flutter run`)

**"UnimplementedError: init() has not been implemented" (Video Player):**

This error means the `video_player` plugin doesn't have full Linux implementation. Install required dependencies:

```bash
# Install GStreamer and codecs (required for video playback on Linux)
sudo apt update
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
sudo apt install -y \
  libavcodec-dev \
  libavformat-dev \
  libavutil-dev \
  libswscale-dev \
  libswresample-dev

# Rebuild the app after installing dependencies
cd ~/RaPiBot
flutter clean
flutter pub get
flutter build linux --release
```

**"MissingPluginException" (Permissions Plugin) / "Real voice services failed to initialize":**

**This is EXPECTED and NOT an error!** The `permission_handler` plugin doesn't work fully on Linux, so the app automatically falls back to **mock voice mode**. This is the intended behavior.

**What this means:**
- ✅ The app detected that real voice isn't available
- ✅ It automatically switched to mock voice mode
- ✅ The app will work perfectly with the orange mock voice panel
- ✅ You can test all voice commands using the mock panel

**To verify mock voice is working:**
- Look for the orange mock voice panel button (bottom-left of screen)
- Click it to open the command panel
- Try commands like "start pomodoro for 25 minutes"
- The app should respond with TTS and execute the command

**This error is safe to ignore** - your app is working correctly!

**"No provider of eglCreateImage found. Requires one of: EGL 15" (Graphics/EGL Error):**

This is a graphics/OpenGL issue. The app needs EGL (Embedded Graphics Library) support. Install OpenGL and EGL libraries:

```bash
# Install OpenGL and EGL libraries (REQUIRED for Flutter on Raspberry Pi)
sudo apt update
sudo apt install -y \
  libgl1-mesa-dev \
  libegl1-mesa-dev \
  libgles2-mesa-dev \
  libglu1-mesa-dev \
  libgbm-dev \
  libdrm-dev \
  mesa-common-dev

# Verify installation
pkg-config --modversion gl
pkg-config --modversion egl

# Rebuild after installing
cd ~/RaPiBot
flutter clean
flutter pub get
flutter build linux --release
```

**If EGL error persists after installing libraries:**

1. **Check if you're running via SSH without display:**
   ```bash
   # Check if DISPLAY is set
   echo $DISPLAY
   
   # If empty, you need to run on Pi directly or use VNC
   # Or set DISPLAY for X11 forwarding
   export DISPLAY=:0
   ```

2. **Try running the built binary directly (more stable):**
   ```bash
   cd ~/RaPiBot/build/linux/arm64/release/bundle
   DISPLAY=:0 ./rapibot
   ```

3. **Check GPU memory allocation:**
   ```bash
   sudo raspi-config
   # Performance Options → GPU Memory → 128 or 256
   # Then reboot
   sudo reboot
   ```

4. **For Raspberry Pi 5, you may need additional drivers:**
   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y
   
   # Reboot to ensure all drivers are loaded
   sudo reboot
   ```

**"Lost connection to device" (App Crashed):**

If the app crashes immediately after starting:

1. **Check logs:**
   ```bash
   # Run with verbose logging
   flutter run -d linux --verbose 2>&1 | tee crash.log
   
   # View the crash log
   tail -n 50 crash.log
   ```

2. **Check if it's a plugin issue:**
   ```bash
   # Try running in release mode (more stable)
   flutter run -d linux --release
   ```

3. **Check system resources:**
   ```bash
   # Check memory
   free -h
   
   # Check disk space
   df -h
   
   # Check if display is available
   echo $DISPLAY
   ```

4. **Run the built binary directly:**
   ```bash
   # Build first
   flutter build linux --release
   
   # Run the binary directly (more stable than flutter run)
   cd ~/RaPiBot/build/linux/arm64/release/bundle
   ./rapibot
   ```

### Video Playback Issues

**Videos not playing or "init() not implemented" error:**

**Step 1: Install GStreamer (Required for video_player on Linux)**
```bash
sudo apt update
sudo apt install -y \
  gstreamer1.0-tools \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-libav \
  libgstreamer1.0-dev \
  libgstreamer-plugins-base1.0-dev
```

**Step 2: Install Video Codecs**
```bash
sudo apt install -y \
  libavcodec-dev \
  libavformat-dev \
  libavutil-dev \
  libswscale-dev \
  libswresample-dev
```

**Step 3: Verify GStreamer Installation**
```bash
# Test GStreamer
gst-launch-1.0 --version

# Test video playback capability
gst-inspect-1.0 playbin
```

**Step 4: Rebuild App**
```bash
cd ~/RaPiBot
flutter clean
flutter pub get
flutter build linux --release
```

**Step 5: Test Video Playback**
```bash
# Run the built app
cd ~/RaPiBot/build/linux/arm64/release/bundle
./rapibot
```

**If videos still don't play:**

- The app will show an error icon instead of video (this is expected)
- The app should still function (timer, voice commands, etc.)
- Videos may work in release mode but not debug mode
- Consider using static images or animations instead of videos for Raspberry Pi

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

# Pull latest changes
git pull

# Get updated dependencies
flutter pub get

# Rebuild app
flutter build linux --release

# Restart service
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
echo "Pulling latest changes..."
git pull
echo "Getting dependencies..."
flutter pub get
echo "Building app..."
flutter build linux --release
echo "Restarting service..."
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
   - GitHub: https://github.com/Snapp-X/snapp_installer
   - Installation: `bash <(curl -fSL https://raw.githubusercontent.com/Snapp-X/snapp_installer/main/installer.sh)`
   - Website: https://snappembedded.io (company website)
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
- [ ] Raspberry Pi 5 or Pi 4 (4GB+ RAM) ready
- [ ] SD card (32GB+ for Pi 4, 64GB+ recommended for Pi 5) flashed with Raspberry Pi OS (64-bit)
- [ ] SSH enabled via Raspberry Pi Imager advanced options
- [ ] Pi connected to network (WiFi or Ethernet)
- [ ] Display connected and working
- [ ] Windows PC with SSH client ready
- [ ] Successfully connected to Pi via SSH from Windows

### Installation
- [ ] SnappX installer installed
- [ ] `snapp_installer doctor` passes
- [ ] Flutter environment installed
- [ ] `source ~/.bashrc` run after Flutter installation
- [ ] Flutter verified with `flutter --version` and `flutter doctor`
- [ ] Project cloned/transferred to Raspberry Pi
- [ ] Linux desktop support enabled (`flutter create --platforms=linux .`)
- [ ] Runtime dependencies installed (GStreamer, OpenGL libraries)
- [ ] Dependencies installed (`flutter pub get`)
- [ ] App built successfully (`flutter build linux --release`)
- [ ] App tested and runs without crashes
- [ ] Videos copied to assets folder (or app works without videos)

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
# Install SnappX
bash <(curl -fSL https://raw.githubusercontent.com/Snapp-X/snapp_installer/main/installer.sh) && source ~/.bashrc

# Verify Installation
snapp_installer doctor

# Install Flutter Environment
snapp_installer install
source ~/.bashrc  # Required after install

# Verify Flutter
flutter --version
flutter doctor

# Enable Linux Desktop Support (if not already done)
cd ~/RaPiBot
flutter create --platforms=linux .

# Install Runtime Dependencies (REQUIRED)
sudo apt install -y gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
  gstreamer1.0-libav libgl1-mesa-dev libegl1-mesa-dev

# Build Your App
cd ~/RaPiBot
flutter pub get
flutter build linux --release

# Test Your App (optional, before kiosk mode)
cd build/linux/arm64/release/bundle
./rapibot

# Deploy in Kiosk Mode
snapp_installer kiosk /home/pi/RaPiBot/build/linux/arm64/release/bundle/rapibot

# Management Commands
snapp_installer disable_kiosk
snapp_installer autologin
snapp_installer disable_autologin
snapp_installer enable_fullscreen

# Monitoring
sudo systemctl status photobooth
journalctl -u photobooth -f

# Remote Connection
ssh pi@192.168.1.100
scp -r build/bundle pi@192.168.1.100:~/app
```

**For complete command reference, see [SnappX GitHub Repository](https://github.com/Snapp-X/snapp_installer)**

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
- Check [SnappX GitHub Repository](https://github.com/Snapp-X/snapp_installer)
- Review [Troubleshooting](#-troubleshooting) section
- Open issue on [SnappX GitHub](https://github.com/Snapp-X/snapp_installer/issues)

---

[← Back to Documentation](README.md) | [Setup Guide →](SETUP.md) | [Development →](DEVELOPMENT.md)

**Made with ❤️ for DevFest London 2025**
