mkdir ~/media
mkdir ~/media/downloads
mkdir ~/bin
chmod 777 ~/media
chmod 777 ~/downloads
cp ./xbmc.restart ~/bin/xbmc.restart
chmod 755 ~/bin/xbmc.restart
sudo cat ./bashrc > ~/.bashrc
sudo cat ./profile > ~/.profile
# sudo cp ./vimrc ~/.vimrc
# sudo cp ./vimrc /root/
sudo cat ./smb.conf > /etc/samba/smb.conf
sudo cat ./rc.local > /rc.local
sudo cp ./free_m /etc/cron.hourly/free_m
sudo chmod 755 /etc/cron.hourly/free_m

ln -s /run/shm/ RAMDISK

# sudo passwd pi

wget http://cl.ly/1t2t2E1Z410B/download/raspbmc.backup.gz
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

