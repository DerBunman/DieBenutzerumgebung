# Keymaps

## TODO
* Define more shortcuts that make sense.
* Decicde what to do about Ctrl+a not beeing mapped to select all.


## Globl keyboard shortcuts

| Shortcut         | Comment               | urxvt  | VIM    | gVIM   | zsh    | tmux   | rofi   | Firefox |
|------------------|-----------------------|--------|--------|--------|--------|--------|--------|---------|
| Ctrl+a           | jump to BOL           | native | native | native | native | native | native | xkeys   |
| Ctrl+e           | jump to EOL           | native | native | native | native | native | native | xkeys   |
| Ctrl+Equal       | inc. font size        | native | -      | xkeys  | native | -      | native | native  |
| Ctrl+Shift+Equal | inc. font size        | native | -      | xkeys  | native | -      | native | native  |
| Ctrl+Minus       | dec. font size        | native | -      | xkeys  | native | -      | native | native  |
| Ctrl+0           | reset font size       | native | -      | xkeys  | native | -      | native | native  |
| Ctrl+Left        | jump before last word | native | native | native | native | native | native | native  |
| Ctrl+Right       | jump after next word  | native | native | native | native | native | native | native  |
| Alt+s            | search and select     | native | -      | -      | -      | TODO   | -      | -       |



| Legend  | Comment                                                                       |
|---------|-------------------------------------------------------------------------------|
| native  | The application supports the shortcuts or is easily configurable.             |
| xkeys   | Works fine withe the xkeys.zsh script. (Which uses xbindkeys/xmodmap/xdotool) |
| TODO    | The application would benefit from the shortcut but I haven't checked it yet. |
| PROBLEM | The application doesn't support the shortcut but would profit from it.        |
| -       | The application doesn't support the shortcut but wouldn't profit from it.     |

## BSPWM keymap

### Run/Reload/Close/Quit

| Shortcut              | Function            | Description                                        |
|-----------------------|---------------------|----------------------------------------------------|
| Super + Return        | open urxvt          | Opens a Terminal (urxvt).                          |
| Super + d             | open rofi           | Opens the rofi run command dialog.                 |
| Super + Esc           | reload sxhkd        | Reloads sxhkd's config. (these shortcuts here)     |
| Super + Alt + q       | quit bspwm          | Ends you X-session                                 |
| Super + Alt + r       | reload bspwm        | Reloads bspwm configs.                             |
| Super + w             | close window        | Closes the currently focused window. Using SIGTERM |
| Super + Shift + w     | kill window         | Closes the currently focused window. Using SIGKILL |
| Super + x             | lock screen         | Runs xscreensaver-command -lock                    |
| XF86AudioRaiseVolume  | raise volume        | Raise volume via pactl.                            |
| XF86AudioLowerVolume  | lower volume        | Lower volume via pactl.                            |
| XF86AudioMute         | mute sound          | Mute sound via pactl.                              |
| XF86MonBrightnessUp   | increase brightness | Increase brightness using xbacklight.              |
| XF86MonBrightnessDown | decrease brightness | Decrease brightness using xbacklight.              |
| Super + Shift + s     | take screenshot     | Takes a screenshot and places it in the clipboard. |
| Super + q             | VIM scratchpad      | Toggles a floating gVIM for notes.                 |

### Navigation

| Shortcut                    | Function       | Description                                             |
|-----------------------------|----------------|---------------------------------------------------------|
| Super + h,j,k,l             | change focus   | Change focus left,down,up,right                         |
| Super + left,down,up,right  | change focus   | Change focus left,down,up,right                         |
| Super + c                   | focus next     | Focus the next node in the current desktop.             |
| Super + Shift + c           | focus prev     | Focus the previous node in the current desktop.         |
| Super + },{                 | next desktop   | Focus the next/previous desktop in the current monitor. |
| Super + grave               | last node      | Focus the last node.                                    |
| Super + Tab                 | last desktop   | Focus the last node.                                    |
| Super + o,i                 | focus history  | Focus the older or newer node in the focus history.     |
| Super + 0,1,2,3,4,5,6,7,8,9 | change desktop | Focus the given desktop.                                |

### Moving windows

| Shortcut                                 | Function            | Description                                        |
|------------------------------------------|---------------------|----------------------------------------------------|
| Super + Shift + 0,1,2,3,4,5,6,7,8,9      | send to desktop     | Send focused window to the given desktop.          |
| Super + Ctrl + h,j,k,l                   | preselect           | Preselect the direction for the next window.       |
| Super + Ctrl + left,down,up,right        | preselect           | Preselect the direction for the next window.       |
| Super + Ctrl + 0,1,2,3,4,5,6,7,8,9       | ratio               | preselect the ratio                                |
| Super + Ctrl + Space                     | cancel preselection | Cancel the preselection for the focused window.    |
| Super + Ctrl Shift + Space               | cancel preselection | Cancel the preselection for the focused desktop.   |
| Super + Alt + h,j,k,l                    | resize              | Expand a window by moving one of its side outward. |
| Super + Alt + left,down,up,right         | resize              | Expand a window by moving one of its side outward. |
| Super + Alt + Shift + h,j,k,l            | resize              | Shrink a window by moving one of its side inward.  |
| Super + Alt + Shift + left,down,up,right | resize              | Shrink a window by moving one of its side inward.  |
| Super + left,down,up,right               | move floating       | Move a focused floating window.                    |

### Window layout

| Shortcut           | Function     | Description                                             |
|--------------------|--------------|---------------------------------------------------------|
| Super + m          | monocycle    | Alternate the focused between tiled and monocle layout. |
| Super + t          | tiled        | Set focused windwow to tiling.                          |
| Super + Shift + t  | pseudo_tiles | Set focused windwow to tiling.                          |
| Super + s          | floating     | Set focused windwow to floating.                        |
| Super + f          | fullscreen   | Set focused windwow to fullscreen.                      |
| Super + Mousewheel | window gaps  | Increase/Decrease the window gap.                       |

### Window flags

| Shortcut          | Function      | Description                                                    |
|-------------------|---------------|----------------------------------------------------------------|
| Super + Ctrl + x  | locked        |                                                                |
| Super + Ctrl + y  | sticky        | Show window on all desktops.                                   |
| Super + Ctrl + z  | private       |                                                                |
| Super + Ctrl + m  | mark window   | Sets a mark for the current window.                            |
| Super + y         | move window   | Moves the newest marked window to the newest preselected node. |
| Super + Shift + i | invert window | Invert current window.                                         |
