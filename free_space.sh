#!/bin/bash
# Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
#set -eu
#snap list --all | awk '/disabled/{print $1, $3}' |
#    while read snapname revision; do
#        snap remove "$snapname" --revision="$revision"
#    done

# CLEAN linux-image pkg
#dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge
#apt-get autoremove
#apt-get update

# CLEAN journal logs (retain 3day log)
# journalctl --vacuum-time=3d
journalctl --flush --rotate --vacuum-time=3d
journalctl --user --flush --rotate --vacuum-time=3d

# CLEAN configure file for uninstalled pkg
apt-get clean && sudo apt-get autoremove --purge -y $(dpkg --list | grep '^rc' | awk '{print $2}')
