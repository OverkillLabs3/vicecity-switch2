#!/bin/bash
# Usage: verify_elf.sh <program.elf>
# Exits with 1 unless the ELF was linked against the Nintendo Switch 2 runtime (libounce).
# A build against the Switch 1 libnx has no __ounce_platform symbol and the console warns that it may crash the system.
# A program that uses EGL must also carry the Switch 2 graphics driver (zink on NVK), not the Switch 1 Mesa stubs.
NM="${DEVKITPRO:-/opt/devkitpro}/devkitA64/bin/aarch64-none-elf-nm"
[ -x "$NM" ] || NM="$NM.exe"
elf="$1"
[ -f "$elf" ] || { echo "usage: verify_elf.sh <program.elf>"; exit 2; }
syms=$("$NM" "$elf" 2>/dev/null)
fail=0
if ! echo "$syms" | grep -q " __ounce_platform$"; then
    echo "FAIL: no __ounce_platform symbol, this was not linked against libounce"
    fail=1
fi
if echo "$syms" | grep -q "eglInitialize"; then
    z=$(echo "$syms" | grep -c -i "zink")
    n=$(echo "$syms" | grep -c -i "nvk")
    if [ "$z" -lt 100 ] || [ "$n" -lt 100 ]; then
        echo "FAIL: uses EGL but the Switch 2 graphics driver is missing (zink symbols: $z, nvk symbols: $n)"
        echo "      the link picked up the Switch 1 Mesa libraries: portlibs/switch2/lib must come first in the -L order"
        fail=1
    fi
    if echo "$syms" | grep -q "nouveau_device_new"; then
        echo "FAIL: contains the Switch 1 nouveau driver"
        fail=1
    fi
fi
[ $fail -eq 0 ] && echo "OK: Switch 2 runtime present ($elf)"
exit $fail
