#! /bin/sh
mkdir /home/pi/media
mkdir /home/pi/media/downloads
mkdir /home/pi/bin
mkdir /home/pi/.aria2
chmod 777 /home/pi/media
chmod 777 /home/pi/media/downloads
cp nanorc ~/.nanorc

#cp ./xbmc.restart /home/pi/bin/xbmc.restart
#chmod 755 /home/pi/bin/xbmc.restart

cp ./bashrc /home/pi/.bashrc
cp ./profile /home/pi/.profile
cp aria2.conf /home/pi/.aria2/aria2.conf

# sudo cp ./vimrc ~/.vimrc
# sudo cp ./vimrc /root/

sudo cp ./smb.conf /etc/samba/smb.conf
sudo chmod 744 /etc/samba/smb.conf

sudo cp ./rc.local /etc/rc.local
sudo chmod +x /etc/rc.local

sudo cp ./free_m /etc/cron.hourly/free_m
sudo chmod +x /etc/cron.hourly/free_m

#only for raspberry pi 1 B
sudo cp ./wifi_reconnect /etc/cron.hourly/wifi_reconnect
sudo chmod +x /etc/cron.hourly/wifi_reconnect

sudo cp ./free_space /etc/cron.weekly/free_space
sudo chmod +x /etc/cron.weekly/free_space

#sudo cp ./xinet.sh /scripts/xinet.sh
#sudo chmod 755 /scripts/xinet.sh

ln -s /run/shm/ /home/pi/RAMDISK

# sudo passwd pi

#wget --no-check-certificate http://cl.ly/1t2t2E1Z410B/download/raspbmc.backup.gz
#sudo initctl stop xbmc
#tar -xzf raspbmc.backup.gz -C /home/pi/
# rm raspbmc.backup.tar.gz
#sudo initctl start xbmc
# sh ./raspbmc.backup.sh

sudo apt-get update
sudo apt-get -y install dpkg
sudo apt-get -y install transmission-daemon lighttpd htop bzip2 aria2 php-cgi 
#raspberrypi 1 b only
sudo apt-get -y install wicd-curses w3m 
sudo apt-get autoclean
#sudo rm -rf /var/cache/apt/archives/*.deb

sudo /etc/init.d/transmission-daemon stop
sudo cp ./transmission-daemon /etc/init.d/transmission-daemon
sudo chmod 755 /etc/init.d/transmission-daemon
sudo cp ./setting.json /etc/transmission-daemon/setting.json

sudo cp ./lighttpd.conf /etc/lighttpd/lighttpd.conf
sudo chmod 744 /etc/lighttpd/lighttpd.conf
sudo lighty-enable-mod fastcgi
sudo lighty-enable-mod fastcgi-php
sudo service lighttpd force-reload

#install rpimonitor
#https://feriman.com/install-and-customize-rpi-monitor/
sudo apt-get -y install dirmngr
sudo wget http://goo.gl/vewCLL -O /etc/apt/sources.list.d/rpimonitor.list
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 2C0D3C0F
sudo apt-get update
sudo apt-get install rpimonitor
sleep 3
sudo /etc/init.d/rpimonitor update
sudo cp ./rpimonitor.service /etc/systemd/system/rpimonitor.service
sudo systemctl daemon-reload
sudo systemctl enable rpimonitor
sudo cp /etc/rpimonitor/template/raspbian.conf /etc/rpimonitor/template/raspbian.conf.bk
sudo cp ./data.conf /etc/rpimonitor/template/raspbian.conf
sudo cp /etc/rpimonitor/template/services.conf /etc/rpimonitor/template/services.conf.bk
sudo cp ./service.conf /etc/rpimonitor/template/service.conf
# for kernel > 4.9
# https://github.com/XavierBerger/RPi-Monitor/issues/273
sudo cp /etc/rpimonitor/template/version.conf /etc/rpimonitor/template/version.conf.bk
sudo cp ./version.conf /etc/rpimonitor/template/version.conf
##
sync
sudo systemctl restart rpimonitor
# if apt warnning msg keep showing up
# https://github.com/XavierBerger/RPi-Monitor/issues/412
sudo apt-key del 2C0D3C0F
gpg --keyserver keyserver.ubuntu.com --recv-keys E4E362DE2C0D3C0F
gpg --export E4E362DE2C0D3C0F | sudo gpg --dearmor -o /usr/share/keyrings/rpimonitor.gpg
echo "deb [signed-by=/usr/share/keyrings/rpimonitor.gpg] http://giteduberger.fr rpimonitor/" | sudo tee /etc/apt/sources.list.d/rpimonitor.list > /dev/null

#For filebrowser
#https://filebrowser.org/installation
#https://blog.quickso.cn/2022/02/12/FileBrowser%E5%AE%89%E8%A3%85%E5%8F%8A%E4%BD%BF%E7%94%A8/
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
sudo filebrowser -d /usr/local/etc/filebrowser.db config init
sudo filebrowser -d /usr/local/etc/filebrowser.db config set --address 0.0.0.0
sudo filebrowser -d /usr/local/etc/filebrowser.db config set --port 8080
sudo filebrowser -d /usr/local/etc/filebrowser.db config set --log /dev/shm/filebrowser.log
sudo filebrowser -d /usr/local/etc/filebrowser.db users add pi pi --perm.admin
sudo cp ./filebrowser.service /lib/systemd/system/filebrowser.service
sudo systemctl daemon-reload
sudo systemctl start filebrowser.service
sudo systemctl enable filebrowser.service

#For minidlna
#https://qiita.com/kmth220/items/1c592b8dc254503b6e83
sudo apt update
sudo apt-get install -y minidlna
sudo cp /etc/minidlna.conf /etc/minidlna.conf.bk
sudo cp ./minidlna.conf /etc/minidlna.conf
sudo /etc/init.d/minidlna restart

#For ttyd (port 800)
#https://linuxhint.com/share-your-raspberry-pi-terminal-on-browser-using-ttyd/
#https://blog.gtwang.org/linux/ttyd-share-terminal-over-the-web/
sudo apt update
sudo apt install build-essential cmake git libjson-c-dev libwebsockets-dev
cd /dev/shm
git clone https://github.com/tsl0922/ttyd.git
cd ttyd
mkdir build && cd build
cmake ..
make && sudo make install
## ttyd will be installed in /usr/local/bin/
sudo cp ./ttyd.service /etc/systemd/system/
sudo chmod 644 /etc/systemd/system/ttyd.service
sudo systemctl daemon-reload
sudo systemctl start ttyd
sudo systemctl enable ttyd

#For ufw
sudo apt update
sudo apt-get install -y ufw
sudo ufw enable
sudo ufw status
# ufw-httpd
sudo ufw allow 80
# ufw-file browser
sudo ufw allow 8080
# ufw-rpi monitor
sudo ufw allow 8888
# ufw-ssh
sudo ufw allow 22
sudo ufw allow 222
sudo ufw allow 2222
# ufw-transmission-bt
sudo ufw allow 9091
sudo ufw allow 51413
# ufw-aria2c
sudo ufw allow 6800
# ufw-minidlna
sudo ufw allow 8200
# ufw-Samba
sudo ufw allow 445
sudo ufw allow 139
# ufw-ttyd
sudo ufw allow 800
sudo ufw status

#For aria2c
#http://www.albertdelafuente.com/doku.php/wiki/dev/raspi/aria2c-raspi
sudo chmod +x /etc/init.d/aria2
#sudo update-rc.d aria2 defaults
cd /run/shm/
wget --no-check-certificate https://github.com/binux/yaaw/zipball/master -O yaaw.zip
#wget --no-check-certificate https://www.github.com/ziahamza/webui-aria2/zipball/master -O webui-aria2.zip
unzip yaaw.zip
mv binux-yaaw-*  /home/pi/media/yaaw
unzip webui-aria2.zip
#mv ziahamza-webui-aria2-* /home/pi/media/webui-aria2
rm yaaw.zip
#rm webui-aria2.zip

#install mount-img
#https://github.com/mafintosh/mount-img
curl -fs https://raw.githubusercontent.com/mafintosh/mount-img/master/install | sh

#Replace font to fix Chinese Subtile
#echo '--------自動置換字型腳本，作者: 蔡孟珂 mktsai@sweea.com------'
#echo '========================================================'
#echo 'step 1.下載 王漢宗自由字型 細黑體。download HanWangHeiLight font.'
#cd ~/
#wget http://dl.dropboxusercontent.com/u/13129397/raspbmc/wt011.ttf
#wget --no-check-certificate http://cl.ly/0r2i2R3x1x1a/download/wt011.ttf
#wget --no-check-certificate http://cl.ly/0Y27283z0w2x/download/arial.ttf
#echo '下載完成。'
#echo '========================================================'
#echo 'step 2.備份預設arial.ttf字型為arial.ttf.bak。Backup default font.'
#sudo mv /opt/xbmc-bcm/xbmc-bin/share/xbmc/media/Fonts/arial.ttf /opt/xbmc-bcm/xbmc-bin/share/xbmc/media/Fonts/arial.ttf.bak
#echo '========================================================'
#echo 'step 3.置換字型。replace font.'
#sudo mv ~/arial.ttf /opt/xbmc-bcm/xbmc-bin/share/xbmc/media/Fonts/arial.ttf
#sudo chmod 644 /opt/xbmc-bcm/xbmc-bin/share/xbmc/media/Fonts/arial.ttf
#sync
#echo '置換成功。job done.'
#echo '重新啟動xbmc後盡情享用。restart xbmc...'
#sudo initctl stop xbmc
#sudo initctl start xbmc
#echo '請輸入 exit 並按下enter以離開連線'
#echo '========================================================'

# Install better Transmission Web Control (a custom web UI)
#https://code.google.com/p/transmission-control/
#rootFolder=""
#webFolder=""
#orgindex="index.original.html"
#index="index.html"
#tmpFolder="/tmp/tr-web-control/"
#packname="transmission-control-full.tar.gz"
#host="http://transmission-control.googlecode.com/svn/resouces/"
#donwloadurl="$host$packname"
#if [ ! -d "$tmpFolder" ]; then
#	cd /tmp
#	mkdir tr-web-control
#fi
#cd "$tmpFolder"
#wget "$host""checkfolders.lst"
# 找出web ui 目录
#folderIsExist=0
#for i in `/bin/cat "$tmpFolder"checkfolders.lst`
#do
#	if [ -d "$i""web/" ]; then
#		rootFolder="$i"
#		webFolder="$i""web/"
#		folderIsExist=1
#		break
#	fi
#done
# 如果目录存在，则进行下载和更新动作
#if [ $folderIsExist = 1 ]; then
#	echo "Transmission Web Control Is Downloading..."
#	wget "$donwloadurl"
#	echo "Installing..."
#	tar -xzf "$packname"
#	rm "$packname"
	# 如果之前没有安装过，则先将原系统的文件改为
#	if [ ! -f "$webFolder$orgindex" -a -f "$webFolder$index" ]; then
#		sudo mv "$webFolder$index" "$webFolder$orgindex"
#	fi
	# 复制文件到
#	sudo cp -r web "$rootFolder"
#	echo "Done."
#else
#	echo "##############################################"
#	echo "#"
#	echo "# ERROR : Transmisson WEB UI Folder is missing."
#	echo "#"
#	echo "##############################################"
#fi
#rm -rf "$tmpFolder"
