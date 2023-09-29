#! /bin/bash
set -e

# Clone Upstream
git clone --recursive https://github.com/obsproject/obs-studio.git -b 29.1.3

cp -rvf ./debian ./obs-studio/
cd ./obs-studio

wget https://cdn-fastly.obsproject.com/downloads/cef_binary_5060_linux64.tar.bz2
tar -xf ./cef_binary_5060_linux64.tar.bz2 -C ./
#git clone https://github.com/aja-video/ntv2.git

# remove -Werror flag to mitigate FTBFS with ffmpeg
sed -i 's|-Werror-implicit-function-declaration||g' CMakeLists.txt

## remove Werror to fix compile error
sed -i 's|    -Werror||g' cmake/Modules/CompilerConfig.cmake
sed -i 's|    -Wswitch||g' cmake/Modules/CompilerConfig.cmake

for i in ../patches/* ; do echo "Applying Patch: $i" && patch -Np1 -i $i || echo "Applying Patch $i Failed!"; done

# Get build deps brute force
apt-get build-dep -y ./

dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
