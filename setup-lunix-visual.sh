#!/bin/bash

echo -e "\e[1;36m🌌 Установка оформления Lunix OS...\e[0m"

# Папка для хранения ассетов
mkdir -p ~/Pictures/LunixAssets
cd ~/Pictures/LunixAssets

# СКАЧИВАЕМ ЛОГО и ОБОИ с GitHub
wget -O logo.png https://raw.githubusercontent.com/L7STUDIO/LunixAssets/refs/heads/main/logo.png
wget -O wallpaper.png https://raw.githubusercontent.com/L7STUDIO/LunixAssets/refs/heads/main/walltwo.png

# СТАВИМ ОБОИ (только для XFCE)
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s ~/Pictures/LunixAssets/wallpaper.png

# ЛОГО И ФОН ДЛЯ ВХОДА (LightDM)
sudo sed -i "/^background=/c\background=$(echo /home/$USER/Pictures/LunixAssets/wallpaper.png)" /etc/lightdm/lightdm-gtk-greeter.conf
sudo sed -i "/^logo=/c\logo=$(echo /home/$USER/Pictures/LunixAssets/logo.png)" /etc/lightdm/lightdm-gtk-greeter.conf

# СОЗДАЁМ PLYMOUTH-ТЕМУ
sudo mkdir -p /usr/share/plymouth/themes/lunix
sudo cp logo.png /usr/share/plymouth/themes/lunix/logo.png

# .plymouth
cat <<EOF | sudo tee /usr/share/plymouth/themes/lunix/lunix.plymouth > /dev/null
[Plymouth Theme]
Name=Lunix
Description=Custom Splash for Lunix OS
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/lunix
ScriptFile=/usr/share/plymouth/themes/lunix/lunix.script
EOF

# .script
cat <<EOF | sudo tee /usr/share/plymouth/themes/lunix/lunix.script > /dev/null
screen_width = Window.GetWidth();
screen_height = Window.GetHeight();
image = Image("logo.png");
image_width = Image.GetWidth(image);
image_height = Image.GetHeight(image);
x = (screen_width - image_width) / 2;
y = (screen_height - image_height) / 2;
Window.SetBackgroundTopColor(0, 0, 0);
Window.SetBackgroundBottomColor(0, 0, 0);
Window.DrawImage(image, x, y, 255);
EOF

# ПРИМЕНЯЕМ ТЕМУ ЗАГРУЗКИ
sudo plymouth-set-default-theme lunix
sudo update-initramfs -u

# ПРИВЕТСТВИЕ В ТЕРМИНАЛЕ
echo 'echo -e "\e[1;35mДобро пожаловать в Lunix OS, $USER!\e[0m"' >> ~/.bashrc

echo -e "\e[1;32m✅ Lunix OS оформлена и готова! Перезагрузи систему командой: sudo reboot\e[0m"