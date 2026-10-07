// AES-128 encryption accelerator in the Croc user domain (rtl/user_domain/aes).

#pragma once

#include <stdint.h>

#define AES_CTRL_OFFSET     0x00
#define AES_STATUS_OFFSET   0x04
#define AES_KEY_OFFSET      0x10
#define AES_DIN_OFFSET      0x20
#define AES_DOUT_OFFSET     0x30

#define AES_CTRL_START_BIT  0
#define AES_STATUS_BUSY_BIT 0
#define AES_STATUS_DONE_BIT 1

// Load a 16-byte key; it stays loaded for every following block.
void aes_set_key(const uint8_t key[16]);
// Start encrypting one block and return without waiting.
void aes_start(const uint8_t in[16]);
// 1 once the block started by aes_start has finished.
int aes_done();
// Copy the ciphertext of the last finished block.
void aes_read(uint8_t out[16]);
// Encrypt one block, waiting for the result.
void aes_encrypt_block(const uint8_t in[16], uint8_t out[16]);
