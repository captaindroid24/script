#!/bin/bash

# Remove the VAST AI-specific banner and tmux message
sudo sed -i '/Banner/d' /etc/ssh/sshd_config
sudo rm -f /etc/ssh/sshd-banner

# Create .no_auto_tmux to disable VAST AI's tmux auto-launch
touch ~/.no_auto_tmux

# Kill any existing tmux session
tmux kill-server

# Remove any lingering VAST AI tmux message from .bashrc
sudo sed -i '/Welcome to your vast.ai container/d' ~/.bashrc

# Ensure MOTD is shown on login and prevent it from displaying twice
sed -i '/cat \/etc\/motd/d' ~/.bashrc
echo "cat /etc/motd" >> ~/.bashrc

# Create a custom MOTD (Message of the Day)
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

# Reload SSH to apply changes without interrupting the connection
sudo systemctl reload ssh
