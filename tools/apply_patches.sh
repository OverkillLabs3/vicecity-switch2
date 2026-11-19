#!/bin/bash
# Applies the Switch 2 changes to reVC and librw in third_party/ and adds src/switch_glue.cpp to the game.
set -e
R="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
apply() {
    cd "$1"
    if git apply --check --ignore-whitespace "$2" 2>/dev/null; then
        git apply --ignore-whitespace "$2"
        echo "applied  $(basename "$2")"
    else
        echo "already applied or does not fit: $(basename "$2")"
    fi
}
(apply "$R/third_party/revc" "$R/patches/0001-revc-nintendo-switch-2.patch")
(apply "$R/third_party/revc/vendor/librw" "$R/patches/0002-librw-nintendo-switch-2.patch")
cp "$R/src/switch_glue.cpp" "$R/third_party/revc/src/skel/sdl2/switch_glue.cpp"
