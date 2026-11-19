# Vice City for Switch 2

**Grand Theft Auto: Vice City for the Nintendo Switch 2, as native homebrew at 120 frames per second.**

Built from [reVC](https://github.com/mrxenginner/reVC) and its renderer [librw](https://github.com/mrxenginner/librw) with the OpenGL ES backend, linked against the Switch 2 runtime and graphics driver of the [ounce-devkit](https://github.com/ouncebrew/ounce-devkit). It is not a Switch 1 build running in a compatibility layer. The source changes are in this repository and the build is on the [Releases](../../releases) page.

## How to play
1. Download `vicecity-switch2-1.0.0.zip` from the [Releases](../../releases) page and unzip it onto the root of the console's SD card.
2. Copy **your own** Vice City folders `Audio`, `anim`, `data`, `models`, `mp3`, `skins`, `TEXT` and `txd` from Steam into `switch/gtavc/`. Keep the files of the download when asked.
3. Start **Vice City** from the homebrew menu. Hold **R** while starting a game to open it on a console running kaiHEN.

Nothing else to install. Your game files are never modified. Saves and settings are kept in `switch/gtavc/`.

Step-by-step guide, including where every file goes: [INSTALL.md](INSTALL.md).

## Highlights
- Native Switch 2 homebrew: OpenGL ES 3.0 on the console's own graphics driver
- 1920x1080 in handheld and docked mode
- Presents at the display's highest refresh rate: 120 Hz in handheld mode, with the frame limit raised to 120
- The highest graphics settings on the first start: longer draw distance, PS2 style transparency, the post effects and the new vehicle and world shaders
- Textures are loaded as stored, so there is no long conversion on the first start
- **Joy-Con mouse:** slide a Joy-Con 2 over a table to look around and aim, with L or ZL, R or ZR to click
- Nintendo button layout: A on the right, B at the bottom, X at the top, Y on the left
- An FPS counter you can turn on while playing: click both sticks together. The choice is remembered

## Controls
The pad follows the layout of the console versions of the game. Change the bindings in the game's own **Controller Setup** menu.

| Input | What it does |
|---|---|
| Left stick | walk, drive |
| Right stick | camera |
| D-pad left or right | change the radio station |
| D-pad up | change the camera view |
| Joy-Con mouse, sliding | look and aim, move the menu cursor |
| Joy-Con mouse, L / ZL or R / ZR | left click, right click |
| Both stick clicks together | FPS counter on or off |

## Known issues
- Only the Steam version of Vice City was tested.
- With the Joy-Con mouse, the buttons of the other hand still work as pad buttons, so firing with the trigger can change the weapon. Fire with the mouse buttons or with the pad instead.
- Docked mode renders 1920x1080 and the system scales it to the TV. A native 4K picture is not supported yet.
- The touch screen is not used.

## Notes
- You must supply your own, legally obtained copy of Vice City. No game files of Rockstar Games are included; the download contains only the game files of the reVC project.
- Requires a Nintendo Switch 2 running kaiHEN, with the homebrew menu.
- Build instructions: [BUILDING.md](BUILDING.md).

## Credits and licences
- [reVC](https://github.com/mrxenginner/reVC) by mrxenginner and the reVC contributors, and the re3 project it descends from. See the licence of that project.
- [librw](https://github.com/mrxenginner/librw) by aap and contributors, MIT (`LICENSE.librw`).
- [kaiHEN](https://github.com/ouncebrew/kaihen) and the [ounce-devkit](https://github.com/ouncebrew/ounce-devkit) by ouncebrew.
- SDL2, OpenAL and mpg123 for the Switch from devkitPro.

This repository contains only the Switch 2 changes and the tools to build them. They are released under the MIT licence (`LICENSE`). Grand Theft Auto and Vice City are trademarks of Take-Two Interactive. This project is not affiliated with or endorsed by Rockstar Games or Take-Two.
