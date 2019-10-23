#!/bin/bash

# BASEDIR=$(dirname $0)
# cd $BASEDIR
#
# VERSION=$(<VERSION)
# IMAGE_NAME="marcoraddatz/homebridge"
# CONTAINER_NAME=Homebridge

ACTION=$1
PORT=$3
ESPPORT=/dev/cu.usbserial-1410

if [ -z "$ACTION" ];
  then
    echo "usage: $0 <build|clean|erase|flash|debug>";
    exit 1;
fi

# Build
_build() {
  docker run -it --rm -v $(pwd):/project -w /project "$@" esp-rtos make -C . ESPPORT=/dev/cu.usbserial-1410 FLASH_SIZE=8 HOMEKIT_SPI_FLASH_BASE_ADDR=0x8c000 HOMEKIT_DEBUG=1 clean
}

# Build
_clean() {
  # docker run -it --rm -v $(pwd):/project -w /project "$@" esp-rtos make -C . ESPPORT="$PORT" FLASH_SIZE=8 HOMEKIT_SPI_FLASH_BASE_ADDR=0x8c000 HOMEKIT_DEBUG=1 all
  docker run -it --rm -v $(pwd):/project -w /project "$@" esp-rtos make -C . ESPPORT=/dev/cu.usbserial-1410 FLASH_SIZE=8 HOMEKIT_SPI_FLASH_BASE_ADDR=0x8c000 HOMEKIT_DEBUG=1 all
}

# Erase firmware
_erase() {
  esptool.py -p /dev/cu.usbserial-1410 --baud 115200 erase_flash;
}

# Flash latest prebuilt OTA firmware
_flash() {
  esptool.py -p /dev/cu.usbserial-1410 --baud 115200 write_flash -fs 1MB -fm dout -ff 40m 0x0 firmware_prebuilt/rboot.bin 0x1000 firmware_prebuilt/blank_config.bin 0x2000 firmware_prebuilt/otaboot.bin;
}

_debug() {
  screen /dev/cu.usbserial-1410 115200 –L
}

_release() {
  echo "WIP: Coming soon..."
  echo $PORT
}

# Rebuild firmware
_rebuild() {
  _clear
  _build
}

# Erase firmware, flash and debug
_rerun() {
  _erase
  _flash
  _debug
}


eval _$ACTION
