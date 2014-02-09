mkdir /home/pi/media
mkdir /home/pi/media/downloads
mkdir /home/pi/bin
mkdir /home/pi/.aria2
chmod 777 /home/pi/media
chmod 777 /home/pi/media/downloads

cp ./xbmc.restart /home/pi/bin/xbmc.restart
chmod 755 /home/pi/bin/xbmc.restart

cp ./bashrc /home/pi/.bashrc
cp ./profile /home/pi/.profile
cp aria2.conf /home/pi/.aria2/aria2.conf

# sudo cp ./vimrc ~/.vimrc
# sudo cp ./vimrc /root/

sudo cp ./smb.conf /etc/samba/smb.conf
sudo chmod 744 /etc/samba/smb.conf

sudo cp ./rc.local /etc/rc.local
sudo chmod 755 /etc/rc.local

sudo cp ./free_m /etc/cron.hourly/free_m
sudo chmod 755 /etc/cron.hourly/free_m

sudo cp ./xinet.sh /scripts/xinet.sh
sudo chmod 755 /scripts/xinet.sh

ln -s /run/shm/ /home/pi/RAMDISK

# sudo passwd pi

wget --no-check-certificate http://cl.ly/1t2t2E1Z410B/download/raspbmc.backup.gz
sudo initctl stop xbmc
tar -xzf raspbmc.backup.gz -C /home/pi/
# rm raspbmc.backup.tar.gz
sudo initctl start xbmc
# sh ./raspbmc.backup.sh

sudo apt-get update
sudo apt-get -y install dpkg
sudo apt-get -y install transmission-daemon lighttpd htop bzip2 aria2
sudo apt-get autoclean
sudo rm -rf /var/cache/apt/archives/*.deb

sudo /etc/init.d/transmission-daemon stop
sudo cp ./transmission-daemon /etc/init.d/transmission-daemon
sudo chmod 755 /etc/init.d/transmission-daemon
sudo cp ./setting.json /etc/transmission-daemon/setting.json

sudo cp ./lighttpd.conf /etc/lighttpd/lighttpd.conf
sudo chmod 744 /etc/lighttpd/lighttpd.conf
