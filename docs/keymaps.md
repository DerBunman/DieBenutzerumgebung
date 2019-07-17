# Keymaps

## TODO
* Define more shortcuts that make sense.
* Decicde what to do about Ctrl+a not beeing mapped to select all.


## Keyboard Shortcuts

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

