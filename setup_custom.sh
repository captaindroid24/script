#!/bin/bash

# Remove VAST AI Banner and message
sudo sed -i '/Banner/d' /etc/ssh/sshd_config
sudo rm -rf /etc/update-motd.d/*
sudo rm -f /etc/motd /var/run/motd.dynamic

# Disable tmux auto-launch and kill any existing sessions
touch ~/.no_auto_tmux
tmux kill-server

# Disable Ubuntu legal notices and other MOTD components
sudo rm -f /etc/legal /etc/issue /etc/issue.net

# Disable pam_motd from printing MOTD on login
sudo sed -i 's/session    optional     pam_motd.so/#session    optional     pam_motd.so/' /etc/pam.d/sshd

# Disable "Last Login" message
echo "PrintLastLog no" | sudo tee -a /etc/ssh/sshd_config

# Create your custom MOTD
cat << 'EOF' | sudo tee /etc/motd
Welcome to your custom instance!

  ____     ______  ____    _   _
 / ___|   |  ____||  _ \  | | | |
| |       | |  __ | |_) | | | | |
| |       | | |_ \|  __/  | | | |
| \____   | |__) | |      | |_| |
 \____/    _____/|_|       \___/

Have a productive session!
EOF

# Ensure custom MOTD is only printed once
sed -i '/cat \/etc\/motd/d' ~/.bashrc
echo "cat /etc/motd" >> ~/.bashrc

# Reload SSH service to apply changes without disconnecting
sudo systemctl reload ssh
