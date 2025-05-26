@echo off
setlocal enabledelayedexpansion

set "ColorReset=[0m"
set "ColorBlue=[34m"
set "ColorRed=[31m"

set "Info=%ColorBlue%[INFO]%ColorReset%"
set "Error=%ColorRed%[ERROR]%ColorReset%"

echo %Info% Starting bundle script...

:: Step 1 - Check if Rokit is installed
where rokit >nul 2>&1
if %errorlevel% neq 0 (
    echo %Info% Rokit not found. Preparing installation...

    :: Set version and download URL
    set "RokitVersion=v1.0.0"
    set "RokitZipName=rokit-%RokitVersion%-windows-x86_64.zip"
    set "RokitDownloadUrl=https://github.com/rojo-rbx/rokit/releases/download/%RokitVersion%/%RokitZipName%"
    set "CacheZipPath=%TEMP%\%RokitZipName%"
    set "ExtractDirectory=%TEMP%\RokitTemp"
    set "RokitExecutable=rokit.exe"

    if exist "%CacheZipPath%" (
        echo %Info% Using cached file: %CacheZipPath%
    ) else (
        echo %Info% Downloading Rokit from %RokitDownloadUrl%
        powershell -Command "Invoke-WebRequest -Uri '%RokitDownloadUrl%' -OutFile '%CacheZipPath%'"
        if not exist "%CacheZipPath%" (
            echo %Error% Failed to download %RokitZipName%.
            exit /b 1
        )
    )

    :: Extract ZIP to temporary directory
    echo %Info% Extracting Rokit...
    rmdir /s /q "%ExtractDirectory%" 2>nul
    mkdir "%ExtractDirectory%"
    powershell -Command "Expand-Archive -Path '%CacheZipPath%' -DestinationPath '%ExtractDirectory%' -Force"

    :: Run rokit.exe self-install
    if exist "%ExtractDirectory%\%RokitExecutable%" (
        echo %Info% Running rokit.exe self-install...
        "%ExtractDirectory%\%RokitExecutable%" self-install
    ) else (
        echo %Error% rokit.exe not found after extraction.
        exit /b 1
    )
) else (
    echo %Info% Rokit is already installed.
)

:: Step 2 - Install tools from rokit.toml
echo %Info% Installing tools defined in rokit.toml...
rokit install
if %errorlevel% neq 0 (
    echo %Error% Failed to install tools from rokit.toml.
    exit /b 1
)

:: Step 3 - Print available bundle options
echo.
echo %Info% Available bundle options:
echo      * input[="default.project.json"]
echo           Input .rbxm/.rbxmx or Rojo .project.json file
echo      * output[="{input-filename}.luau"]
echo           Final output file (.lua or .luau)
echo      * minify[=false]
echo           Enable minification with Darklua
echo      * env-name[="MFeee~ New"]
echo           Root environment name for runtime errors
echo      * darklua-config-path[=(".darklua.json", ".darklua.json5")]
echo           Custom Darklua config path
echo      * temp-dir-base[="{output-dir}"]
echo           Temp directory for Rojo/Darklua processing
echo      * ci-mode[=true]
echo           CI mode (non-interactive, errors exit with code 1)
echo      * verbose[=true]
echo           Verbose logging
echo.
echo %Info% Example input: minify=true input=default.project.json output=Tests/Script-Minified.luau
echo.

:: Step 4 - Ask for user input
set /p "UserOptions=Enter your bundle options: "

:: Step 5 - Run lune with user options
echo.
echo %Info% ^> lune run Build bundle %UserOptions%
echo ----------------------------------------
lune run Build bundle %UserOptions%
if %errorlevel% neq 0 (
    echo %Error% Bundle process failed.
    exit /b 1
) else (
    echo %Info% Bundle completed successfully.
)

endlocal
pause
