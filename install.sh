#!/usr/bin/env bash

TEMP=$(mktemp -d)

cp -rvf ./assets/ $TEMP

cd $TEMP

download_xbps() {
  echo "  * Downloading ${@}..."
  wget https://alpha.de.repo.voidlinux.org/current/${@}
}

install_xbps() {
  if test -f ${@}.xbps; then
    mkdir -pv ${@}
    cd ${@}
    mv -v ../${@}.xbps ./
    tar -xvf ./${@}.xbps
    rm ${@}.xbps
    echo "  * Merging ${@}.xbps into /..."
    rsync -avh . /
    cd ..
    rmdir ${@}
  fi
}

declare -a pkgs=(
  "linux-firmware-amd-20230404_1.x86_64.xbps"
  "linux-firmware-amd-20230515_1.x86_64.xbps"
  "linux-firmware-broadcom-20230404_1.x86_64.xbps"
  "linux-firmware-broadcom-20230515_1.x86_64.xbps"
  "linux-firmware-intel-20230404_1.x86_64.xbps"
  "linux-firmware-intel-20230515_1.x86_64.xbps"
  "linux-firmware-network-20230404_1.x86_64.xbps"
  "linux-firmware-network-20230515_1.x86_64.xbps"
  "linux-firmware-nvidia-20230404_1.x86_64.xbps"
  "linux-firmware-nvidia-20230515_1.x86_64.xbps"
  "linux6.1-6.1.31_1.x86_64.xbps"
)

echo "[I] Downloading sources..."

for pkg in ${pkgs[@]}; do
  download_xbps $pkg
done

echo "[I] Installing sources..."

for pkg in ${pkgs[@]}; do
  install_xbps $(echo $pkg | sed 's/\.xbps$//g')
done

cp -rvf ./assets/* /boot

cd /
rm -rvf $TEMP
