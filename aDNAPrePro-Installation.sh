#!/usr/bin/env bash
set -e

# ------------------------------------------------------------
# Contact: alexandra.raimo@protonmail.com
# Project name:  aDNAPrePro
# Version: 1.1
# Date: Mar 2026
# aDNAPrePro-Install.sh this is the first of nine scripts to preprocess ancient DNA samples.
# This script is optional; it sets up the environment required for the remaining seven scripts. 
#
## The computational results of this work have been achieved using the University of Vienna`s Life Science Compute Cluster (LiSC).
## This script has been written to work on the LiSC cluster. Using this Pipeline in a different environment, you would possibly need to install some programs. 

# aDNAPrePro-Install.sh: Installation script to run the aDNAPrePro pipeline.
##
# Usage:
# Two possibilities to make the installation script executable:
#1: After downloading the repository from GitHub, run the installation script with:
#     bash aDNAPrePro-Install.sh
#####2: Alternatively, after downloading the repository from GitHub, make the script executable and run it directly:
# chmod 754 aDNAPrePro-Install.sh
# ------------------------------------------------------------

echo "Installing aDNAPrePro..."
echo "Start: $(date '+%H:%M')"

# $HOME is always the /path/to/your/homedirectory/
# Set up your working directory aDNAPrePro
WorkDir="$HOME/aDNAPrePro"
mkdir -p "$WorkDir"
mkdir -p "$WorkDir/Scripts"

# Check wget
if ! command -v wget &> /dev/null; then
    echo "Error: wget not found."
    exit 1
fi

# Download repository
RepoURL="https://github.com/raimo-al/LongTermStorageaDNA/archive/refs/heads/main.zip"
echo "Downloading aDNAPrePro from GitHub..."
wget -q -O "$WorkDir/aDNAPrePro.zip" "$RepoURL"
echo "Download complete."

# Extract repository
unzip -q "$WorkDir/aDNAPrePro.zip" -d "$WorkDir"

# Detect extracted folder
ExtractedDir=$(find "$WorkDir" -maxdepth 1 -type d -name "LongTermStorageaDNA-*" | head -n 1)

if [ -z "$ExtractedDir" ]; then
    echo "Error: Could not find extracted repository directory."
    ls -l "$WorkDir"
    exit 1
fi

# Detect script directory
ScriptDir=$(find "$ExtractedDir" -maxdepth 2 -type d -name "*aDNAPrePro*" | head -n 1)

if [ -z "$ScriptDir" ]; then
    echo "Error: Could not find script directory."
    ls -R "$ExtractedDir"
    exit 1
fi

# Copy ONLY prefixed scripts
#Copies all scripts with Prefix aDNAPrePro in the directory Scripts
cp "$ScriptDir"/aDNAPrePro*.sh "$WorkDir/Scripts/"
echo "Scripts installed in $WorkDir/Scripts."

# Removes $ExtractedDir
rm "$WorkDir/aDNAPrePro.zip"
rm -rf "$ExtractedDir"

cd "$WorkDir/Scripts"

#Remove Prefix aDNAPrePro in "$WorkDir/Scripts"
shopt -s nullglob
for f in aDNAPrePro-Step*.sh; do
    mv -n "$f" "${f#aDNAPrePro-}"
done

# Make all scripts executable
chmod 754 *.sh

echo "All scripts in "$WorkDir/Scripts" made executable."

# Create all working directories in your aDNAPrePro directory.
mkdir -p "$WorkDir/Cutadaptlogs" ## Cutadaptlogs: the dir hosting your cutadapt log files
mkdir -p "$WorkDir/Summaries"    ## Summaries: the dir hosting your Summary results
mkdir -p "$WorkDir/DATAnew"      ## DATAnew: the dir hosting your final txt file of the total, trimmed, unique/aligned and endogenous reads of all your samples.

echo "Working directories created in $WorkDir."

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

# Create scratch subdirectories
mkdir -p "$ScratchDir/Step0d" ## Step0d: the directory hosting your *.fastq.gz files
mkdir -p "$ScratchDir/Step1d" ## Step1d: the directory hosting your *.fastq files
mkdir -p "$ScratchDir/Step2d" ## Step2d: the directory hosting your alignment results (*.sam and *.sam.log)
mkdir -p "$ScratchDir/Step3d" ## Step3d: the output directory hosting your *.bam files

echo "Scratch directories created in $ScratchDir."

echo "Installation of aDNAPrePro is complete."
echo "Scripts are located in $WorkDir/Scripts"
echo "Working directory: $WorkDir"
echo ""
echo "Once you want to run the pipeline, next steps:"
echo "cd $WorkDir/Scripts"
#echo "source aDNAPrePro-LoadModules.sh"
echo "./Step1.sh"
echo ""

# Removing installation script.

SCRIPT_PATH="${BASH_SOURCE[0]}"
if [ -f "$SCRIPT_PATH" ]; then
    rm -- "$SCRIPT_PATH"
    echo "Installation script removed."
fi
echo "End: $(date '+%H:%M')"
