#! /bin/bash
set -e
# Add dependent repositories
wget -q -O - https://ppa.pika-os.com/key.gpg | sudo apt-key add -
add-apt-repository https://ppa.pika-os.com
add-apt-repository ppa:pikaos/pika
add-apt-repository ppa:kubuntu-ppa/backports
# Clone Upstream
git clone --recursive https://github.com/obsproject/obs-studio.git

cp -rvf ./debian ./obs-studio/
cd ./obs-studio

# remove -Werror flag to mitigate FTBFS with ffmpeg 5.1
sed -i 's|-Werror-implicit-function-declaration||g' CMakeLists.txt

## remove Werror to fix compile error
# there's probably a cleaner way to do this by modifying what compile flags
# the rpmbuilder adds
sed -i 's|    -Werror||g' cmake/Modules/CompilerConfig.cmake

for i in ../patches/*.patch; do patch -Np1 -i $i ;done

# Prepare plugins/obs-vkcapture
git clone --recurse-submodules https://github.com/nowrep/obs-vkcapture plugins/obs-vkcapture
cd plugins/obs-vkcapture
sed -i 's/install_obs_plugin_with_data/setup_plugin_target/g' CMakeLists.txt
cd ../../

# Prepare plugins/obs-source-record
git clone --recurse-submodules https://github.com/exeldro/obs-source-record plugins/obs-source-record
cd plugins/obs-source-record
sed -i 's/install_obs_plugin_with_data/setup_plugin_target/g' CMakeLists.txt
cd ../../

# Get build deps brute force
apt-get install -y cmake ninja-build pkg-config clang clang-format build-essential curl ccache git libffmpeg-amf-dev
apt-get install -y libavcodec-dev libavdevice-dev libnss3-dev libnspr4-dev libpipewire-0.3-dev libavfilter-dev libavformat-dev libavutil-dev libswresample-dev libswscale-dev libx264-dev libcurl4-openssl-dev libmbedtls-dev libgl1-mesa-dev libjansson-dev libluajit-5.1-dev python3-dev libx11-dev libxcb-randr0-dev libxcb-shm0-dev libxcb-xinerama0-dev libxcb-composite0-dev libxcomposite-dev libxinerama-dev libxcb1-dev libx11-xcb-dev libxcb-xfixes0-dev swig libcmocka-dev libxss-dev libglvnd-dev libgles2-mesa libgles2-mesa-dev libwayland-dev librist-dev libsrt-openssl-dev libpci-dev
apt-get install -y qt6-base-dev qt6-base-private-dev libqt6svg6-dev qt6-wayland qt6-image-formats-plugins
apt-get install -y libasound2-dev libfdk-aac-dev libfontconfig-dev libfreetype6-dev libjack-jackd2-dev libpulse-dev libsndio-dev libspeexdsp-dev libudev-dev libv4l-dev libva-dev libvlc-dev libdrm-dev


#cmake --build ./.build --target package
./CI/linux/01_install_dependencies.sh
./CI/linux/02_build_obs.sh
./CI/linux/03_package_obs.sh

# Build package
#dpkg-buildpackage

# Move the debs to output

mkdir -p ../output
ls build/
mv build/*.deb ../output/
cd ../
