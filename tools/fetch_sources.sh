#!/bin/bash
# Fetches the pinned reVC and librw sources into third_party/ (as archives of the exact commits).
set -e
R="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REVC=a26fff4af555a8a425ac9f17d1dd718d00d1f942
LIBRW=68a4247217bb4de4f9c9d0b244d6efbe3170abc5
mkdir -p "$R/third_party" && cd "$R/third_party"
if [ ! -d revc ]; then
    curl -fL -o revc.zip "https://github.com/mrxenginner/reVC/archive/$REVC.zip"
    python3 -c "import zipfile,sys; zipfile.ZipFile('revc.zip').extractall('.')"
    mv "reVC-$REVC" revc && rm revc.zip
fi
if [ ! -f revc/vendor/librw/rw.h ]; then
    curl -fL -o librw.zip "https://github.com/mrxenginner/librw/archive/$LIBRW.zip"
    python3 -c "import zipfile,sys; zipfile.ZipFile('librw.zip').extractall('.')"
    rm -rf revc/vendor/librw && mv "librw-$LIBRW" revc/vendor/librw && rm librw.zip
fi
