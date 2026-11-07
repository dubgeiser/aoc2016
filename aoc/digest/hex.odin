package digest

DIGITS := "0123456789abcdef"

Digest :: []u8
Hex_Digest :: [32]u8

// Copy hexadecimal representation of given Digest into
// `hex_digest`.
copy_to_hex_digest :: proc(digest: Digest, hex_digest: ^Hex_Digest) {
	for b, i in digest {
		hex_digest[i * 2] = DIGITS[int(b >> 4)]
		hex_digest[i * 2 + 1] = DIGITS[int(b & 0x0f)]
	}
}
