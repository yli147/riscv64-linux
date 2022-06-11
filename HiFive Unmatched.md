## Main Page

https://www.sifive.com/boards/hifive-unmatched

## User Manual

https://sifive.cdn.prismic.io/sifive/1a82e600-1f93-4f41-b2d8-86ed8b16acba_fu740-c000-manual-v1p6.pdf

## SOftware Manual
https://sifive.cdn.prismic.io/sifive/f81e5848-875e-4ae1-baff-09057743d3a5_hifive-unmatched-sw-reference-manual-v1p1.pdf

## Prebuild Image
https://github.com/carlosedp/riscv-bringup

## Booting with QEMU
```
sudo apt install qemu-system-misc opensbi u-boot-qemu qemu-utils
wget https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04-preinstalled-server-riscv64+unmatched.img.xz
xz -dk ubuntu-22.04-preinstalled-server-riscv64+unmatched.img.xz

export CROSS_COMPILE=riscv64-linux-gnu-
git clone https://source.denx.de/u-boot/u-boot.git
cd u-boot/
git reset --hard v2021.10-rc3
make qemu-riscv64_smode_defconfig
make -j$(nproc)
cd ..

git clone https://github.com/riscv/opensbi.git
cd opensbi/
make PLATFORM=generic FW_PAYLOAD_PATH=../u-boot/u-boot.bin
cd ..
```

```
qemu-system-riscv64 -machine virt -m 1G -nographic \
-bios opensbi/build/platform/generic/firmware/fw_payload.bin \
-smp cores=2 -gdb tcp::1234 \
-device virtio-net-device,netdev=net0 \
-netdev user,id=net0,tftp=tftp \
-drive if=none,file=ubuntu-22.04-preinstalled-server-riscv64+unmatched.img,format=raw,id=mydisk \
-device ich9-ahci,id=ahci -device ide-hd,drive=mydisk,bus=ahci.0 \
-device virtio-rng-pci
```
OR
```
qemu-system-riscv64 \
-machine virt -nographic -m 2048 -smp 4 \
-bios /usr/lib/riscv64-linux-gnu/opensbi/generic/fw_jump.elf \
-kernel u-boot/u-boot.bin \
-device virtio-net-device,netdev=eth0 -netdev user,id=eth0 \
-drive file=ubuntu-22.04-preinstalled-server-riscv64+unmatched.img,format=raw,if=virtio
```
** The default /usr/lib/u-boot/qemu-riscv64_smode/uboot.elf version is 2021.1, the system map may not corret, please check the u-boot/System.map


## Install Image on Unmatched Board
https://ubuntu.com/tutorials/how-to-install-ubuntu-on-risc-v-hifive-boards

### Flashing the Image Via Command Line
To flash the image to the SD card via the command line, run
```
wget https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04-preinstalled-server-riscv64+unmatched.img.xz
xz -dk ubuntu-22.04-preinstalled-server-riscv64+unmatched.img.xz
dd if=ubuntu-22.04-preinstalled-server-riscv64+unmatched.img of=/dev/mmcblk0 bs=1M status=progress
```

### Booting for the First Time
Connecting to the Serial Console, with micro-usb cable, the baudrate is 115200

The default username/password is
```
username: ubuntu
password: ubuntu
```

### Installing Ubuntu to an NVMe drive (only for Unmatched)
Boot the Ubuntu 22.04 from SD-Card, from the Serial Console
```
ls -l /dev/nvme*
wget https://cdimage.ubuntu.com/releases/22.04/release/ubuntu-22.04-preinstalled-server-riscv64+unmatched.img.xz -e use_proxy=yes -e https_proxy=http://child-prc.intel.com:913
xz -dk ubuntu-22.04-preinstalled-server-riscv64+unmatched.img.xz
sudo dd if=ubuntu-22.04-preinstalled-server-riscv64+unmatched.img of=/dev/nvme0n1 bs=1M status=progress
sudo mount /dev/nvme0n1p1 /mnt
sudo chroot /mnt

vim /etc/default/u-boot
* Add the line
  U_BOOT_ROOT="root=/dev/nvme0n1p1"
u-boot-update
sudo shutdown 0
```

### Setting up a Desktop Environment
Use Nvida GT720 graphic card,Boot the Ubuntu 22.04 from SSD, from the Serial Console
```
touch ~/etc/apt/apt.conf
vim ~/etc/apt/apt.conf
* Add Proxy setting
  Acquire::http::proxy "http://child-prc.intel.com:913";
  Acquire::https::proxy "http://child-prc.intel.com:913";
sudo apt update
sudo apt install gnome-shell gnome-shell-extension-appindicator gnome-shell-extension-desktop-icons-ng gnome-shell-extension-ubuntu-dock gnome-terminal
<sudo apt install mutter gnome-shell gnome-shell-extension-appindicator gnome-shell-extension-desktop-icons-ng gnome-shell-extension-prefs gnome-shell-extension-ubuntu-dock ubuntu-gnome-wallpapers gnome-terminal>
<sudo apt install epiphany-browser>
```
And then Reboot, the Ubuntu desktop will come our from the graphic interface
