PROGRAM = main

EXTRA_COMPONENTS = \
	extras/dht \
	extras/http-parser \
  extras/dhcpserver \
	extras/rboot-ota \
  $(abspath ./components/esp-8266/wifi_config) \
  $(abspath ./components/common/wolfssl) \
	$(abspath ./components/esp-8266/cJSON) \
  $(abspath ./components/common/homekit)

# DHT11 sensor pin
SENSOR_PIN ?= 2
ESPPORT = '/dev/cu.usbserial-1410'
FLASH_SIZE = 1MB

EXTRA_CFLAGS += -I../.. -DHOMEKIT_SHORT_APPLE_UUIDS -DSENSOR_PIN=$(SENSOR_PIN)
HOMEKIT_SPI_FLASH_BASE_ADDR=0x8c000

include $(SDK_PATH)/common.mk

monitor:
	$(FILTEROUTPUT) --port $(ESPPORT) --baud 115200 --elf $(PROGRAM_OUT)
