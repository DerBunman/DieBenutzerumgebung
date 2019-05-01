# zkeys.zsh
zkeys.zsh is a script which will check if there are rules defined for the current active WM_CLASS and then load xmodmap and/or xbindkeys configurations.

## xmodmap
With xmodmap you can replace keys on your keyboard with other keys.

### Example
If there is a file called `~/.xkeys/urxvt.xmodmap` the script will apply it immediatly when a window with the WM_CLASS `urxvt` (str2lower) has focus. As soon, as it looses focus, the rules will be set according to the new WM_CLASS.

#### `~/.xkeys/urxvt.xmodmap`
```
keycode  24 = a A a A adiaeresis Adiaeresis at Greek_OMEGA
```
This config would set the q button to a when a urxvt window has focus. This makes no sense, because you'll need the a key. Howewer, it is just an example.

## xbindkeys
With xbindkeys you can assign commands (eg xdotool) to keys and key combinations. The loading mechanismus is just like xmodmap but .xbindkeys as extention.

## xdotool
Most xbindkeys configs will use xdotool.
