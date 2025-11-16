@echo off
REM RaPiBot Web Runner Script for Windows
REM This script sets up and runs the Flutter app in web mode

echo 🤖 RaPiBot - Starting Web Server...
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed. Please install Flutter first.
    echo Visit: https://docs.flutter.dev/get-started/install
    pause
    exit /b 1
)

REM Check Flutter version
echo ✅ Flutter found:
flutter --version | findstr /C:"Flutter"
echo.

REM Check if dependencies are installed
if not exist ".dart_tool" (
    echo 📦 Installing dependencies...
    flutter pub get
    echo.
)

REM Check if animation files exist
set ANIMATION_DIR=assets\animations
set MISSING=0

if not exist "%ANIMATION_DIR%\blink.mp4" (
    echo ⚠️  Missing: %ANIMATION_DIR%\blink.mp4
    set MISSING=1
)
if not exist "%ANIMATION_DIR%\yellow.mp4" (
    echo ⚠️  Missing: %ANIMATION_DIR%\yellow.mp4
    set MISSING=1
)
if not exist "%ANIMATION_DIR%\red.mp4" (
    echo ⚠️  Missing: %ANIMATION_DIR%\red.mp4
    set MISSING=1
)
if not exist "%ANIMATION_DIR%\black.mp4" (
    echo ⚠️  Missing: %ANIMATION_DIR%\black.mp4
    set MISSING=1
)

if %MISSING% equ 1 (
    echo.
    echo The app will not display videos correctly without these files.
    echo Download from: https://github.com/CodersCafeTech/PomodoroBot/tree/main/Code/animations
    echo.
    set /p CONTINUE="Continue anyway? (y/n): "
    if /i not "%CONTINUE%"=="y" exit /b 1
)

REM Run the app in web mode
echo.
echo 🚀 Starting Flutter web server...
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo   App Controls:
echo   • SPACE    - Start Pomodoro timer
echo   • ESC      - Cancel/Dismiss
echo   • F11      - Toggle fullscreen
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

REM Run on Chrome
flutter run -d chrome

REM Alternative: Run on web server
REM flutter run -d web-server --web-port=8080

