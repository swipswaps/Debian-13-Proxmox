#!/bin/bash

# A script to harden a fresh Debian 13 installation.
# Run this inside the VM with 'sudo bash harden.sh'.

set -e

# --- Update and Install Dependencies ---
echo "Updating packages and installing security tools..."
sudo apt-get update
sudo apt-get install -y ufw fail2ban unattended-upgrades

# --- Configure Unattended Upgrades ---
echo "Configuring unattended upgrades..."
sudo dpkg-reconfigure -plow unattended-upgrades

# --- Configure UFW Firewall ---
echo "Configuring UFW firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh  # Port 22
sudo ufw logging high
sudo ufw --force enable
sudo ufw status verbose

# --- Configure SSH Hardening ---
echo "Hardening SSH configuration..."
SSH_CONFIG_FILE="/etc/ssh/sshd_config"
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' $SSH_CONFIG_FILE
sudo sed -i 's/^UsePAM yes/UsePAM no/' $SSH_CONFIG_FILE
sudo sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' $SSH_CONFIG_FILE
sudo systemctl restart sshd

# --- Final Cleanup ---
echo "Cleaning up package cache..."
sudo apt-get autoclean
sudo apt-get autoremove -y

echo "System hardening complete. Remember to reboot the VM if required."