# tar -czf backup.tar.gz .xbmc/
sudo initctl stop xbmc
tar -xzf raspbmc.backup.tar.gz -C /home/pi/
# rm raspbmc.backup.tar.gz
sudo initctl start xbmc
