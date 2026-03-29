#!/usr/bin/env bash
set -e

# ------------------------------------------------------------
# Contact: alexandra.raimo@protonmail.com
# Project name: aDNAPrePro
# Version: 1.1
# Date: Mar 2026
# aDNAPrePro-Step4CreateReport.sh this is the eighth of eight scripts to preprocess ancient DNA samples.
#
## The computational results of this work have been achieved using the University of Vienna`s Life Science Compute Cluster (LiSC).
## This script has been written to work on the LiSC cluster. Using this Pipeline in a different environment, you would possibly need to install some programs. 

## aDNAPrePro-Step4CreateReport.sh creates a report (txt file) summarising the total, trimmed, unique/aligned and/or endogenous reads of all your samples.

# Usage:
# If you did not download the scripts using wget, first make the script executable:
# chmod 754 aDNAPrePro-Step4CreateReport.sh
#   ./aDNAPrePro-Step4CreateReport.sh -s {1|2|a} [-sep {c|s}]
#
#   -s 1   Total Reads & Trimmed Reads report
#   -s 2   Endogenous & Unique report
#   -s a   both
#
#   -sep c ? comma separated; numbers with decimal dot
#   -sep s ? semicolon separated; numbers with decimal comma (default as in Europe)
# ------------------------------------------------------------

echo "Start: $(date '+%H:%M')"

# $HOME is always the /path/to/your/homedirectory/
# Set up your working directory aDNAPrePro
WorkDir="$HOME/aDNAPrePro"

separator=";"   # default

# Parse options:

while [[ $# -gt 0 ]]; do
    case "$1" in
        -s)
            scope="$2"
            shift 2
            ;;
        -sep)
            case "$2" in
                c) separator="," ;;
                s) separator=";" ;;
                *) echo "Error: -sep must be c or s"; exit 1 ;;
            esac
            shift 2
            ;;
        *)
            echo "Usage: $0 -s {1|2|a} [-sep {c|s}]"
            exit 1
            ;;
    esac
done

if [[ -z "$scope" ]]; then
    echo "Error: -s option required (1, 2 or a)"
    exit 1
fi

# create DATAnew if it doesn´t exist
mkdir -p "$WorkDir/DATAnew"

######################################
# Report 1:Total Reads & Trimmed Reads
######################################

if [[ "$scope" == "1" || "$scope" == "a" ]]; then

    echo "Running CreateReport1..."

    # Total Reads
    {
        echo "ID${separator}Total Reads"
        for filename in "$WorkDir"/Cutadaptlogs/*; do
            base="${filename##*/}"
            sample="${base:0:6}"
            value=$(grep 'Total reads processed' "$filename" | sed -e 's/Total reads processed://g' -e 's/,//g' -e 's/^ *//' -e 's/  */ /g')
            echo "${sample}${separator}${value}"
        done
    } > "$WorkDir/DATAnew/DATA_Reads.txt"

    # Trimmed Reads
    {
        echo "ID${separator}Trimmed Reads${separator}Percentual"
        for filename in "$WorkDir"/Cutadaptlogs/*; do
            base="${filename##*/}"
            sample="${base:0:6}"
            value=$(grep 'Reads with adapters' "$filename" | sed -e 's/Reads with adapters://g' -e 's/,//g' -e 's/[()%]//g' -e 's/^ *//' -e 's/  */ /g')

            # Decimal formatting depending on separator
            if [[ "$separator" == ";" ]]; then
                value=$(echo "$value" | sed 's/\./,/')
            fi

            value=$(echo "$value" | sed "s/ /${separator}/g")
            echo "${sample}${separator}${value}"
        done
    } > "$WorkDir/DATAnew/DATA_TrimmedReads.txt"

fi


############################################
# Report 2: Endogenous & Unique
############################################
if [[ "$scope" == "2" || "$scope" == "a" ]]; then

    echo "Running CreateReport2..."

    # Endogenous (mapped reads)
    {
        echo "ID${separator}Endogenous"
        for filename in "$WorkDir"/Summaries/*tsvsummary.txt; do
            base="${filename##*/}"
            sample="${base:0:6}"
            value=$(sed -n '7p' "$filename" | cut -f1)
            echo "${sample}${separator}${value}"
        done
    } > "$WorkDir/DATAnew/DATA_Endogenous.txt"

    # Unique (primary mapped reads)
    {
        echo "ID${separator}Unique"
        for filename in "$WorkDir"/Summaries/*tsvsummary.txt; do
            base="${filename##*/}"
            sample="${base:0:6}"
            value=$(sed -n '9p' "$filename" | cut -f1)
            echo "${sample}${separator}${value}"
        done
    } > "$WorkDir/DATAnew/DATA_Unique.txt"

fi

echo "End:   $(date '+%H:%M')"