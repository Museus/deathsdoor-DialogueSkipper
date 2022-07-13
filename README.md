# Death's Door Dialogue Skipper
To improve accessability and decrease the risk of RSI when speedrunning Death's Door, the community has decided to allow an AutoHotKey script that skips dialogue when a customizable key is held.

To be transparent with usage,  an overlay is displayed in the top left corner of the screen, and a Window Capture must be added to your scene capturing it.

In order to prevent any additional benefits from the script, you must bind the script to the "Confirm" function. The default keybinding for that is Q, but you can rebind it if you have something else on Q.

## Installation
1. Install "Current Version" (currently v1.1.34.x) of AutoHotKey from [https://www.autohotkey.com/](https://www.autohotkey.com/ "https://www.autohotkey.com/")
2. Download the latest release of `DeathsDoorDialogueSkipper.ahk`
3. Double-click the script
4. Select key to hold and Confirm key (or configure using the instructions below)
5. Add a Window Capture source to OBS, with source "DD_SkippingOverlay"
6. Right-click on the source, Add Filter -> Color Key -> Color of background (by default ff00ff/magenta), adjust settings until the background is transparent and the text is visible

## Configuration
If you open the `DeathsDoorDialogueSkipper.ahk` script in Notepad, you will find a section marked
```
;;;;;;;;;;;;;;;;;;;;;;;;;
; CONFIGURATION SECTION ;
;;;;;;;;;;;;;;;;;;;;;;;;;
```

In that section, you can adjust:
 - the background color of the overlay window
 - the color of the "Skipping..." text
 - the key you want to hold to trigger the skipping script
 - the key you have Confirm bound to in-game

By default, these are:
 - Background: ff00ff (Magenta)
 - Font: 00ffff (Blue-green)
 - Key to hold: Prompted when launching script
 - Confirm key: Prompted when launching script

To find the colors you want, you can use https://color-hex.com/

## Credits
This script was based off the auto-skipper for The Witcher, available here: (https://gist.github.com/Gaztin/391afe70ceeb1c79005f21645cdc480d)

SpR3AD helped a ton with debugging and improving the script