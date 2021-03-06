#!/bin/bash 
# sickbeard arch install
#=======================

# install sickbeard-git from the aur
yaourt -S sickbeard-git


# Optional dependencies for sickbeard-git
#    sabnzbd: NZB downloader [installed]
#    python2-notify: desktop notifications


# create the ~/.sickbeard directory
mkdir -p ~/.sickbeard


# copy the sickbeard config to ~/.sickbeard/
cp /opt/sickbeard/config.ini ~/.sickbeard/


# copy sickbeard.service to /etc/systemd/system/
cp /usr/lib/systemd/system/sickbeard.service /etc/systemd/system/


# edit  /etc/systemd/system/sickbeard.service
vim /etc/systemd/system/sickbeard.service


# replace /home/username/ with your username
# replace User=username with your username
#===========================================

[Unit]
Description=SickBeard Daemon
After=network.target

[Service]
User=username
Group=wheel
ExecStart=/usr/bin/env python2 /opt/sickbeard/SickBeard.py --quiet --config /home/username/.sickbeard/config.ini --datadir/home/username/.sickbeard

[Install]
WantedBy=multi-user.target

#=============================================


# rename autoProcessTV.cfg.sample to autoProcessTV.cfg
cd /opt/sickbeard/autoProcessTV/
sudo mv autoProcessTV.cfg.sample autoProcessTV.cfg

# create a scripts directory
mkdir -p ~/.sabnzbd.ini/scripts

# copy autoProcessTV directory to home sab directory
cp -r /opt/sickbeard/autoProcessTV/ ~/.sabnzbd.ini/scripts

