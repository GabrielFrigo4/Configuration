@echo off
setlocal

REM ################################
REM Skia
REM ################################

wget "https://github.com/aseprite/skia/releases/download/m102-861e4743af/Skia-Windows-Release-x64.zip"
if %errorlevel% neq 0 exit /b %errorlevel%

mkdir "%TEMP%\skia" 2> nul
unzip "Skia-Windows-Release-x64.zip" -d "%TEMP%\skia"
del "Skia-Windows-Release-x64.zip"

REM ################################
REM Build
REM ################################

git clone --recursive "https://github.com/aseprite/aseprite.git"
if %errorlevel% neq 0 exit /b %errorlevel%

cd aseprite
mkdir build
cd build
call VsDevEnv x64
call VsCMake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLAF_BACKEND=skia -DSKIA_DIR="%TEMP%\skia" -DSKIA_LIBRARY_DIR="%TEMP%\skia\out\Release-x64" -DSKIA_LIBRARY="%TEMP%\skia\out\Release-x64\skia.lib" -G Ninja ..
ninja aseprite

endlocal