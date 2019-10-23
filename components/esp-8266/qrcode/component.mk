INC_DIRS += $(qrcode_ROOT)

qrcode_INC_DIR = $(qrcode_ROOT)/QRCode/src
qrcode_SRC_DIR = $(qrcode_ROOT) $(qrcode_ROOT)/QRCode/src

$(eval $(call component_compile_rules,qrcode))
