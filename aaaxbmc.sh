sudo apt-get update
sudo apt-get -y install rsync
sudo service xbmc stop
sudo nano /etc/init.d/aaxbmc
#-------------------
# create aaxbmc shell script
#-------------------
sudo chmod +x /etc/init.d/aaxbmc
#cd /etc/rcS.d
#sudo ln -s ../init.d/aaxbmc S50aaxbmc
#cd /etc/rc1.d
#sudo ln -s ../init.d/aaxbmc K10aaxbmc
#cd /etc/rc0.d
#sudo ln -s ../init.d/aaxbmc K03aaxbmc
#cd /etc/rc6.d
#sudo ln -s ../init.d/aaxbmc K03aaxbmc


cp -r /home/pi/.xbmc /tmp
#sudo ln -s /run/shm/.xbmc /home/pi/.xbmc
sudo mount --bind /tmp/.xbmc /home/pi/.xbmc
#sudo mount -o bind /run/shm/.xbmc /home/pi/.xbmc
mkdir /home/pi/.xbmc-backup
sudo service xbmc start


#------------------------aaxbmc-------------------------------#
#! /bin/sh
# /etc/init.d/aaxbmc
#

case "$1" in
  start)
	rsync -aog --delete-after --delay-updates /home/pi/.kodi-backup/.kodi /tmp/ > /dev/null
	sudo mount --bind /tmp/.kodi /home/pi/.kodi
    ;;
  stop)
	rsync -aog --delete-after --delay-updates /tmp/.kodi /home/pi/.kodi-backup > /dev/null
	sync
	sleep 2
    ;;
  *)
    echo "Usage: /etc/init.d/aaxbmc {start|stop}"
    exit 1
    ;;
esac

exit 0
#-------------------------------------------------------------#

#----/etc/init/mountall.conf------#
if [ $(mount | grep "tmpfs on /tmp" | wc -l) -gt 0 ];then
   if [ $(mount | grep "home/pi/.xbmc type none (rw,bind)" | wc -l) -lt 1 ];then
      /etc/init.d/aaxbmc start
   fi
fi
#-------------------------------------------------------------#

#---------------------/etc/init.d/sendsigs--------------------#
/etc/init.d/aaxbmc stop
#-------------------------------------------------------------#

#---------------------/etc/fstab------------------------------#
proc /proc proc defaults 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620 0 0
/dev/mmcblk0p1 /boot vfat defaults 0 0
/dev/mmcblk0p2 / ext4 defaults,noatime 0 0
tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0
#--------------------------------------------------------------#

#---------------------/etc/default/rcS--------------------#
# mount /tmp on tmpfs
RAMTMP=yes
#-------------------------------------------------------------#
