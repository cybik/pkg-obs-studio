# add debs to repo
ssh ferreo@direct.pika-os.com 'aptly repo remove pikauwu-main libwebrtc-audio-processing-dev_1.3.0-100pika1_amd64.deb'
ssh ferreo@direct.pika-os.com 'aptly repo remove pikauwu-main libwebrtc-audio-processing1_1.3.0-100pika1_amd64.deb'
# publish the repo
ssh ferreo@direct.pika-os.com 'aptly publish update -batch -skip-contents -force-overwrite pikauwu filesystem:pikarepo:'
