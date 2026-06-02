#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# Contact: alexandra.raimo@protonmail.com
# Project name: LongTermStorageaDNA Pipeline
# Version: 1.0
# Date: May 2026
##
# module: RunDeam
# Version: 1.0
# Date: May 2026
#
# RunDeam-Installation.sh this is the first script to run the RunDeam module.
# This script is optional; it sets up the environment required for the remaining scripts in this module. 
#
# This script sets up the environment required to assess terminal deamination patterns in ancient DNA samples using mapDamage.
#
## The computational results of this work have been achieved using the University of Vienna`s Life Science Compute Cluster (LiSC).
## This script has been written to work on the LiSC cluster. Using this Pipeline in a different environment, you would possibly need to install some programs. 
# ------------------------------------------------------------

echo "Installing RunDeam..."
echo "Start: $(date '+%H:%M')"

# $HOME is always the /path/to/your/homedirectory/
# Set up your working directory for the module RunDeam
WorkDir="$HOME/RunDeam"         ## RunDeam: your working dir for your RunDeam module 
ScriptsDir="$WorkDir/Scripts"   ## Scripts: the dir hosting the scripts needed for your RunDeam module
ResultsDir="$WorkDir/Results"   ## Results: the dir hosting your generated file with the script RunDeam.sh
#Create directories:
mkdir -p "$WorkDir"
mkdir -p "$ScriptsDir"
mkdir -p "$ResultsDir"       

echo "Working directories created in $WorkDir."

# Check wget
if ! command -v wget &> /dev/null; then
    echo "Error: wget not found."
    exit 1
fi

# Check unzip
if ! command -v unzip &> /dev/null; then
    echo "Error: unzip not found."
    exit 1
fi

# Download module from REPO
RepoURL="https://github.com/raimo-al/LongTermStorageaDNA/archive/refs/heads/main.zip"
echo "Downloading RunDeam from GitHub..."
wget -q -O "$WorkDir/RunDeam.zip" "$RepoURL"
echo "Download complete."

# Extract repository
unzip -q "$WorkDir/RunDeam.zip" -d "$WorkDir"

# Detect extracted folder
ExtractedDir=$(find "$WorkDir" -maxdepth 1 -type d -name "LongTermStorageaDNA-*" | head -n 1)

if [ -z "$ExtractedDir" ]; then
    echo "Error: Could not find extracted repository directory."
    ls -l "$WorkDir"
    exit 1
fi

# Detect module directory
ScriptDir="$ExtractedDir/modules/RunDeam"

# Check module
if [[ ! -d "$ScriptDir" ]]; then
    echo "Error: RunDeam module not found in modules/RunDeam"
    exit 1
fi

# Copy module scripts
cp "$ScriptDir"/*.sh "$ScriptsDir/"

# Removes $ExtractedDir
rm "$WorkDir/RunDeam.zip"
rm -rf "$ExtractedDir"

cd "$WorkDir/Scripts"


# Make all scripts executable
chmod 754 "$ScriptsDir"/*.sh
echo "All scripts made executable in $WorkDir/Scripts."

# Customising the scratch directory path

read -p "Do you want to use a scratch directory? (y/n): " use_scratch

if [[ "$use_scratch" =~ ^[Yy]$ ]]; then
    while true; do
        read -p "Enter scratch directory path: " ScratchDir
        
        if [ ! -d "$ScratchDir" ]; then
            echo "Path does not exist."
            read -p "Try again? (y/n): " retry
            [[ "$retry" =~ ^[Nn]$ ]] && ScratchDir="$WorkDir" && break
            continue
        fi
        
        if [ ! -w "$ScratchDir" ]; then
            echo "No write permission."
            read -p "Try another path? (y/n): " retry
            [[ "$retry" =~ ^[Nn]$ ]] && ScratchDir="$WorkDir" && break
            continue
        fi
        
        echo "Using scratch directory: $ScratchDir"
        break
    done
else
    ScratchDir="$WorkDir"
    echo "Using working directory as scratch: $ScratchDir"
fi


# Create AllBam directory in $ScratchDir
AllBamDir="$ScratchDir/AllBam"
if [[ ! -d "$AllBamDir" ]]; then
    mkdir -p "$AllBamDir"
    echo "$AllBamDir dir created: Please move all *.bam and index *.bai files in this dir for the scripts to work."
else
    echo "$AllBamDir already exists."
fi

# Create ref dir for your preferred reference genome
RefDir="$ScratchDir/ref"
if [[ ! -d "$RefDir" ]]; then
    mkdir -p "$RefDir"
    echo "$RefDir dir created."
else
    echo "$RefDir already exists."
fi

echo ""
echo "Please move your preferred reference genome (*.fa) in:"
echo "$RefDir"

# Create config file
ConfigFile="$WorkDir/config.sh"
echo "Creating config file at $ConfigFile"
cat > "$ConfigFile" <<EOF


# RunDeam configuration file
WorkDir="$WorkDir"
ScratchDir="$ScratchDir"
OutputDir="\$WorkDir/Results"
InputBam="\$ScratchDir/AllBam"
RefDir="\$ScratchDir/ref"
EOF
echo ""
echo "Once you want to run the pipeline, next steps: cd $WorkDir/Scripts"
echo ""
echo "Final steps: 1.) Please place your *.bam and index *.bai files in $AllBamDir and 2.) Preferred reference genome (*.fa) in $RefDir"
echo ""
echo "End: $(date '+%H:%M')"