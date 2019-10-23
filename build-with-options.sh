#!/bin/bash

POSITIONAL=()
PORT=/dev/cu.usbserial-1410
MEMORY=1
FLASH_SIZE=8
ADDR=0x8c000
ACTION=$1

if [ -z "$ACTION" ];
  then
    echo "usage: $0 <build|clean|erase|flash|debug>";
    exit 1;
fi

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -p|--port)
    PORT="$2"
    shift # past argument
    shift # past value
    ;;
    -m|--memory)
    MEMORY="$2MB" && FLASH_SIZE=$((8 * $2))

    shift # past argument
    shift # past value
    ;;
    --default)
    ADDR="$2"
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo "SERIAL PORT     = ${PORT}"
echo "MEMORY SIZE     = ${MEMORY}"
echo "MEMORY SIZE IN  = ${MEMORY}"
echo "FLASH ADDRESS   = ${ADDR}"

# echo "$1"
# if [[ -n $1 ]]; then
#     echo "Start $ACTION using port $PORT to address $ADDR having $MEMORY MB"
# fi

echo "Start $ACTION using port $PORT to address $ADDR having ESP8266 with $MEMORY($FLASH_SIZE) flash size"

# Build
_build() {
  echo docker run -it --rm -v $(pwd):/project -w /project "$@" esp-rtos make -C . ESPPORT=$PORT FLASH_SIZE=$FLASH_SIZE HOMEKIT_SPI_FLASH_BASE_ADDR=$ADDR HOMEKIT_DEBUG=1 clean
  docker run -it --rm -v $(pwd):/project -w /project "$@" esp-rtos make -C . ESPPORT=$PORT FLASH_SIZE=$FLASH_SIZE HOMEKIT_SPI_FLASH_BASE_ADDR=$ADDR HOMEKIT_DEBUG=1 clean
}

# Build
_clean() {
  # docker run -it --rm -v $(pwd):/project -w /project "$@" esp-rtos make -C . ESPPORT="$PORT" FLASH_SIZE=8 HOMEKIT_SPI_FLASH_BASE_ADDR=0x8c000 HOMEKIT_DEBUG=1 all
  docker run -it --rm -v $(pwd):/project -w /project "$@" esp-rtos make -C . ESPPORT=/dev/cu.usbserial-1410 FLASH_SIZE=8 HOMEKIT_SPI_FLASH_BASE_ADDR=0x8c000 HOMEKIT_DEBUG=1 all
}

_flash() {
  printf "\nesptool.py -p $PORT --baud 115200 write_flash -fs $MEMORY -fm dout -ff 40m 0x0 firmware_prebuilt/rboot.bin 0x1000 firmware_prebuilt/blank_config.bin 0x2000 firmware_prebuilt/otaboot.bin;\n"
  esptool.py -p $PORT --baud 115200 write_flash -fs $MEMORY -fm dout -ff 40m 0x0 firmware_prebuilt/rboot.bin 0x1000 firmware_prebuilt/blank_config.bin 0x2000 firmware_prebuilt/otaboot.bin;
}

_debug() {
  printf "\ndocker run -it --rm -v $(pwd):/project -w /project "$@" esp-rtos make -C . ESPPORT=$PORT FLASH_SIZE=$FLASH_SIZE HOMEKIT_SPI_FLASH_BASE_ADDR=$ADDR HOMEKIT_DEBUG=1 clean\n"
}

eval _$ACTION
