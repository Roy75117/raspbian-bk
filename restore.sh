mkdir /home/pi/media
mkdir /home/pi/media/downloads
mkdir /home/pi/bin
chmod 777 /home/pi/media
chmod 777 /home/pi/media/downloads
cp ./xbmc.restart /home/pi/bin/xbmc.restart
chmod 755 /home/pi/bin/xbmc.restart
sudo cat ./bashrc > /home/pi/.bashrc
sudo cat ./profile > /home/pi/.profile
# sudo cp ./vimrc ~/.vimrc
# sudo cp ./vimrc /root/
sudo cat ./smb.conf > /etc/samba/smb.conf
sudo cat ./rc.local > /etc/rc.local
sudo cp ./free_m /etc/cron.hourly/free_m
sudo chmod 755 /etc/cron.hourly/free_m
sudo cat ./xinet.sh > /scripts/xinet.sh

ln -s /run/shm/ /home/pi/RAMDISK

# sudo passwd pi

wget --no-check-certificate http://cl.ly/1t2t2E1Z410B/download/raspbmc.backup.gz
sh ./raspbmc.backup.sh

sudo apt-get update
sudo apt-get -y install dpkg
sudo apt-get -y install transmission-daemon lighttpd htop bzip2
sudo apt-get autoclean
sudo rm -rf /var/cache/apt/archives/*.deb

sudo /etc/init.d/transmission-daemon stop
sudo cat ./transmission-daemon > /etc/init.d/transmission-daemon
sudo cat ./setting.json > /etc/transmission-daemon/settings.json

sudo cat ./lighttpd.conf > /etc/lighttpd/lighttpd.conf

