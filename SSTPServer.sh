#!/bin/bash

# Update package list
sudo apt-get update

# Install required packages
sudo apt-get install build-essential libssl-dev libwrap0-dev libpam0g-dev libreadline-dev libnl-route-3-dev -y

# Download SoftEther VPN server
wget https://ghproxy.minlearn.org/api/https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.38-9760-rtm/softether-vpnserver-v4.38-9760-rtm-2021.08.17-linux-x64-64bit.tar.gz

# Extract and install SoftEther VPN server
tar xzvf softether-vpnserver-v4.38-9760-rtm-2021.08.17-linux-x64-64bit.tar.gz
cd vpnserver
sudo make

# Set permissions on VPN server files
sudo chmod 600 *
sudo chmod 700 vpnserver
sudo chmod 700 vpncmd

# Start VPN server
sudo ./vpnserver start

# Configure SSTP VPN
sudo ./vpncmd localhost /SERVER /CMD:EnableSSTP
sudo ./vpncmd localhost /SERVER /PASSWORD:serverpassword /CMD:SstpEnable yes
sudo ./vpncmd localhost /SERVER /PASSWORD:serverpassword /CMD:SstpSetLog /INFORMATION:YES

echo "SSTP VPN server installation and configuration complete."
