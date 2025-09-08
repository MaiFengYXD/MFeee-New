@echo off
setlocal enabledelayedexpansion

set "ColorReset=[0m"
set "ColorBlue=[34m"
set "ColorRed=[31m"
set "ColorGreen=[32m"
set "ColorYellow=[33m"

set "Info=%ColorBlue%[INFO]%ColorReset%"
set "Error=%ColorRed%[ERROR]%ColorReset%"
set "Success=%ColorGreen%[SUCCESS]%ColorReset%"
set "Warn=%ColorYellow%[WARN]%ColorReset%"

echo %Info% Starting bundle script...

:: Step 1 - Find or install Rokit
echo %Info% Searching for Rokit executable...

set "RokitFound="
set "RokitPath="

:: 1. Check for Rokit in the PATH
for %%I in (rokit.exe) do (
    if exist "%%~fI" (
        set "RokitPath=%%~fI"
        set "RokitFound=true"
        echo %Success% Found Rokit in PATH: !RokitPath!
        goto :SkipInstall
    )
)

:: 2. Check for Rokit in the default user installation path
if not defined RokitFound (
    set "DefaultRokitPath=%USERPROFILE%\.rokit\bin\rokit.exe"
    if exist "!DefaultRokitPath!" (
        set "RokitPath=!DefaultRokitPath!"
        set "RokitFound=true"
        echo %Success% Found Rokit in user directory: !RokitPath!
        goto :SkipInstall
    )
)

:: 3. If not found, download and install it
if not defined RokitFound (
    echo %Warn% Rokit not found. Preparing to download and install...

    set "RokitZipName=rokit-1.0.0-windows-x86_64.zip"
    set "ExtractDirectory=%TEMP%\rokit-1.0.0-windows-x86_64"
    set "RokitDownloadUrl=https://github.com/rojo-rbx/rokit/releases/download/v1.0.0/!RokitZipName!"
    set "CacheZipPath=%TEMP%\!RokitZipName!"
    set "RokitInstalledPath=%USERPROFILE%\.rokit\bin\rokit.exe"

    :: Check for cached zip file
    if exist "!CacheZipPath!" (
        echo %Info% Using cached zip file: !CacheZipPath!
    ) else (
        echo %Info% Downloading Rokit from !RokitDownloadUrl!
        powershell -Command "Invoke-WebRequest -Uri '!RokitDownloadUrl!' -OutFile '!CacheZipPath!'"
        if not exist "!CacheZipPath!" (
            echo %Error% Failed to download !RokitZipName!.
            exit /b 1
        )
    )

    :: Extract ZIP to temporary directory and then move to user directory
    echo %Info% Extracting Rokit...
    rmdir /s /q "!ExtractDirectory!" 2>nul
    mkdir "!ExtractDirectory!"
    powershell -Command "Expand-Archive -Path '!CacheZipPath!' -DestinationPath '!ExtractDirectory!' -Force"

    :: Move the executable to the final destination
    echo %Info% Installing Rokit to user directory...
    rmdir /s /q "%USERPROFILE%\.rokit\" 2>nul
    xcopy /s /e /y "!ExtractDirectory!\*" "%USERPROFILE%\.rokit\"

    :: Check if rokit.exe was installed successfully
    if not exist "!RokitInstalledPath!" (
        echo %Error% rokit.exe not found after installation.
        exit /b 1
    )

    set "RokitPath=!RokitInstalledPath!"
    echo %Success% Rokit installed successfully at: !RokitPath!
)

:SkipInstall
if not defined RokitPath (
    echo %Error% Rokit executable not found and could not be installed. Exiting.
    exit /b 1
)

:: Step 2 - Install tools from rokit.toml
echo %Info% Installing tools defined in rokit.toml...
"!RokitPath!" install
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
echo %Info% Example input: minify=true darklua-config-path="Build\DarkluaMinify.json" input=default.project.json output=Tests/Script-Minified.luau
echo.

:: Step 4 - Ask for user input
set /p "UserOptions=Enter your bundle options: "

:: Step 5 - Run lune with user options
echo.
echo %Info% ^> lune run Build bundle !UserOptions!
echo ----------------------------------------
lune run Build bundle !UserOptions!
if %errorlevel% neq 0 (
    echo %Error% Bundle process failed.
    exit /b 1
) else (
    echo %Success% Bundle completed successfully.
)

endlocal
pause
