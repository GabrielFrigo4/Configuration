@echo off

REM Build
git clone --recursive "https://github.com/LibreSprite/LibreSprite"
cd LibreSprite
mkdir build
cd build
cmake -G Ninja ..
start ninja install