# esp-8266-dht22-homekit
Open source FreeRTOS Firmware for ESP8266 and DHT22 sensor with Apple HomeKit support (OTA)

This project uses the Apple HomeKit accessory server library [ESP-HomeKit](https://github.com/maximkulkin/esp-homekit) from [@MaximKulkin](https://github.com/maximkulkin) for [ESP-OPEN-RTOS](https://github.com/SuperHouse/esp-open-rtos). And it uses the OTA update system [Life-Cycle-Manager (LCM)](https://github.com/HomeACcessoryKid/life-cycle-manager) from [@HomeACessoryKid](https://github.com/HomeACcessoryKid).

Although already forbidden by the sources and subsequent licensing, it is not allowed to use or distribute this software for a commercial purpose.

## Instructions
[esp-homekit build instructions](https://github.com/maximkulkin/esp-homekit-demo/wiki/Build-instructions-ESP8266)  
[Step-by-step esp-homekit SDK flash instructions](https://www.studiopieters.nl/esp-homekit-sdk-flash)  

### Clone esp-open-rtos SDK
```bash
git clone --recursive https://github.com/SuperHouse/esp-open-rtos.git
```

### Setup environment variables
```bash
export SDK_PATH=`pwd`/esp-open-rtos;
export ESPPORT=/dev/cu.usbserial-1410;
export FLASH_SIZE=8;
export HOMEKIT_SPI_FLASH_BASE_ADDR=0x7a000;
export HOMEKIT_DEBUG=1;
```

### Install esp-open-rtos and life-cycle-manager firmware
Erase flash:  
```bash
esptool.py -p /dev/cu.usbserial-1410 --baud 115200 erase_flash;
```
Flash the new firmware:  
```bash
esptool.py -p /dev/cu.usbserial-1410 --baud 115200 write_flash -fs 1MB -fm dout -ff 40m 0x0 firmware_prebuilt/rboot.bin 0x1000 firmware_prebuilt/blank_config.bin 0x2000 firmware_prebuilt/otaboot.bin;
```


### Build firmware
```bash
docker-run esp-rtos make -C . ESPPORT=/dev/cu.usbserial-1410 FLASH_SIZE=8 HOMEKIT_SPI_FLASH_BASE_ADDR=0x8c000 HOMEKIT_DEBUG=1 clean
docker-run esp-rtos make -C . ESPPORT=/dev/cu.usbserial-1410 FLASH_SIZE=8 HOMEKIT_SPI_FLASH_BASE_ADDR=0x8c000 HOMEKIT_DEBUG=1 all
```

### Sign firmware
```bash
sh signing.sh
```

### Release firmware
```bash
echo "Sign firmware"
echo "Upload to GitHub and create new release!"
```

### Debug
```bash
screen /dev/cu.usbserial-1410 115200 –L
```

### Install firmware manually
- Connect to WiFi SSID with `LCM-`` prefix
- Visit `http://192.168.4.1`
- Choose your WiFi access point
- Enter WiFi AC password
- Enter OTA repository: `vlewin/esp-8266-dht22-homekit`
- Enter OTA binary: `main.bin`
- Click `JOIN`

### TODO
[ ] Update LSM [firmware](https://github.com/HomeACcessoryKid/ota/releases/download/0.3.0/otaboot.bin)  
[ ] Enable OTA firmware update
