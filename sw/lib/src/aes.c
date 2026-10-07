// AES-128 encryption accelerator driver.

#include "aes.h"
#include "util.h"
#include "config.h"

// The registers take bytes little-endian within each word, so plain byte
// loads/stores keep the FIPS-197 byte order (and work on unaligned buffers).
static void write_words(int offs, const uint8_t b[16]) {
    for (int i = 0; i < 4; i++) {
        uint32_t w = (uint32_t)b[4 * i] | ((uint32_t)b[4 * i + 1] << 8) |
                     ((uint32_t)b[4 * i + 2] << 16) | ((uint32_t)b[4 * i + 3] << 24);
        *reg32(USER_AES_BASE_ADDR, offs + 4 * i) = w;
    }
}

void aes_set_key(const uint8_t key[16]) {
    write_words(AES_KEY_OFFSET, key);
}

void aes_start(const uint8_t in[16]) {
    write_words(AES_DIN_OFFSET, in);
    *reg32(USER_AES_BASE_ADDR, AES_CTRL_OFFSET) = 1 << AES_CTRL_START_BIT;
}

int aes_done() {
    return (*reg32(USER_AES_BASE_ADDR, AES_STATUS_OFFSET) >> AES_STATUS_DONE_BIT) & 1;
}

void aes_read(uint8_t out[16]) {
    for (int i = 0; i < 4; i++) {
        uint32_t w = *reg32(USER_AES_BASE_ADDR, AES_DOUT_OFFSET + 4 * i);
        out[4 * i]     = w & 0xff;
        out[4 * i + 1] = (w >> 8) & 0xff;
        out[4 * i + 2] = (w >> 16) & 0xff;
        out[4 * i + 3] = (w >> 24) & 0xff;
    }
}

void aes_encrypt_block(const uint8_t in[16], uint8_t out[16]) {
    aes_start(in);
    while (!aes_done())
        ;
    aes_read(out);
}
