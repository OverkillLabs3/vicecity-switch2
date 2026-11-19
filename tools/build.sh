#!/bin/bash
# Builds GTA Vice City (reVC) for the Nintendo Switch 2 and checks the result. Needs devkitPro with the Switch 2 devkit.
set -e
R="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DEVKITPRO="${DEVKITPRO:-/opt/devkitpro}"
export DEVKITA64="$DEVKITPRO/devkitA64"
. "$DEVKITPRO/switch2vars.sh"
export PORTLIBS_ROOT="$DEVKITPRO/portlibs"
export PATH="$DEVKITPRO/tools/bin:$DEVKITA64/bin:$PATH"
export PKG_CONFIG_PATH="$DEVKITPRO/portlibs/switch2/lib/pkgconfig:$DEVKITPRO/portlibs/switch/lib/pkgconfig"
export PKG_CONFIG_LIBDIR="$PKG_CONFIG_PATH"
unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS LIBS

S="$R/third_party/revc"
cd "$S"
[ -d build ] || cmake -G "Unix Makefiles" -B build -DCMAKE_TOOLCHAIN_FILE="$DEVKITPRO/libounce/cmake/Switch2.cmake" \
    -DCMAKE_BUILD_TYPE=Release -DCMAKE_DEPENDS_USE_COMPILER=OFF -DLIBRW_PLATFORM=GL3 -DLIBRW_GL3_GFXLIB=SDL2 \
    -DREVC_AUDIO=OAL -DREVC_WITH_OPUS=OFF -DREVC_WITH_LIBSNDFILE=OFF
cmake --build build -j"$(nproc 2>/dev/null || echo 4)"

# the Switch 2 headers must come before the Switch 1 ones
first=$(grep -o "libounce/include\|libnx/include" build/src/CMakeFiles/reVC.dir/flags.make | head -1)
[ "$first" = "libounce/include" ] || { echo "the include path starts with $first, not libounce/include"; exit 1; }

# link again with a map file to see which libraries went in
cd build/src
sed "s#\$# -Wl,-Map,reVC.map#" CMakeFiles/reVC.dir/link.txt > relink.sh
sh relink.sh
aarch64-none-elf-strip -o reVC_stripped.elf reVC.elf
nacptool --create "Vice City" "OverkillLabs3" "1.0.0" reVC.nacp
elf2nro reVC_stripped.elf reVC.nro --icon="$S/res/images/logo_256.jpg" --nacp=reVC.nacp > /dev/null

bash "$R/tools/verify_elf.sh" reVC.elf
python3 "$R/tools/verify_nro.py" reVC.nro reVC.map
mkdir -p "$R/build" && cp reVC.nro "$R/build/vicecity.nro"
echo "built $R/build/vicecity.nro"
