# Ghostrunner Remake
A Ghostrunner 2 Movement Remake in Portal 2, using only VScript and Squirrel.

## Installation
In order to install this mod, you're going to need [spplice](https://p2r3.com/spplice).

### Using spplice repositories
Within spplice, click `+` in the top right. Select "Enter repository URL" and paste `https://pancake.gay/ghostrunner`.
If done correctly, you will now have access to the latest development build and all epochtal weeks.

### Using spplice packages
First, you need to download the latest dev build from the github actions page.
Click [Actions](https://github.com/PancakeTAS/Ghostrunner-Remake/actions) and select the latest workflow run. Then under artifacts you'll need to download and unzip the Spplice package.
Within spplice, click `+` in the top right. Select the p2ghostrunner.sppkg file you just downloaded.
Once again if done correctly, you will now be able to select ghostrunner in the mod selection screen.

> [!TIP]
> You can download the latest **epochtal** spplice package in the [releases](https://github.com/PancakeTAS/Ghostrunner-Remake/releases) section or using the spplice repository.
> In the releases section you will also find my playthrough of the map

## Known issues
> [!WARNING]
> Read this before playing the mod!

- After changing the speaker configuration, run `snd_updateaudiocache` in the console (otherwise custom sounds will not play)
- After changing the screen resolution, restart the game (otherwise the ingame text will have the wrong size)
- Do not abuse corner walljumps to gain infinite height (I don't know how to fix them)
- It is not recommended to use the scroll wheel for jumping (you *will* break the physics)
- If you use "Continue" in the main menu after having updated the mod, the mod will most likely break
- Maps with lasers are not implemented as intended yet

Report issues in the GR thread of the [PortalRunner Community Discord](https://discord.gg/kbhq2qck5k)

## Libraries
Uses [ppmod4](https://github.com/p2r3/ppmod/tree/main) written by p2r3
and [vpp](https://github.com/0xNULLderef/vpp) (no longer in use) written by 0xNULLderef.
