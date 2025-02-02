#!/usr/bin/env bash

set -e

export  DEBIAN_FRONTEND=noninteractive
# For compability issues in bsaefiles of Lingmo OS

rm /etc/apt/sources.list | true 

rm /etc/apt/sources.list.d/debian.sources | true

sed -i "s/bookworm/trixie/g" `grep bookworm -rl /etc/apt/sources.list.d` | true

echo -e "Types: deb\nURIs: http://debian-archive.trafficmanager.net/debian\nSuites: trixie trixie-updates trixie-backports\nComponents: main contrib non-free non-free-firmware\nSigned-By: /usr/share/keyrings/debian-archive-keyring.gpg\n\n# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释\n# Types: deb-src\n# URIs: http://debian-archive.trafficmanager.net/debian\n# Suites: trixie trixie-updates trixie-backports\n# Components: main contrib non-free non-free-firmware\n# Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg\n\n# 以下安全更新软件源包含了官方源与镜像站配置，如有需要可自行修改注释切换\nTypes: deb\nURIs: http://debian-archive.trafficmanager.net/debian-security\nSuites: trixie-security\nComponents: main contrib non-free non-free-firmware\nSigned-By: /usr/share/keyrings/debian-archive-keyring.gpg\n\n# Types: deb-src\n# URIs: http://debian-archive.trafficmanager.net/debian-security\n# Suites: trixie-security\n# Components: main contrib non-free non-free-firmware\n# Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg" > /etc/apt/sources.list.d/debian.sources 

# apt-get update 
# apt-get  -o Dpkg::Options::="--force-all" dist-upgrade -y
# apt-get clean

# echo "deb [trusted=yes] https://nightly-packages.simplelinux.cn.eu.org/ nightly experimental" > /etc/apt/sources.list.d/lingmo-nightly.list

# curl -o /etc/apt/trusted.gpg.d/lingmo-nightly-signing.key.asc --create-dirs https://raw.githubusercontent.com/LingmoOS/live-build-config/a84c6e0429572e144fe720611218a3bdb063b112/lingmo-config/common/archives/lingmo-nightly-signing.key.chroot 
