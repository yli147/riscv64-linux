## Cross Compile RSIC-V GNU Toolchain

### Prerequisites
```bash
  sudo apt-get install autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev
```

### Submodules of the Toolchain
```bash
  riscv-binutils: The binary utilities
  riscv-dejagnu: The testing framework
  riscv-gcc: The core C compiler
  riscv-gdb: The GNU debugger
  riscv-glibc: The Posix standard C library
  riscv-newlib: The bare-metal standard C library	
```

### Download the 2022.06.03 TAG
```bash
  git clone --recursive https://github.com/riscv/riscv-gnu-toolchain -b 2022.06.03
```
Errors occur because of the coporation firewall which blocks the GIT protocol, and the http proxy does not take effect to GIT protocol
```
  fatal: clone of 'git://sourceware.org/git/glibc.git' into submodule path failed
  fatal: clone of 'git://git.musl-libc.org/musl' into submodule path failed
  fatal: clone of 'git://sourceware.org/git/newlib-cygwin.git' into submodule path failed
```

### Download the repos manually
```bash	
  git config --global url.http://sourceware.org/.insteadOf git://sourceware.org/
  rm -rf glibc
  rm -rf musl
  rm -rf newlib

  git clone git://sourceware.org/git/glibc.git
	cd glibc; git checkout -m 9826b03; cd ..

  wget -c http://git.musl-libc.org/cgit/musl/snapshot/musl-1.2.2.tar.gz
  tar zxvf musl-1.2.2.tar.gz
  mv musl-1.2.2 musl

  git clone git://sourceware.org/git/newlib-cygwin.git
  cd newlib-cygwin; git checkout -m 415fdd4; cd ..
  mv newlib-cygwin newlib
```

### Update the Submodules
```bash
  cd riscv-gdb; git checkout -m 5da071e; cd ..
  cd riscv-gcc; git checkout -m 5964b5c; cd ..
  cd riscv-binutils; git checkout -m 20756b0; cd ..
  cd pk; git checkout -m 2efabd3; cd ..
  cd qemu; git checkout -m 553032d; cd ..
  cd riscv-dejagnu;git checkout -m 4ea498a; cd ..
  cd spike; git checkout -m a0298a3; cd ..
```

### Configure and Build the Toolchain
To build either cross-compiler with support for both 32-bit and 64-bit, run the following commands.
```bash
  mkdir `pwd`/../_install
  ./configure --prefix=`pwd`/../_install --enable-multilib
  make -j`nproc`
```
Either make, make linux or make musl for the Newlib, Linux glibc-based or Linux musl libc-based cross-compiler, respectively.

### Reference
```bash
  https://github.com/riscv-collab/riscv-gnu-toolchain
  http://www.openv.cc/archives/1
  https://programmersought.com/article/4626958334/
```  
