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

#for i in ../patches/*; do patch -Np1 -i $i ;done

# Get build deps brute force
#apt-get build-dep ./ -y
apt-get install -y cmake ninja-build pkg-config clang clang-format build-essential curl ccache git
apt-get install -y libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev libavutil-dev libswresample-dev libswscale-dev libx264-dev libcurl4-openssl-dev libmbedtls-dev libgl1-mesa-dev libjansson-dev libluajit-5.1-dev python3-dev libx11-dev libxcb-randr0-dev libxcb-shm0-dev libxcb-xinerama0-dev libxcb-composite0-dev libxcomposite-dev libxinerama-dev libxcb1-dev libx11-xcb-dev libxcb-xfixes0-dev swig libcmocka-dev libxss-dev libglvnd-dev libgles2-mesa libgles2-mesa-dev libwayland-dev librist-dev libsrt-openssl-dev libpci-dev
apt-get install -y qt6-base-dev qt6-base-private-dev libqt6svg6-dev qt6-wayland qt6-image-formats-plugins
apt-get install -y libasound2-dev libfdk-aac-dev libfontconfig-dev libfreetype6-dev libjack-jackd2-dev libpulse-dev libsndio-dev libspeexdsp-dev libudev-dev libv4l-dev libva-dev libvlc-dev libdrm-dev

cmake -S . -B ./.build -G Ninja \
    -DCEF_ROOT_DIR="../obs-build-dependencies/cef_binary_5060_linux64" \
    -DENABLE_PIPEWIRE=ON \
    -DENABLE_AJA=0

cmake --build ./.build --target package


#./CI/build-linux.sh

# Build package
#dpkg-buildpackage

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
