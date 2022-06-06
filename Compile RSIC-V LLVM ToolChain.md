## Getting Started with the LLVM System
Taken from https://llvm.org/docs/GettingStarted.html.

### Prerequisites
[Cross Compile GNU ToolChain] https://github.com/yli147/riscv64-linux/blob/main/Compile%20RSIC-V%20GNU%20ToolChain.md

### Cross Compile GNU Toolchain
```bash
   git clone https://github.com/llvm/llvm-project.git -b llvmorg-14.0.0
   cd llvm-project
   ln -s ../../clang llvm/tools || true
   mkdir build
   cd build
   cmake -G Ninja -DCMAKE_BUILD_TYPE="Release" \
    -DBUILD_SHARED_LIBS=True -DLLVM_USE_SPLIT_DWARF=True \
    -DCMAKE_INSTALL_PREFIX="../../_install" \
    -DLLVM_OPTIMIZED_TABLEGEN=True -DLLVM_BUILD_TESTS=False \
    -DDEFAULT_SYSROOT="../../_install/riscv64-unknown-elf" \
    -DLLVM_DEFAULT_TARGET_TRIPLE="riscv64-unknown-elf" \
    -DLLVM_TARGETS_TO_BUILD="RISCV" \
     ../llvm
    cmake --build . --target install
```

### Test the LLVM Toolchain
```bash
cat >hello.c <<END
#include <stdio.h>

int main(){
  printf("Hello RISCV!\n");
  return 0;
}
END
../../_install/bin/clang -I ../../../_install/riscv64-unknown-elf/include/ -O -c hello.c
../../../_install/bin/riscv64-unknown-elf-gcc hello.o -o hello -march=rv64imac -mabi=lp64
```

### Execute the Compiled Binary in QEMU
```bash
   cp hello ~/workspace/riscv64-linux/qemu/
   cd ~/workspace/riscv64-linux/qemu/
   echo hello|cpio -H newc -o|gzip -9 >> ../initramfs.cpio.gz 
   cd ..
   sudo ./qemu/build/qemu-system-riscv64 -nographic -machine virt -kernel ./linux/arch/riscv/boot/Image -initrd initramfs.cpio.gz -append "root=/dev/vda ro console=ttyS0"
```
