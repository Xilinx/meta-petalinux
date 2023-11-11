#! /bin/bash

# Call using:
#../riscv/sysroots/x86_64-oesdk-linux/usr/bin/riscv-xilinx-elf/riscv-xilinx-elf-gcc -print-multi-lib | riscv-convert.sh

# Then copy the output into the special riscv-tc BSP

sed -e 's,;, ,' |
  while read mlib args ; do
    if [ $mlib = '.' ]; then
      echo '# Base configuration'
      echo '# CFLAGS:'
      echo 'DEFAULTTUNE = "riscv"'
      echo
      echo 'AVAILTUNES += "riscv"'
      echo 'PACKAGE_EXTRA_ARCHS:tune-riscv = "${TUNE_PKGARCH:tune-riscv}"'
      echo 'BASE_LIB:tune-riscv = "lib"'
      echo 'TUNE_FEATURES:tune-riscv = "riscv"'
      echo 'TUNE_CCARGS:tune-riscv = ""'
      echo 'TUNE_PKGARCH:tune-riscv = "riscv32"'
      echo 'TUNE_ARCH:tune-riscv = "riscv32"'
      continue
    fi

    cflags=$(echo $args | sed -e 's,@, -,g')
    multilib="lib$(echo $mlib | sed -e 's,/,,g')"
    tune="$(echo $mlib | sed -e 's,/,,g')"
    case $mlib in
        .)  arch="riscv32" ;;
        rv32*) arch="riscv32" ;;
        rv64*) arch="riscv64" ;;
        *) arch="unknwon" ;;
    esac
    echo
    echo
    echo "# $mlib"
    echo "# CFLAGS:${cflags}"
    echo "DEFAULTTUNE:virtclass-multilib-$multilib = \"$tune\""
    echo
    echo "AVAILTUNES += \"$tune\""
    echo "PACKAGE_EXTRA_ARCHS:tune-$tune = \"\${TUNE_PKGARCH:tune-$tune}\""
    echo "BASE_LIB:tune-$tune = \"lib/$mlib\""
    echo "TUNE_FEATURES:tune-$tune = \"riscv\""
    echo "TUNE_CCARGS:tune-$tune = \"$cflags\""
    echo "TUNE_PKGARCH:tune-$tune = \"$tune\""
    echo "TUNE_ARCH:tune-$tune = \"$arch\""
  done
