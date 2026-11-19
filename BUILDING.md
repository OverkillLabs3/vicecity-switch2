# Building

The game is built with devkitPro and the Switch 2 devkit (libounce, OunceVK), on Windows (the devkitPro MSYS2 shell) or on Linux.

## Requirements

- [devkitPro](https://devkitpro.org/wiki/Getting_Started) with the `switch-dev` group and the Switch portlibs `switch-sdl2`, `switch-openal` and `switch-mpg123`
- the [ounce-devkit](https://github.com/ouncebrew/ounce-devkit), installed into the same devkitPro (run its `install.sh`)
- `curl`, `patch`, `python3` and `cmake`
- `DEVKITPRO` set (the default is `/opt/devkitpro`)

## Steps

```sh
bash tools/fetch_sources.sh     # reVC and librw at the pinned commits, into third_party/
bash tools/apply_patches.sh     # the Switch 2 changes
bash tools/build.sh             # builds, checks and writes build/vicecity.nro
python3 tools/package.py        # the SD-card zip in dist/
```

`build/vicecity.nro` is the program. `tools/build.sh` links with a map file and runs the checks on the result:

- the include path must start with the Switch 2 headers
- `tools/verify_elf.sh` refuses a program that was not linked against the Switch 2 runtime or that carries the Switch 1 graphics libraries
- `tools/verify_nro.py` checks the NRO header and, with the map, that no Switch 1 library went into the link

A program built against the Switch 1 libnx can make the console warn that it may crash the system, so do not skip these checks.

## Layout

| Path | What |
|---|---|
| `patches/0001-revc-nintendo-switch-2.patch` | the game changes: build files, the controller layout and bindings, the Joy-Con mouse, 120 Hz, texture loading, the FPS counter |
| `patches/0002-librw-nintendo-switch-2.patch` | the renderer changes: OpenGL ES 3.0 only, window and context setup, the 120 Hz request |
| `src/switch_glue.cpp` | the Switch 2 start-up code, the Joy-Con mouse and the settings files |
| `tools/` | fetch, patch, build, check and package scripts |
