sudo apt-get update
sudo apt-get -y install rsync
sudo service xbmc stop
sudo nano /etc/init.d/aaxbmc
#-------------------
#  create shell script
#-------------------
sudo chmod +x /etc/init.d/aaxbmc
cd /etc/rcS.d
sudo ln -s ../init.d/aaxbmc S50aaxbmc
cd /etc/rc1.d
sudo ln -s ../init.d/aaxbmc K10aaxbmc
cd /etc/rc0.d
sudo ln -s ../init.d/aaxbmc K01aaxbmc

cp -r /home/pi/.xbmc /run/shm
#sudo ln -s /run/shm/.xbmc /home/pi/.xbmc
sudo mount --bind /run/shm/.xbmc /home/pi/.xbmc
#sudo mount -o bind /run/shm/.xbmc /home/pi/.xbmc
mkdir /home/pi/.xbmc-backup
sudo service xbmc start


#------------------------aaxbmc-------------------------------#
#! /bin/sh
# /etc/init.d/aaxbmc
#

case "$1" in
  start)
rsync -aog --delete-after --delay-updates /home/pi/.xbmc-backup/.xbmc /run/shm/ &> /dev/null
sudo mount --bind /run/shm/.xbmc /home/pi/.xbmc
#sudo mount -o bind /run/shm/.xbmc /home/pi/.xbmc
    ;;
  stop)
rsync -aog --delete-after --delay-updates /run/shm/.xbmc /home/pi/.xbmc-backup &> /dev/null
sync
    ;;
  *)
    echo "Usage: /etc/init.d/aaxbmc {start|stop}"
    exit 1
    ;;
esac

exit 0
#-------------------------------------------------------------#
