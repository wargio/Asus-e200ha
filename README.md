Asus E200HA Custom Kernel for Arch Linux
========================================

# Looks like the latest 5.x kernels now supports the audio of this machine.

Big thanks to all the internet community

- Linux Kernel 5.0 patches from https://github.com/heikomat/linux (thanks dude!)

clone this repo and run as user (not root) `build_e200ha-5.0.sh`

* Linux 5.0  `build_e200ha-5.0.sh`
* Linux 4.13 `build_e200ha-4.13.sh`
* Linux 4.12 `build_e200ha-4.12.sh`

## Kernel Config

* Leave the already selected options as they are.
* Enable `EXT3` and `EXT4` support under `filesystems` if needed (suggested).

## FAQ

* Audio not working: install `pavucontrol` and check if the output is HDMI or the sound card.
* device `tun` is missing: enable tun device via `make xconfig`

