#!/bin/bash
MAINFLDR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "checking requirements"
command -v acpid >/dev/null 2>&1 || sudo pacman -S acpid

if [ ! -d "sound-topic/asus-e100h-4.12" ]; then
	if [ ! -f "asus-e100h-4.12.tar.gz" ];
		wget https://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git/snapshot/sound-topic/asus-e100h-4.12.tar.gz
	fi
	tar xvf asus-e100h-4.12.tar.gz
	cd sound-topic/asus-e100h-4.12/
	make clean && make mrproper
	cp config-e200ha sound-topic/asus-e100h-4.12/.config
	make xconfig
	make
else
	cd sound-topic/asus-e100h-4.12/
fi
sudo make modules_install
sudo cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-e200ha
sudo cp "$MAINFLDR/mkinitcpio-e200ha.conf" "/etc/mkinitcpio-e200ha.conf"
sudo cp "$MAINFLDR/e200ha.preset" "/etc/mkinitcpio.d/e200ha.preset"
if [ ! -f "/etc/acpi/handler.sh.backup" ];
	sudo cp "/etc/acpi/handler.sh" "/etc/acpi/handler.sh.backup"
fi
sudo cp "$MAINFLDR/acpi-handler-e200ha.sh" "/etc/acpi/handler.sh"
if [ ! -f "/etc/asound.conf.backup" ];
	sudo cp "/etc/asound.conf" "/etc/asound.conf.backup"
fi
sudo cp "$MAINFLDR/asound-e200ha.conf" "/etc/asound.conf"
if [ ! -d "/usr/share/alsa/ucm/chtcx2072x/" ]; then
	sudo cp -r "$MAINFLDR/chtcx2072x/" "/usr/share/alsa/ucm/"
fi
sudo mkinitcpio -p e200ha
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "you can now reboot (please boot e200ha linux kernel)"

