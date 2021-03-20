#!/bin/bash

CURR_PATH=${0%/*}
CURR_PATH="$(realpath $CURR_PATH)/"

mkdir -p "${CURR_PATH}/release"

variants="us996 vs995 h910 h918 h990 ls997 h830 h850 rs988"
GCC_VER=$(./gcc64/bin/aarch64-elf-gcc --version | head -n 1)

for variant in $variants
do
    rm -vrf "${CURR_PATH}/out/kbuild/arch/arm64/boot"
    time make -j4 KDEFCONFIG=lineageos_${variant}_oxavelar_defconfig
    mkdir -vp "${CURR_PATH}/release/${variant}"
    mv -v "${CURR_PATH}/out/Image.gz-dtb" "${CURR_PATH}/release/${variant}/Image.gz-dtb"

    DATEI=$(date +"%Y_%m_%d_%I_%M")
    rm lge_msm8996_gamma-${variant}_${DATEI}.zip
    cp "${CURR_PATH}/release/${variant}/Image.gz-dtb" "${CURR_PATH}/anykernel"
    cd anykernel
    zip -r9 lge_msm8996_gamma-${variant}_${DATEI}.zip *
    mv lge_msm8996_gamma-${variant}_${DATEI}.zip ..
    rm Image.gz-dtb
    cd ..
    curl -F document=@lge_msm8996_gamma-${variant}_${DATEI}.zip "https://api.telegram.org/bot$BOTTOKEN/sendDocument" \
        -F chat_id="$CHATID" \
        -F caption="[BOT] Build for ${variant} GAMMA AOSP Eva GCC 11.0.1 20210318"

done

