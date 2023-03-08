#! /bin/bash
set -e
# Add dependent repositories
wget -q -O - https://ppa.pika-os.com/key.gpg | sudo apt-key add -
add-apt-repository https://ppa.pika-os.com
add-apt-repository ppa:pikaos/pika
add-apt-repository ppa:kubuntu-ppa/backports
# Clone Upstream
git clone --recursive https://github.com/obsproject/obs-studio.git
wget https://cdn-fastly.obsproject.com/downloads/cef_binary_5060_linux64.tar.bz2
mkdir -p ./build_dependencies/
tar -xf ./cef_binary_5060_linux64.tar.bz2 -C ./build_dependencies/
cp -rvf ./debian ./obs-studio/
cp -rvf ./build_dependencies  ./obs-studio/
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
