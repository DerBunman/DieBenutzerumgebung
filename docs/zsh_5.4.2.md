# Ubuntu 18.04 / zsh 5.4.2


There is an bug that prevents the curses setup interface from working like it should.

Until this bug is fixed you need to update your zsh installation to at least zsh >=5.5.

## Your options
Please note, that the described options will work on Ubuntu 18.04 and Linux Mint 19.1.

### Option 1: Install zsh and zsh-common from some backports source.

#### Option 1a: My own Ubuntu 18.04 (bionic) source:
As of writing this repository only contained zsh and zsh-common,
but there may appear some more packages.

You can find it [here](https://github.com/DerBunman/bundebs). (follow instructions from README)

#### Option 1b: Just download and install the .deb files by hand.
* Con: No automatic updates when vulnerabilities emerge.
* Pro: No automatic updates and no risk I break anything or add packages you don't want.

Download [here](https://github.com/DerBunman/bundebs/tree/master/pool/main/z/zsh).

### Option 2: Just build it yourself.
It is easy, when you just use the dsc file from Ubuntu 19.04 (disco)
as described [here](https://gist.github.com/DerBunman/88f85eb63f0b71f8a5271c2081a3e76b).

### Option 3: Fix the bzcurses bugs which occur in zsh versions <5.5
I would prefer this option.
