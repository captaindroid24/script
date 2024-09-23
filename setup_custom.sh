#!/bin/bash

# Remove the VAST AI-specific banner by deleting it from the SSH configuration
sudo sed -i '/Banner/d' /etc/ssh/sshd_config

# Optionally, check and remove any existing banners, just to be thorough
sudo rm -f /etc/ssh/sshd-banner

# Disable VAST AI’s auto-tmux feature by creating the necessary file
touch ~/.no_auto_tmux

# Create a custom Message of the Day (MOTD) that will show up instead of VAST AI's
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

# Ensure that the MOTD is shown on login by appending it to .bashrc
if ! grep -q "cat /etc/motd" ~/.bashrc; then
    echo "cat /etc/motd" >> ~/.bashrc
fi

# Reload SSH configuration to apply changes without restarting the SSH service (to avoid disrupting connections)
sudo systemctl reload ssh

# Optional: Disable showing the "Last Login" message to clean up the login further
echo "PrintLastLog no" | sudo tee -a /etc/ssh/sshd_config

# Reload SSH again to apply the "Last Login" configuration
sudo systemctl reload ssh
