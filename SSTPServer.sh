#!/bin/bash

# Update package list
sudo apt-get update

# Install required packages
# sudo apt-get install build-essential libssl-dev libwrap0-dev libpam0g-dev libreadline-dev libnl-route-3-dev -y
# Download SoftEther VPN server
# wget "https://www.softether-download.com/files/softether/v4.41-9787-rtm-2023.03.14-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.41-9787-rtm-2023.03.14-linux-x64-64bit.tar.gz"
# Extract and install SoftEther VPN server
# tar xzvf softether-vpnserver-v4.41-9787-rtm-2023.03.14-linux-x64-64bit.tar.gz
# cd vpnserver
# sudo make

sudo apt -y install git cmake gcc g++ make pkgconf libncurses5-dev libssl-dev libsodium-dev libreadline-dev zlib1g-dev
git clone https://github.com/SoftEtherVPN/SoftEtherVPN.git
cd SoftEtherVPN
git submodule init && git submodule update
./configure
make -C build
make -C build install

# Set permissions on VPN server files
sudo chmod 600 *
sudo chmod 700 vpnserver
sudo chmod 700 vpncmd
sudo chcon -Rv -u system_u -t bin_t vpnserver

# Start VPN server
sudo ./vpnserver start

# Configure SSTP VPN

sudo ./vpncmd localhost /SERVER /CMD:ServerPasswordSet test
#sudo ./vpncmd localhost /PASSWORD:test /SERVER /CMD:ListenerList
#sudo ./vpncmd localhost /PASSWORD:test /SERVER /CMD:ListenerDelete 992
#sudo ./vpncmd localhost /PASSWORD:test /SERVER /CMD:ListenerDelete 1194
#sudo ./vpncmd localhost /PASSWORD:test /SERVER /CMD:ListenerDelete 5555
#sudo ./vpncmd localhost /PASSWORD:test /SERVER /CMD:OpenVpnEnable no /PORTS:1194
sudo ./vpncmd localhost /PASSWORD:test /SERVER /CMD:SstpGet
sudo ./vpncmd localhost /PASSWORD:test /SERVER /CMD:SstpEnable yes
sudo ./vpncmd localhost /PASSWORD:test /SERVER /CMD:ServerCertRegenerate 124.220.179.147
sudo ./vpncmd localhost /PASSWORD:test /SERVER /CMD:ServerCertGet certificate.cer

sudo ./vpncmd localhost /PASSWORD:test /SERVER /CMD:HubCreate SSTP
sudo ./vpncmd localhost /PASSWORD:test /SERVER /CMD:HUB SSTP
#sudo ./vpncmd localhost /PASSWORD:test /SERVER /CMD:SetHubPassword test
sudo ./vpncmd localhost /PASSWORD:test /SERVER /HUB:SSTP /CMD:UserCreate test /GROUP:none /REALNAME:"test" /NOTE:"test"
sudo ./vpncmd localhost /PASSWORD:test /SERVER /HUB:SSTP /CMD:UserPasswordSet test /PASSWORD:test
sudo ./vpncmd localhost /PASSWORD:test /SERVER /HUB:SSTP /CMD:SecureNatEnable

sudo ./vpncmd localhost /PASSWORD:test /SERVER /HUB:SSTP /CMD:StatusGet

echo "SSTP VPN server installation and configuration complete."
