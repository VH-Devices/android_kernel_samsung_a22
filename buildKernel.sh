#!/bin/bash

# Written by Hakalle (Velosh) <hakalle@proton.me>.

# Clone GCC & Proton Clang.
[[ -d "$(pwd)/gcc/" ]] || git clone https://github.com/VH-Devices/toolchains -b gcc-10.3.0 gcc --depth 1 >> /dev/null 2> /dev/null
[[ -d "$(pwd)/clang/" ]] || git clone https://github.com/kdrag0n/proton-clang clang --depth 1 >> /dev/null 2> /dev/null

# Export KBUILD_BUILD_{USER,HOST} flags.
export KBUILD_BUILD_USER="zyzoh"
export KBUILD_BUILD_HOST="zyzoh"

# Export ARCH/SUBARCH flags.
export ARCH="arm64"
export SUBARCH="arm64"

# Export CCACHE
export CCACHE_EXEC="$(which ccache)"
export CCACHE="${CCACHE_EXEC}"
export CCACHE_COMPRESS="1"
export USE_CCACHE="1"
$CCACHE -M 50G

# Export toolchain/clang/llvm flags
export CROSS_COMPILE="$(pwd)/gcc/bin/aarch64-buildroot-linux-gnu-"
export CLANG_TRIPLE="aarch64-linux-gnu-"
export CC="$(pwd)/clang/bin/clang"

# Export if/else outdir var
export WITH_OUTDIR=true

# Clear the console
clear

# Remove out dir folder and clean the source
if [ "${WITH_OUTDIR}" == true ]; then
   if [ -d "$(pwd)/a22" ]; then
      rm -rf a22
   fi
fi

# Build time
if [ "${WITH_OUTDIR}" == true ]; then
   if [ ! -d "$(pwd)/a22" ]; then
      mkdir a22
   fi
fi

if [ "${WITH_OUTDIR}" == true ]; then
   "${CCACHE}" make O="$(pwd)/a22" a22_defconfig
   "${CCACHE}" make -j`nproc` O="$(pwd)/a22"
fi