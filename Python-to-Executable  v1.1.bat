@echo off
title Python-to-Executable-v1.1 - by @sahik
setlocal EnableDelayedExpansion

:: Step 0: Find all .py files
set count=0
echo.
echo 🐍 Found these Python files in this folder:
for %%F in (*.py) do (
    set /a count+=1
    set "file!count!=%%F"
    echo  !count!. %%F
)

if !count! equ 0 (
    echo ❌ No .py files found in this folder.
    pause
    exit /b
)

:: Step 1: Ask user to select a file
echo.
set /p choice=Enter the number of the script you want to build:

set "script_name=!file%choice%!"
if not defined script_name (
    echo ❌ Invalid selection.
    pause
    exit /b
)

:: Step 2: Ask for EXE name
echo.
echo Enter the desired name for the .exe (no extension):
set /p exe_name=

:: Step 3: Ask for output folder
echo.
echo Enter the FULL PATH to save the .exe (e.g. C:\MyApps\users):
set /p output_path=

if not exist "%output_path%" (
    echo Creating folder...
    mkdir "%output_path%"
)

:: Step 4: Check if PyInstaller is installed
echo.
echo Checking PyInstaller...
pyinstaller --version >nul 2>&1
if errorlevel 1 (
    echo Installing PyInstaller...
    pip install pyinstaller
)

:: Step 5: Build the EXE
echo.
echo 🔨 Building "%exe_name%.exe" from "%script_name%"...

pyinstaller --onefile --noconsole --name "%exe_name%" "!script_name!"

:: Step 6: Move the EXE to desired location
if exist "dist\%exe_name%.exe" (
    move /Y "dist\%exe_name%.exe" "%output_path%\%exe_name%.exe" >nul
    echo ✅ Build complete! EXE moved to: %output_path%\%exe_name%.exe
) else (
    echo ❌ Build failed. EXE not found.
)

:: Step 7: Clean up
echo.
echo Cleaning up...
rmdir /s /q build >nul
rmdir /s /q __pycache__ >nul
del /f /q *.spec >nul

echo.
echo 🎉 Build process complete. Time to unleash chaos.
pause
