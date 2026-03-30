@echo off
setlocal enabledelayedexpansion

:: --- Configuration ---
set "MAIN_SCRIPT=hdr_brackets.py"
set "DIST_ROOT=build"
set "OUT_NAME=hdr_merge_master"
set "OUT_DIR=%DIST_ROOT%\%OUT_NAME%.dist"

echo [1/4] Syncing environment and extracting version...
uv sync >nul 2>&1

:: Extract version from pyproject.toml using PowerShell
for /f "usebackq tokens=*" %%v in (`powershell -NoProfile -Command "(Get-Content pyproject.toml | Select-String '^version\s*=\s*\"(.*)\"').Matches.Groups[1].Value"`) do (
    set "VERSION=%%v"
)

if "%VERSION%"=="" set "VERSION=dev"
set "ZIP_PATH=%DIST_ROOT%\%OUT_NAME%_v%VERSION%.zip"

echo [2/4] Cleaning previous outputs...
if exist "%DIST_ROOT%" rmdir /s /q "%DIST_ROOT%"

echo [3/4] Building with Nuitka via uv...
:: Nuitka will automatically read the # nuitka-project: flags from %MAIN_SCRIPT%
uv run python -m nuitka %MAIN_SCRIPT%

if errorlevel 1 (
    echo.
    echo [ERROR] Build failed.
    exit /b 1
)

:: Rename the output directory to our desired name
:: Nuitka defaults to [filename].dist
if exist "%DIST_ROOT%\hdr_brackets.dist" (
    ren "%DIST_ROOT%\hdr_brackets.dist" "%OUT_NAME%.dist"
)

echo [4/4] Packaging distribution to ZIP...
powershell -NoProfile -Command "Compress-Archive -Path '%OUT_DIR%\*' -DestinationPath '%ZIP_PATH%' -Force"
if errorlevel 1 exit /b 1

echo.
echo ========================================
echo DONE: v%VERSION%
echo Path: %OUT_DIR%
echo Zip : %ZIP_PATH%
echo ========================================
pause