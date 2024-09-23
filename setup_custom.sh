#!/bin/bash

# 1. Remove the VAST AI-specific banner from the SSH configuration
sudo sed -i '/Banner/d' /etc/ssh/sshd_config

# 2. Remove any existing custom banner files
sudo rm -f /etc/ssh/sshd-banner

# 3. Ensure the VAST AI message is not in the current environment or MOTD
sudo rm -f /etc/motd.d/*vast*

# 4. Create a custom Message of the Day (MOTD) that will only display once
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

# 5. Ensure MOTD is shown on login and prevent it from displaying twice
if ! grep -q "cat /etc/motd" ~/.bashrc; then
    echo "cat /etc/motd" >> ~/.bashrc
fi

# 6. Remove redundant MOTD lines from .bashrc to avoid showing the message twice
sed -i '/cat \/etc\/motd/d' ~/.bashrc
echo "cat /etc/motd" >> ~/.bashrc

# 7. Reload SSH to apply changes without interrupting the connection
sudo systemctl reload ssh
