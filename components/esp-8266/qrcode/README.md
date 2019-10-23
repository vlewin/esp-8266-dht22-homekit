esp-qrcode
==========

Library for [ESP-OPEN-RTOS](https://github.com/SuperHouse/esp-open-rtos)
for QR code generation.

```c
char myData[] = "http://example.com";

QRCode qrcode;

uint8_t *qrcodeBytes = malloc(qrcode_getBufferSize(QRCODE_VERSION));
qrcode_initText(&qrcode, qrcodeBytes, QRCODE_VERSION, ECC_MEDIUM, myData);

qrcode_print(&qrcode);  // print on console

free(qrcodeBytes);
```

License
=======

MIT licensed. See the bundled [LICENSE](https://github.com/maximkulkin/esp-qrcode/blob/master/LICENSE) file for more details.
