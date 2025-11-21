@echo off
REM Diagnose video playback issues on Windows

echo ==========================================
echo Video Playback Diagnostic
echo ==========================================
echo.

echo # 1. Checking video files in assets\animations\
if exist "assets\animations" (
    echo Directory exists
    dir assets\animations\*.mp4
) else (
    echo Directory does not exist
)
echo.

echo # 2. Checking pubspec.yaml
findstr /C:"assets/animations" pubspec.yaml >nul
if %errorlevel% equ 0 (
    echo Assets declared in pubspec.yaml
    findstr /C:"assets/animations" pubspec.yaml
) else (
    echo Assets NOT declared in pubspec.yaml
)
echo.

echo # 3. Checking if build includes assets (web)
if exist "build\web\assets\animations" (
    echo Web build has assets directory
    dir build\web\assets\animations\*.mp4
) else (
    echo Web build assets directory not found (run: flutter build web)
)
echo.

echo ==========================================
echo Next Steps:
echo 1. Run: flutter clean
echo 2. Run: flutter pub get
echo 3. Run: flutter run -d chrome
echo 4. Check console for [VideoPlayer] error messages
echo ==========================================
pause

