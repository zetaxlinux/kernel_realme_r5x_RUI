make clean ; make mrproper
#!/bin/bash

echo -e "\033[93m==========================="
echo -e "\033[93m= START COMPILING KERNEL  ="
echo -e "\033[93m==========================="
echo
echo -e -n "\033[93m\033[104mPRESS ENTER TO CONTINUE\033[0m"
read P
echo  $P

bold=$(tput bold)
normal=$(tput sgr0)

# Scrip option
while (( ${#} )); do
    case ${1} in
        "-Z"|"--zip") ZIP=true ;;
    esac
    shift
done
[[ -z ${ZIP} ]] && { echo "${bold}LOADING-_-....${normal}"; }
echo

DEFCONFIG="vendor/R5X_defconfig"
export KBUILD_BUILD_USER=t.me/@zetaxlinux
export KBUILD_BUILD_HOST=Herobrine
TC_DIR="/workspace/gitpod/clang-r498229b"
export PATH="$TC_DIR/bin:$PATH"

if [[ $1 = "-r" || $1 = "--regen" ]]; then
make O=out ARCH=arm64 $DEFCONFIG savedefconfig
cp out/defconfig arch/arm64/configs/$DEFCONFIG
exit
fi

if [[ $1 = "-c" || $1 = "--clean" ]]; then
rm -rf out
fi

mkdir -p out
make O=out ARCH=arm64 $DEFCONFIG


make -j$(nproc --all) O=out ARCH=arm64 CC=clang LD=ld.lld AR=llvm-ar AS=llvm-as NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- 2>&1 | tee log.txt

    echo -e "==========================="
    echo -e "   COMPILE KERNEL COMPLETE "
    echo -e "==========================="

