#!/bin/bash

# Remove the Banner and Messages
sudo sed -i '/Banner/d' /etc/ssh/sshd_config
sudo rm /etc/banner  # Remove the VAST AI banner file

# Disable the tmux auto-launch and remove any reference to VAST AI in .bashrc
touch ~/.no_auto_tmux
tmux kill-server  # Kill any running tmux sessions

# Clean .bashrc to remove tmux and VAST AI messages
sudo sed -i '/Welcome to your vast.ai container/d' ~/.bashrc
sudo sed -i '/tmux attach-session/d' ~/.bashrc

# Fix: Check for /root/.vast_containerlabel and remove any reference to it
# Search for any reference to .vast_containerlabel in common files
sudo sed -i '/vast_containerlabel/d' /etc/profile
sudo sed -i '/vast_containerlabel/d' /etc/bash.bashrc
sudo sed -i '/vast_containerlabel/d' ~/.bashrc

# Optionally: Create an empty file to prevent the "No such file or directory" error
sudo touch /root/.vast_containerlabel

# Disable motd-news services and Ubuntu login messages
sudo chmod -x /etc/update-motd.d/*
sudo sed -i 's/session    optional     pam_motd.so/#session    optional     pam_motd.so/' /etc/pam.d/sshd

# Disable last login message
echo "PrintLastLog no" | sudo tee -a /etc/ssh/sshd_config

# Create custom MOTD (Message of the Day)
cat << 'EOF' | sudo tee /etc/motd
Welcome to your CloudGPU instance!

  ____     ______  ____    _   _
 / ___|   |  ____||  _ \  | | | |
| |       | |  __ | |_) | | | | |
| |       | | |_ \|  __/  | | | |
| \____   | |__) | |      | |_| |
 \____/    _____/|_|       \___/

Have a productive session!
EOF

# Ensure the custom MOTD is shown once
sed -i '/cat \/etc\/motd/d' ~/.bashrc
echo "cat /etc/motd" >> ~/.bashrc

# Reload the SSH service to apply the changes
sudo systemctl reload ssh
