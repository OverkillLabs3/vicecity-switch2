# Installing Vice City on the Switch 2

You need a Nintendo Switch 2 running kaiHEN, a PC, the console's SD card and your own copy of Grand Theft Auto: Vice City from Steam. It takes about 10 minutes.

## 1. Put the port on the SD card

1. Download `vicecity-switch2-1.0.0.zip` from the Releases page.
2. Put the console's SD card in your PC.
3. Unzip the file onto the **root** of the SD card. If asked, allow it to merge with the existing `switch` folder.

## 2. Copy your game files

Open the folder of your game: in Steam, right-click **Grand Theft Auto: Vice City**, choose **Manage**, then **Browse local files**. Copy these folders into `switch/gtavc/` on the SD card:

`Audio`, `anim`, `data`, `models`, `mp3`, `skins`, `TEXT`, `txd`

The unzipped download already put a few files in `data`, `models` and `TEXT`. Merge the folders, and when asked about files that exist, **keep the ones from the download**: they replace the original ones. You should now have:

```
SD card
└── switch
    ├── vicecity.nro
    └── gtavc
        ├── Audio
        ├── anim
        ├── data
        ├── models
        ├── mp3
        ├── skins
        ├── TEXT
        └── txd
```

The Windows program files are not used.

## 3. Play

1. Put the SD card back in the console and start the homebrew menu the way you normally do with kaiHEN.
2. Start **Vice City**.

The first start applies the highest graphics settings. They can be changed in the game's **Display Setup** menu afterwards.

If the game does not start, the reason is in `switch/gtavc/log.txt` on the SD card.

## Tips

- Launch the game from a fresh homebrew menu. If another homebrew was started before it without restarting the menu, the graphics may not start; start the menu again.
- To use a Joy-Con as a mouse, put it down on a table and slide it.
- Click both sticks together to show or hide the FPS counter.
