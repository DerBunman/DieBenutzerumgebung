# Variables
This is an overview of the variables which can be set in the inventory to customize hosts.

## Example Inventory
There is an complex example with multiple host definitions: [inventories/example.yml](../inventories/example.yml)

## Common / System
The variables defined in this section are either for the common or system rule.
The desktop role depends on both system and common.

### common__additional_packages
Allows you to define a list of packages that will be installed by the common role.
```yaml
common__additional_packages:
  - lolcat
  - mc
```

### ignore_packages
This flag defines whether missing default packages should be ignored.
This can be helpful when there are some packages missing and we also have no root access.
```yaml
ignore_packages: False
```

### ifrename
Creates a udev rule for each mac/name pair so that the interface will be named as defined.
```yaml
ifrename:
  - mac: "60:67:20:5e:05:38"
    name: "wlan0"
  - mac: "3c:97:0e:2e:cd:b8"
    name: "eth0"
```

### users
These users will have the DieBenutzerumgebung setup.
For now it is mandatory to add the user you have set as ansible user to this list.
```yaml
users:
  - name: "ichi"
    comment: "numero ichi"
    home: /home/ichi
    group: users
    groups: adm,sudo
    shell: /bin/zsh
    # usermod defines whether the user may be modified if you set
    # this to false, ensure that the login shell is set to zsh.
    usermod: True
    # the following ssh pubkeys will be added to this user.
    ssh_keys: |
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMjCDwwHvhp3Gk/dYKWMxfn5aekc22+NvuekydZja2d localhorst
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFxrqRD0ab7ljvUjAYVqLH211dsUssr8ZGZ/N3riZOx schleppi
```

### ssh_keys
```yaml
```

### env_BROWSER
These will be set in the environment as $BROWSER
```yaml
env_BROWSER: firefox
```

### env_EDITOR
These will be set in the environment as $EDITOR
```yaml
env_EDITOR: vim
```

## Desktop
The following variables will only be used by the desktop role. So there is no need to define them for shell only (common) hosts.

### desktop__additional_packages
Allows you to define a list of packages that will be installed by the desktop role.
```yaml
desktop__additional_packages:
  - shotcut
  - virt-manager
```

### desktop__setxkbmap_script
The following lines will be written to ~/bin/autostart/always/setxkbmap_script.
While it is only semantics, you should only put keyboard commands here.
```yaml
desktop__setxkbmap_script: |
  setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl
  setxkbmap -option caps:none
```

## Desktop / Polybar
### polybar__email_indicator_url
In addition to the url defined here, you have to create a ~/.netrc file in the following format:
```conf
machine your-email-server.com
 login my@example.com
 password s3cret
```
```yaml
polybar__email_indicator_url: imaps://your-email-server.com/INBOX
```

### polybar__modules_{left,center,right}
This defines which modules are loaded into the polybar.
```yaml
polybar__modules_left: "xwindow"
polybar__modules_center: ""
polybar__modules_right: "docker email eth wlan memory cpu system-cpu-frequency temperature system-cpu-loadavg filesystem battery xkeyboard pulseaudio date"
```

### polybar__temperature_thermal_zone:
Select the thermal zone for acpi temperature display.
```yaml
polybar__temperature_thermal_zone: 0
```
### polybar__battery_{adapter,device,full_at}
Battery status settings for laptops.
```yaml
polybar__battery_adapter: "AC"
polybar__battery_device: "BAT0"
polybar__battery_full_at: 95
```

### polybar__bottom
This flag defines whether the bar should be at the bottom or the top.
```yaml
polybar__bottom: false
```

### polybar__{eth,wifi}_interface
Defines which devices the polybar modules try to display.
```yaml
polybar__wifi_interface: "wlan0"
polybar__eth_interface: "eth0"
```

## Desktop / Bspwm
### bspwm__monitor
Note for multi-monitor setups:
This example configures ten desktops on one monitor like this:
```yaml
bspwm__monitor: |
  bspc monitor -d 1 2 3 4 5 6 7 8 9 0
```
You will need to change this line and add one for each monitor, similar to this:
```yaml
bspwm__monitor: |
  bspc monitor DVI-I-1 -d 1 2 3 4
  bspc monitor DVI-I-2 -d 5 6 7
  bspc monitor DP-1 -d 8 9 0
```
You can use xrandr -q or bspc query -M to find the monitor names.
The total number of desktops were maintained at ten in the above example.
This is so that each desktop can still be addressed with super + {1-9,0} in the sxhkdrc.

### bspwm__bspwmrc_additional_scripts
Additional commands that should be run on bspwm startup.
```yaml
bspwm__bspwmrc_additional_scripts: |
  # disable mouse accelleration
  xset m 0 0 &
```
