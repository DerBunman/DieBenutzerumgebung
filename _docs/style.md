# Style

## Theming and colors
The GTK2/3 and icon theme are based on Numix and can be generated using ooxmox (see below).

The colors are everywhere the same. (If I didn't miss anything.)

## Fonts
The main font face for __DieBenutzerumgebung__ is __Roboto__ (and Roboto Mono).
__Roboto__ is mainly used in the styles regular and medium.

Addionaly to these fonts is Roboto Mono patched with Nerdfont glyphs available for polybar and powerline and everything else that needs glyphs.

# Current state

| Package | Type  | Comment              | Theme | Colorscheme |
|---------|-------|----------------------|-------|-------------|
| GTK2    | lib   | GTK legacy theme     | OK    | OK          |
| GTK3    | lib   | GTK theme            | OK    | OK          |
| i3      | X11   | the windowmanager    | -     | OK          |
| polybar | X11   | i3bar replacement    | OK    | OK          |
| urxvt   | X11   | the terminal         | -     | OK          |
| rofi    | X11   | the launcher         | OK    | OK          |
| dunst   | X11   | notification daemon  | OK    | TODO        |
| gVIM    | GTK3  | VIM GTK3 gui         | OK    | TODO        |
| VIM     | Shell | VIM cli              | OK    | TODO        |
| tmux    | Shell | terminal multiplexer | OK    | TODO        |

# [ooxmox](https://github.com/themix-project/oomox)
The GTK2/3 themes and the iconset have been generated using ooxmox.
You can install [ooxmox](https://github.com/themix-project/oomox) and it will automaticly pick up the current definitions and give you the possibility to change the theme to your liking.
