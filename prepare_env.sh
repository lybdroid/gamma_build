#!/bin/bash

sudo apt install bc
git clone --depth=1 https://github.com/lybxlpsv/android_kernel_lge_msm8996.git -b gamma-pie kernel
git clone --depth=1 https://github.com/mvaisakh/gcc-arm64 -b lld-integration gcc64
