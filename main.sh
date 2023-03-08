#! /bin/bash
set -e
# Add dependent repositories
wget -q -O - https://ppa.pika-os.com/key.gpg | sudo apt-key add -
add-apt-repository https://ppa.pika-os.com
add-apt-repository ppa:pikaos/pika
add-apt-repository ppa:kubuntu-ppa/backports
# Clone Upstream
wget https://launchpad.net/~obsproject/+archive/ubuntu/obs-studio/+sourcefiles/obs-studio/29.0.2-0obsproject1~kinetic/obs-studio_29.0.2.orig.tar.gz
tar -xf ./obs-studio_29.0.2.orig.tar.gz -C ./
cp -rvf ./debian ./obs-studio/
cd ./obs-studio
for i in ../patches/*; do patch -Np1 -i $i ;done

# Get build deps
apt-get build-dep ./ -y

# Build package
dpkg-buildpackage

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
