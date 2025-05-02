#!/bin/bash

ColorReset=$'\033[0m'
ColorBlue=$'\033[34m'
ColorRed=$'\033[31m'

Info="[$ColorBlue INFO$ColorReset]"
Error="[$ColorRed ERROR$ColorReset]"

echo -e "$Info Starting bundle script..."

# Step 1 - Check if Rokit is installed
if ! command -v rokit &> /dev/null; then
    echo -e "$Info Rokit not found. Preparing installation..."

    # Set version and download URL
    RokitVersion="v1.0.0"
    RokitZipName="rokit-${RokitVersion}-linux-x86_64.zip"
    RokitDownloadUrl="https://github.com/rojo-rbx/rokit/releases/download/${RokitVersion}/${RokitZipName}"
    CacheZipPath="${TMPDIR:-/tmp}/${RokitZipName}"
    ExtractDirectory="${TMPDIR:-/tmp}/RokitTemp"
    RokitExecutable="rokit"

    if [ -f "$CacheZipPath" ]; then
        echo -e "$Info Using cached file: $CacheZipPath"
    else
        echo -e "$Info Downloading Rokit from $RokitDownloadUrl"
        curl -L -o "$CacheZipPath" "$RokitDownloadUrl"
        if [ ! -f "$CacheZipPath" ]; then
            echo -e "$Error Failed to download $RokitZipName."
            exit 1
        fi
    fi

    # Extract ZIP to temporary directory
    echo -e "$Info Extracting Rokit..."
    rm -rf "$ExtractDirectory"
    mkdir -p "$ExtractDirectory"
    unzip -q "$CacheZipPath" -d "$ExtractDirectory"

    # Run rokit self-install
    if [ -f "$ExtractDirectory/$RokitExecutable" ]; then
        echo -e "$Info Running rokit self-install..."
        "$ExtractDirectory/$RokitExecutable" self-install
    else
        echo -e "$Error rokit not found after extraction."
        exit 1
    fi
else
    echo -e "$Info Rokit is already installed."
fi

# Step 2 - Install tools from rokit.toml
echo -e "$Info Installing tools defined in rokit.toml..."
rokit install
if [ $? -ne 0 ]; then
    echo -e "$Error Failed to install tools from rokit.toml."
    exit 1
fi

# Step 3 - Print available bundle options
echo -e "\n$Info Available bundle options:"
echo -e "      * input[=\"default.project.json\"]"
echo -e "           Input .rbxm/.rbxmx or Rojo .project.json file"
echo -e "      * output[=\"{input-filename}.luau\"]"
echo -e "           Final output file (.lua or .luau)"
echo -e "      * minify[=false]"
echo -e "           Enable minification with Darklua"
echo -e "      * env-name[=\"MFeee~ New\"]"
echo -e "           Root environment name for runtime errors"
echo -e "      * darklua-config-path[=(\".darklua.json\", \".darklua.json5\")]"
echo -e "           Custom Darklua config path"
echo -e "      * temp-dir-base[=\"{output-dir}\"]"
echo -e "           Temp directory for Rojo/Darklua processing"
echo -e "      * extra-offset-lines[=0]"
echo -e "           Line offset for debugging info"
echo -e "      * ci-mode[=true]"
echo -e "           CI mode (non-interactive, errors exit with code 1)"
echo -e "      * verbose[=true]"
echo -e "           Verbose logging"
echo -e "\n$Info Example input: minify=true input=default.project.json output=Distribution/Script.luau\n"

# Step 4 - Ask for user input
read -p "Enter your bundle options: " UserOptions

# Step 5 - Run lune with user options
echo -e "\n$Info Running: lune run Build bundle $UserOptions"
echo "----------------------------------------"
lune run Build bundle $UserOptions
if [ $? -ne 0 ]; then
    echo -e "$Error Bundle process failed."
    exit 1
else
    echo -e "$Info Bundle completed successfully."
fi
