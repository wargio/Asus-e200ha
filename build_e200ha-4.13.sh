#!/bin/bash
MAINFLDR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
KVERSION="4.13"
KFOLDER="sound-topic/asus-e100h-$KVERSION/"

echo ""
echo "MAINFLDR: $MAINFLDR"
echo "KVERSION: $KVERSION"
echo "KFOLDER:  $KFOLDER"
echo ""

trap ctrl_c INT

function ctrl_c() {
	exit 1
}

function sysmodify() {
	FILE="$2"
	NEWFILE="$1"
	if [ ! -f "$FILE.backup" ]; then
		sudo cp "$FILE" "$FILE.backup"
	fi
	sudo cp "$NEWFILE" "$FILE"
}

echo "Checking requirements"
command -v acpid >/dev/null 2>&1 || sudo pacman -S acpid
command -v pulseaudio >/dev/null 2>&1 || sudo pacman -S pulseaudio pulseaudio-alsa

if [ ! -d "$KFOLDER" ]; then
	if [ ! -f "asus-e100h-$KVERSION.tar.gz" ]; then
		echo "Downloading Linux Kernel $KVERSION"
		wget "https://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git/snapshot/$KFOLDER.tar.gz"
	fi
	echo "Unpacking Linux Kernel $KVERSION"
	tar xf "asus-e100h-$KVERSION.tar.gz"
	cd "$KFOLDER"
	echo "Preparing folder"
	make clean && make mrproper
	cp "$MAINFLDR/config-e200ha" .config
	make xconfig
	make
else
	cd "$KFOLDER"
fi
echo "Installing modules"
sudo make modules_install
echo "Preparing image"
sudo cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-e200ha
sudo cp "$MAINFLDR/mkinitcpio-e200ha.conf" "/etc/mkinitcpio-e200ha.conf"
sudo cp "$MAINFLDR/e200ha.preset" "/etc/mkinitcpio.d/e200ha.preset"
echo "Patching handlers"
sysmodify "$MAINFLDR/acpi-handler-e200ha.sh" "/etc/acpi/handler.sh"
echo "Patching audio"
sysmodify "$MAINFLDR/pa-daemon.conf" "/etc/pulse/daemon.conf"
if [ ! -d "/usr/share/alsa/ucm/chtcx2072x/" ]; then
	sudo cp -r "$MAINFLDR/chtcx2072x/" "/usr/share/alsa/ucm/"
fi
echo "Building image"
sudo mkinitcpio -p e200ha
echo "Updating grub"
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "you can now reboot (please boot e200ha linux kernel)"
