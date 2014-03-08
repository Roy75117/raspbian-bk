#! /bin/sh
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


# Install better Transmission Web Control (a custom web UI)
#https://code.google.com/p/transmission-control/
rootFolder=""
webFolder=""
orgindex="index.original.html"
index="index.html"
tmpFolder="/tmp/tr-web-control/"
packname="transmission-control-full.tar.gz"
host="http://transmission-control.googlecode.com/svn/resouces/"
donwloadurl="$host$packname"
if [ ! -d "$tmpFolder" ]; then
	cd /tmp
	mkdir tr-web-control
fi
cd "$tmpFolder"
wget "$host""checkfolders.lst"
# 找出web ui 目录
folderIsExist=0
for i in `/bin/cat "$tmpFolder"checkfolders.lst`
do
	if [ -d "$i""web/" ]; then
		rootFolder="$i"
		webFolder="$i""web/"
		folderIsExist=1
		break
	fi
done
# 如果目录存在，则进行下载和更新动作
if [ $folderIsExist = 1 ]; then
	echo "Transmission Web Control Is Downloading..."
	wget "$donwloadurl"
	echo "Installing..."
	tar -xzf "$packname"
	rm "$packname"
	# 如果之前没有安装过，则先将原系统的文件改为
	if [ ! -f "$webFolder$orgindex" -a -f "$webFolder$index" ]; then
		sudo mv "$webFolder$index" "$webFolder$orgindex"
	fi
	# 复制文件到
	sudo cp -r web "$rootFolder"
	echo "Done."
else
	echo "##############################################"
	echo "#"
	echo "# ERROR : Transmisson WEB UI Folder is missing."
	echo "#"
	echo "##############################################"
fi
rm -rf "$tmpFolder"
