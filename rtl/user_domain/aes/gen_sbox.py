"""Regenerate aes_sbox.sv from the GF(2^8) inverse + affine-map definition (FIPS-197 5.1.1)."""
import os

def mul(a, b):
    r = 0
    while b:
        if b & 1: r ^= a
        a = ((a << 1) ^ 0x11b) if a & 0x80 else a << 1
        b >>= 1
    return r

def inv(a):
    return 0 if a == 0 else next(x for x in range(1, 256) if mul(a, x) == 1)

def rotl(x, s):
    return ((x << s) | (x >> (8 - s))) & 0xff

sbox = []
for a in range(256):
    b = inv(a)
    sbox.append(b ^ rotl(b, 1) ^ rotl(b, 2) ^ rotl(b, 3) ^ rotl(b, 4) ^ 0x63)
assert sbox[0] == 0x63 and sbox[0x53] == 0xed

lines = "\n".join("      8'h%02x: out_o = 8'h%02x;" % (i, v) for i, v in enumerate(sbox))
src = """// AES S-box (FIPS-197 Figure 7) as a lookup table.
// Generated from the GF(2^8) inverse + affine transform definition.
module aes_sbox (
  input  logic [7:0] in_i,
  output logic [7:0] out_o
);
  always_comb begin
    unique case (in_i)
%s
      default: out_o = 8'h00;
    endcase
  end
endmodule
""" % lines
open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "aes_sbox.sv"), "w").write(src)
