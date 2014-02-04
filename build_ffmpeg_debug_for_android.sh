#!/bin/bash
NDK=/Applications/android-ndk-r9b
SYSROOT=$NDK/platforms/android-18/arch-arm/
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/darwin-x86_64
# Note: Change the TOOLCHAIN to match that available for your host system.
# darwin-x86_64 is for Mac OS X, but you knew that.
function build_one
{
./configure \
    --prefix=$PREFIX \
    --enable-shared \
    --enable-static \
    --disable-programs \
    --disable-optimizations \
    --disable-stripping \
    --disable-asm \
    --assert-level=2 \
    --enable-debug=3 \
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --target-os=linux \
    --arch=arm \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="-g -gdwarf-2 -g3 -O0 -fpic $ADDI_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
make clean
make -j4
make install
}
CPU=arm
PREFIX=$(pwd)/android/$CPU 
ADDI_CFLAGS="-marm"
build_one