#!/bin/bash

CHROOT_DIR="//mnt/raid12t/liyong/ubuntu_2204_rootfs"
UBUNTU_RELEASE="jammy"

# 创建 chroot 环境
echo "Creating Ubuntu 22.04 chroot environment..."
sudo mkdir -p $CHROOT_DIR
sudo debootstrap --arch=amd64 $UBUNTU_RELEASE $CHROOT_DIR http://archive.ubuntu.com/ubuntu/

# 创建挂载脚本
cat << 'EOF' | sudo tee /usr/local/bin/mount-chroot
#!/bin/bash
CHROOT_DIR="/opt/ubuntu-chroot"
sudo mount --bind /dev $CHROOT_DIR/dev
sudo mount --bind /proc $CHROOT_DIR/proc
sudo mount --bind /sys $CHROOT_DIR/sys
sudo mount --bind /dev/pts $CHROOT_DIR/dev/pts
sudo cp /etc/resolv.conf $CHROOT_DIR/etc/
EOF

# 创建卸载脚本
cat << 'EOF' | sudo tee /usr/local/bin/umount-chroot
#!/bin/bash
CHROOT_DIR="/opt/ubuntu-chroot"
sudo umount $CHROOT_DIR/dev/pts
sudo umount $CHROOT_DIR/dev
sudo umount $CHROOT_DIR/proc
sudo umount $CHROOT_DIR/sys
EOF

# 创建进入脚本
cat << 'EOF' | sudo tee /usr/local/bin/enter-chroot
#!/bin/bash
/usr/local/bin/mount-chroot
sudo chroot /opt/ubuntu-chroot /bin/bash
EOF

sudo chmod +x /usr/local/bin/{mount-chroot,umount-chroot,enter-chroot}

echo "Setup complete! Use 'sudo enter-chroot' to enter the environment"
