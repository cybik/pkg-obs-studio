# Add dependent repositories
wget -q -O - https://ppa.pika-os.com/key.gpg | sudo apt-key add -
add-apt-repository https://ppa.pika-os.com
add-apt-repository ppa:pikaos/pika
add-apt-repository ppa:kubuntu-ppa/backports
# Clone Upstream
tar -xf ./obs-studio-29.0.2.orig.tar.gz -C ./
tar -xf ./cef_binary_5060_linux64.tar.xz -C ./build_dependencies/
mv ./obs-studio-0fb8bb4b1e18ee1c870c48d35ab5b598af3b59e9 ./obs-studio
cp -rvf ./debian ./obs-studio/
cp -rvf ./build_dependencies  ./obs-studio/
cd ./obs-studio

# Get build deps
apt-get build-dep ./ -y

# Build package
dpkg-buildpackage

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
