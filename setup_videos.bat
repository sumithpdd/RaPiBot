@echo off
REM Download video files for RaPiBot animations (Windows)

echo ==========================================
echo Setting up Video Files for RaPiBot
echo ==========================================
echo.

REM Create assets directory if it doesn't exist
if not exist "assets\animations" mkdir "assets\animations"

cd assets\animations

echo Downloading video files from original project...
echo.

REM Base URL for raw files
set BASE_URL=https://github.com/CodersCafeTech/PomodoroBot/raw/main/Code/animations

REM Download each video using PowerShell
echo Downloading blink.mp4...
powershell -Command "Invoke-WebRequest -Uri '%BASE_URL%/blink.mp4' -OutFile 'blink.mp4'"

echo Downloading speaking.mp4...
powershell -Command "Invoke-WebRequest -Uri '%BASE_URL%/speaking.mp4' -OutFile 'speaking.mp4'"

echo Downloading yellow.mp4...
powershell -Command "Invoke-WebRequest -Uri '%BASE_URL%/yellow.mp4' -OutFile 'yellow.mp4'"

echo Downloading red.mp4...
powershell -Command "Invoke-WebRequest -Uri '%BASE_URL%/red.mp4' -OutFile 'red.mp4'"

echo Downloading black.mp4...
powershell -Command "Invoke-WebRequest -Uri '%BASE_URL%/black.mp4' -OutFile 'black.mp4'"

cd ..\..

echo.
echo ==========================================
echo Video files setup complete!
echo ==========================================
echo.
echo Next steps:
echo 1. Run: flutter pub get
echo 2. Run: flutter run -d chrome
echo.

pause

