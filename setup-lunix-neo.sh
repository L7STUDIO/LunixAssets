#!/bin/bash

echo -e "\e[1;34m🔧 Устанавливаем темы, иконки, шрифты...\e[0m"
sudo apt update
sudo apt install -y arc-theme qogir-theme papirus-icon-theme \
fonts-inter fonts-roboto fonts-jetbrains-mono plank picom xfce4-whiskermenu-plugin python3-gi gir1.2-gtk-3.0

echo -e "\e[1;34m🧊 Настраиваем picom (эффекты, прозрачность, размытие)...\e[0m"
mkdir -p ~/.config
cat <<EOF > ~/.config/picom.conf
corner-radius = 12;
round-borders = 1;
blur-method = "dual_kawase";
blur-strength = 7;
fading = true;
fade-in-step = 0.03;
fade-out-step = 0.03;
fade-delta = 10;
shadow = true;
shadow-radius = 8;
shadow-opacity = 0.3;
shadow-offset-x = -7;
shadow-offset-y = -7;
opacity-rule = [
  "90:class_g = 'Thunar'",
  "85:class_g = 'xfce4-terminal'",
  "80:class_g = 'Firefox'"
];
backend = "glx";
vsync = true;
EOF

echo -e "\e[1;34m⚙️ Включаем picom и plank в автозапуск...\e[0m"
mkdir -p ~/.config/autostart

cat <<EOF > ~/.config/autostart/picom.desktop
[Desktop Entry]
Type=Application
Exec=picom --config ~/.config/picom.conf
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Picom Compositor
EOF

cat <<EOF > ~/.config/autostart/plank.desktop
[Desktop Entry]
Type=Application
Exec=plank
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Plank Dock
EOF

echo -e "\e[1;34m🚀 Добавляем лаунчер-заглушку...\e[0m"
cat <<EOF > ~/LunixLauncher.py
import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

class Launcher(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self, title="Lunix Launcher")
        self.set_default_size(500, 300)
        self.set_decorated(True)
        self.set_opacity(0.93)
        label = Gtk.Label(label="👋 Привет! Это лаунчер Lunix OS\n(ты можешь его улучшить)")
        self.add(label)

win = Launcher()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()
EOF

cat <<EOF > ~/.config/autostart/launcher.desktop
[Desktop Entry]
Type=Application
Exec=python3 ~/LunixLauncher.py
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Lunix Launcher
EOF

echo -e "\e[1;34m🎨 Готово! Lunix оформлена в современном стиле.\e[0m"
echo -e "\e[1;32m✅ Перезагрузи систему и наслаждайся новым стилем.\e[0m"