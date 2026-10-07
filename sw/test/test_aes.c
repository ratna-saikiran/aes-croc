// Checks the AES-128 accelerator against the FIPS-197 worked examples
// (Appendix B and C.1) and prints the cycle count per block.

#include "uart.h"
#include "print.h"
#include "util.h"
#include "aes.h"
#include "config.h"

static const uint8_t key_b[16] = {0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6,
                                  0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c};
static const uint8_t pt_b[16]  = {0x32, 0x43, 0xf6, 0xa8, 0x88, 0x5a, 0x30, 0x8d,
                                  0x31, 0x31, 0x98, 0xa2, 0xe0, 0x37, 0x07, 0x34};
static const uint8_t ct_b[16]  = {0x39, 0x25, 0x84, 0x1d, 0x02, 0xdc, 0x09, 0xfb,
                                  0xdc, 0x11, 0x85, 0x97, 0x19, 0x6a, 0x0b, 0x32};

static const uint8_t key_c[16] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
                                  0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f};
static const uint8_t pt_c[16]  = {0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77,
                                  0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff};
static const uint8_t ct_c[16]  = {0x69, 0xc4, 0xe0, 0xd8, 0x6a, 0x7b, 0x04, 0x30,
                                  0xd8, 0xcd, 0xb7, 0x80, 0x70, 0xb4, 0xc5, 0x5a};

static int same(const uint8_t *a, const uint8_t *b) {
    for (int i = 0; i < 16; i++)
        if (a[i] != b[i]) return 0;
    return 1;
}

static void print_block(const uint8_t *b) {
    for (int i = 0; i < 16; i++) printf("%x", b[i]);
    printf("\n");
}

int main() {
    uint8_t out[16];
    uart_init();

    aes_set_key(key_b);
    uint32_t t0 = (uint32_t)get_mcycle();
    aes_encrypt_block(pt_b, out);
    uint32_t t1 = (uint32_t)get_mcycle();
    printf("AES FIPS-197 B: ");
    print_block(out);
    uart_write_flush();
    CHECK_ASSERT(1, same(out, ct_b));

    aes_set_key(key_c);
    aes_encrypt_block(pt_c, out);
    printf("AES FIPS-197 C.1: ");
    print_block(out);
    uart_write_flush();
    CHECK_ASSERT(2, same(out, ct_c));

    printf("AES ok, %x cycles per block incl. driver\n", t1 - t0);
    uart_write_flush();
    return 0;
}
