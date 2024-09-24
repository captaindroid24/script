#!/bin/bash

# Remove the Banner and Messages
sudo sed -i '/Banner/d' /etc/ssh/sshd_config
sudo rm /etc/banner  # Remove the  banner file

# Disable the tmux auto-launch and remove any reference to vast.ai in .bashrc
touch ~/.no_auto_tmux
tmux kill-server  # Kill any running tmux sessions

# Clean .bashrc to remove tmux and vast.ai messages
sudo sed -i '/Welcome to your vast.ai container/d' ~/.bashrc
sudo sed -i '/tmux attach-session/d' ~/.bashrc

# Ensure there are no other vast.ai references
sudo grep -r "vast.ai" /etc | sudo xargs rm -f  # Delete any file that contains vast.ai
sudo grep -r "vast.ai" ~/.bashrc | sudo xargs sed -i '/vast.ai/d'

# Run the find command to delete all files containing "vast"
find / -type f -iname "*vast*" -delete 2>/dev/null  # Deletes all files with 'vast' in their names

# Disable motd-news services and Ubuntu login messages
sudo chmod -x /etc/update-motd.d/*
sudo sed -i 's/session    optional     pam_motd.so/#session    optional     pam_motd.so/' /etc/pam.d/sshd

# Disable last login message
echo "PrintLastLog no" | sudo tee -a /etc/ssh/sshd_config

# Create custom MOTD (Message of the Day)
cat << 'EOF' | sudo tee /etc/motd
Welcome to your CloudGPU $cGPU instance!

  ____     ______  ____    _   _
 / ___|   |  ____||  _ \  | | | |
| |       | |  __ | |_) | | | | |
| |       | | |_ \|  __/  | | | |
| \____   | |__) | |      | |_| |
 \____/    _____/|_|       \___/

Have a productive session!

Your $cGPU Team
EOF

# Ensure the custom MOTD is shown once
sed -i '/cat \/etc\/motd/d' ~/.bashrc
echo "cat /etc/motd" >> ~/.bashrc

# Reload the SSH service to apply the changes
sudo systemctl reload ssh
