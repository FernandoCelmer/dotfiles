#!/bin/bash

sudo apt clean
sudo apt autoclean
sudo apt autoremove
sudo apt-get autoremove
sudo apt-get autoclean
sudo apt-get clean
journalctl --disk-usage
sudo journalctl --vacuum-time=7d
sudo du -sh /var/cache/apt
sudo du -sh ~/.cache/thumbnails
sudo rm -rf ~/.cache/thumbnails/*
sudo du -h /var/cache/apt/archives

