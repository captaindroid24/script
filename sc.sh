#!/bin/bash

# Entfernen aller vorhandenen Begrüßungsnachrichten
sudo rm -f /etc/motd
sudo rm -f /etc/update-motd.d/*
sudo rm -f /etc/legal
sudo rm -f /etc/issue
sudo rm -f /etc/issue.net

# Deaktivieren des Ubuntu News Services
sudo systemctl disable motd-news.timer
sudo systemctl stop motd-news.timer

# Erstellen einer neuen MOTD mit ASCII-Art
cat << EOF | sudo tee /etc/motd
Welcome to
  ____    ______  ____    _   _
 / ___|  |  ____||  _ \  | | | |
| |      | |  __ | |_) | | | | |
| |      | | |_ \|  __/  | | | |
| \____ _| |__) | |     | |_| |
 \____/(_)_____/|_|      \___/ 
EOF

# Deaktivieren der automatischen Tmux-Sitzung
touch ~/.no_auto_tmux

# Entfernen der VAST AI spezifischen Begrüßung aus der SSH-Konfiguration
sudo sed -i '/Banner/d' /etc/ssh/sshd_config
echo "Banner none" | sudo tee -a /etc/ssh/sshd_config

# Leeren der SSH-Banner-Datei, falls vorhanden
sudo touch /etc/ssh/sshd-banner
sudo truncate -s 0 /etc/ssh/sshd-banner

# Deaktivieren der LastLogin-Nachricht
echo "PrintLastLog no" | sudo tee -a /etc/ssh/sshd_config

# Aktivieren der MOTD-Anzeige in der SSH-Konfiguration
echo "PrintMotd yes" | sudo tee -a /etc/ssh/sshd_config

# Sicherstellen, dass die MOTD beim Login angezeigt wird
echo "cat /etc/motd" >> ~/.bashrc

# SSH-Dienst neu starten, um Änderungen zu übernehmen
sudo service ssh restart

# Entfernen der Ubuntu-Copyright-Nachricht
sudo sed -i 's/^session    optional     pam_motd.so/#session    optional     pam_motd.so/' /etc/pam.d/sshd
