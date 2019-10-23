#include <stdio.h>
#include <stdint.h>
#include "qrcode.h"


void qrcode_print(const QRCode *qrcode) {
    printf("\x1b[1;47m  ");
    for (uint8_t x = 0; x < qrcode->size; x++)
        printf("  ");
    printf("  \x1b[0m\n");

    for (uint8_t y = 0; y < qrcode->size; y++) {
      printf("\x1b[1;47m  \x1b[40m");
      for (uint8_t x = 0; x < qrcode->size; x++) {
          if (qrcode_getModule((QRCode *)qrcode, x, y)) {
              printf("  ");
          } else {
              printf("\x1b[1;47m  \x1b[40m");
          }
      }
      printf("\x1b[1;47m  \x1b[0m\n");
    }

    printf("\x1b[1;47m  ");
    for (uint8_t x = 0; x < qrcode->size; x++)
        printf("  ");
    printf("  \x1b[0m\n");
}
