#! /bin/bash
set -e
# Add dependent repositories
wget -q -O - https://ppa.pika-os.com/key.gpg | sudo apt-key add -
add-apt-repository https://ppa.pika-os.com
add-apt-repository ppa:pikaos/pika
add-apt-repository ppa:kubuntu-ppa/backports
# Clone Upstream
git clone --recursive https://github.com/obsproject/obs-studio.git
git checkout 7ceb39bd5630c4363543d121a0c2c753492e3f97

cp -rvf ./debian ./obs-studio/
cd ./obs-studio
cd ./plugins

wget https://cdn-fastly.obsproject.com/downloads/cef_binary_5060_linux64.tar.bz2
tar -xf ./cef_binary_5060_linux64.tar.bz2 -C ./

# remove -Werror flag to mitigate FTBFS with ffmpeg
sed -i 's|-Werror-implicit-function-declaration||g' CMakeLists.txt

## remove Werror to fix compile error
sed -i 's|    -Werror||g' cmake/Modules/CompilerConfig.cmake
sed -i 's|    -Wswitch||g' cmake/Modules/CompilerConfig.cmake

for i in ../patches/*.patch; do patch -Np1 -i $i ;done

# Get build deps brute force
apt-get build-dep -y ./

dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
