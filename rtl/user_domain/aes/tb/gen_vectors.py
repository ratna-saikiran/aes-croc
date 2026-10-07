"""Write AES-128 test vectors (key plaintext ciphertext, hex per line) for tb_aes_core.

The first two are the worked examples in FIPS-197 (Appendix B and C.1); the rest are
random and checked against the `cryptography` library (OpenSSL).
"""
import os, sys
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

def enc(key, pt):
    e = Cipher(algorithms.AES(key), modes.ECB()).encryptor()
    return e.update(pt) + e.finalize()

vectors = [
    ("2b7e151628aed2a6abf7158809cf4f3c", "3243f6a8885a308d313198a2e0370734", "3925841d02dc09fbdc118597196a0b32"),
    ("000102030405060708090a0b0c0d0e0f", "00112233445566778899aabbccddeeff", "69c4e0d86a7b0430d8cdb78070b4c55a"),
]
for k, p, c in vectors:
    assert enc(bytes.fromhex(k), bytes.fromhex(p)).hex() == c
n = int(sys.argv[1]) if len(sys.argv) > 1 else 1000
for _ in range(n):
    k, p = os.urandom(16), os.urandom(16)
    vectors.append((k.hex(), p.hex(), enc(k, p).hex()))
with open("vectors.hex", "w") as f:
    for v in vectors:
        f.write("".join(v) + "\n")
print(f"wrote {len(vectors)} vectors")
