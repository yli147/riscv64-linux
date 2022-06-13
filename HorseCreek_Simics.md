
## Build Debian RISC-V Port Image
```
git clone git@github.com:intel-sandbox/xzhang84.riscv-rootfs-builder.git
git checkout -m 4bff6863950fd2914ce7d895c85ed14112a31c11
cd scripts/
wget -c http://http.us.debian.org/debian/pool/main/d/debian-ports-archive-keyring/debian-ports-archive-keyring_2022.02.15_all.deb
sudo apt-get install ./debian-ports-archive-keyring_2022.02.15_all.deb
./create_debian_image.sh
```
The image debian-sid-riscv.img will be created. Please note currently for Debian RISC-V is not an official architecture, so the image is based on Debian Unstable release.
```
./run_qemu.sh
```

## Download and install Simics packages

Three Simics packages are needed for Horse Creek platform. Please download these packages from the Linux Public packages.

Simics Base (1000), version 1000-6.0.137
RISC-V CPU (2050), version 2050-6.0.pre38
HorseCreek platform (2011), version 2011-6.0.pre6
```
mkdir ~/simics
cd ~/simics
wget https://ubit-artifactory-sh.intel.com/artifactory/simics-repos/pub/simics-6/linux64/simics-pkg-1000-6.0.137-linux64.tar
wget https://ubit-artifactory-sh.intel.com/artifactory/simics-repos/pub/simics-6/linux64/simics-pkg-2011-6.0.pre6-linux64.tar
wget https://ubit-artifactory-sh.intel.com/artifactory/simics-repos/pub/simics-6/linux64/simics-pkg-2050-6.0.pre38-linux64.tar
tar xf simics-pkg-1000-6.0.137-linux64.tar
tar xf simics-pkg-2011-6.0.pre6-linux64.tar
tar xf simics-pkg-2050-6.0.pre38-linux64.tar
cd simics-6-install
sudo apt install heimdal-clients
./install-simics.pl
```
