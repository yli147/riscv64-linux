## Quick Start to build Yocto image for BeagleV board(StartFive F7100)
```
# sudo apt-get install chrpath diffstat zstd
# sudo touch /bin/gitscript 
# sudo chmod a+x /bin/gitscript
# sudo vim /bin/gitscript
  #!/bin/sh
  _proxy=child-prc.intel.com
  _proxyport=913
  exec socat STDIO PROXY:$_proxy:$1:$2,proxyport=$_proxyport
```
```
# sudo vim ~/.ssh/config
  [http "https://git.kernel.org"]
        proxy = http://proxy-prc.intel.com:912
  [core]
        gitproxy = /bin/gitscript     
```
```
mkdir riscv-yocto && cd riscv-yocto
repo init -u https://github.com/riscv/meta-riscv  -b master -m tools/manifests/riscv-yocto.xml
repo sync
repo start work --all
. ./meta-riscv/setup.sh
sudo vim ../meta-riscvrecipes-bsp/u-boot/u-boot-starfive_v2021.04.bb
  * Change Fedora_VIC_7100_2021.04 to Fedora_JH7100_2021.04
sudo vim ../meta-riscv/recipes-kernel/linux/linux-starfive-dev.bb
  * Change beaglev_defconfig to visionfive_defconfig
MACHINE=qemuriscv64 bitbake core-image-full-cmdline
```


## Refernce
  - https://wiki.parabola.nu/Computers/Beagle-V
  - https://github.com/riscv/meta-riscv
  - git://github.com/tekkamanninja/u-boot.git;protocol=https;branch=allwinner_d1
  - https://www.dounaite.com/article/62630600f86aba5c7884e05d.html
