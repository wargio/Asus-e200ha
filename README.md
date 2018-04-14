Asus E200HA Custom Kernel for Arch Linux
========================================

clone this repo and run as user (not root) `build_e200ha-4.1x.sh`

* Linux 4.12 `build_e200ha-4.12.sh`
* Linux 4.13 `build_e200ha-4.13.sh`

## Kernel Config

* Leave the already selected options as they are.
* Enable `EXT3` and `EXT4` support under `filesystems` if needed (suggested).

## FAQ

* Audio not working: install `pavucontrol` and check if the output is HDMI or the sound card.

