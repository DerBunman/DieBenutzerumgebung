# zkeys.zsh
zkeys.zsh is a script which will check if there are rules defined for the current active WM_CLASS and then load xmodmap and/or xbindkeys configurations.

## xmodmap
With xmodmap you can replace keys on your keyboard with other keys.

### Example
If there is a file called `~/.xkeys/urxvt.xmodmap` the script will apply it immediatly when a window with the WM_CLASS `urxvt` (str2lower) has focus. As soon, as it looses focus, the rules will be set according to the new WM_CLASS.

#### `~/.xkeys/urxvt.xmodmap`
```xmodmap
keycode  24 = a A a A adiaeresis Adiaeresis at Greek_OMEGA
```
This config would set the q button to a when a urxvt window has focus. This makes no sense, because you'll need the a key. Howewer, it is just an example.

## xbindkeys
With xbindkeys you can assign commands (eg xdotool) to keys and key combinations. The loading mechanismus is just like xmodmap but .xbindkeys as extention.

### Example
For example, gVIM isn't able to correctly parse `Control+Plus/Minus/Equal`. [A explanation, why this won't work can be fond here.](https://groups.google.com/forum/#!topic/vim_dev/EZT_Q0YRmAM)

So what do we do? We just map everything to `Alt+key` and then let xbindkeys translate the `Control`  commands to `Alt` commands.

#### ~/.xkeys/gvim.xbindkeys
```xbindkeys
# change fontsize witch ctrl+plus/minus/zero
"xdotool keyup --clearmodifiers 0 key --clearmodifiers alt+0 keyup --clearmodifiers alt"
   Control + 0

"xdotool keyup --clearmodifiers minus key --clearmodifiers alt+minus keyup --clearmodifiers alt"
    m:0x4 + c:20
    Control + minus

"xdotool key --delay 150 --clearmodifiers alt+equal keyup --clearmodifiers alt"
    m:0x4 + c:21
    Control + equal

"xdotool keyup --clearmodifiers plus key --clearmodifiers alt+equal keyup --clearmodifiers alt"
    m:0x5 + c:21
    Control+Shift + equal
```

## xdotool
Most xbindkeys configs will use xdotool.
