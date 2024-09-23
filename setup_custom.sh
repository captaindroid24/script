#!/bin/bash

# Remove VAST AI-specific banners and welcome messages
sudo sed -i '/Banner/d' /etc/ssh/sshd_config

# Create a custom MOTD (Message of the Day)
cat << 'EOF' | sudo tee /etc/motd

  ____     ______  ____    _   _
 / ___|   |  ____||  _ \  | | | |
| |       | |  __ | |_) | | | | |
| |       | | |_ \|  __/  | | | |
| \____   | |__) | |      | |_| |
 \____/    _____/|_|       \___/ 

Have a productive session!
EOF

# Ensure MOTD is shown on login and disable VAST's tmux auto-launch
touch ~/.no_auto_tmux
echo "cat /etc/motd" >> ~/.bashrc

# Reload the SSH configuration to apply changes
sudo systemctl reload ssh

# Optional: Additional setup commands can go here
