package main

import "core:crypto/hash"
import "core:fmt"
import "core:strings"

import "aoc/input"

Hex_Digest :: [32]u8

HEX_DIGITS := "0123456789abcdef"

main :: proc() {
	salt := input.read_one_string() or_else ""
	index := 0
	hex_digest: Hex_Digest
	key_count := 0
	for key_count < 64 {
		hex_digest_create(salt, index, &hex_digest)
		triplet_char := find_n_repeats_of(hex_digest, 3)

		if triplet_char != 0 {
			for i in 1 ..= 1000 {
				hex_digest_create(salt, index + i, &hex_digest)
				quintet_char := find_n_repeats_of(hex_digest, 5, triplet_char)
				if quintet_char != 0 {
					key_count += 1
					break
				}
			}
		}
		index += 1
	}
	// -1 because index will be incremented also when key_count is already 64!
	fmt.println(index-1)
}

hex_digest_create :: proc(salt: string, index: int, buf: ^Hex_Digest) {
	digest := hash.hash_string(
		hash.Algorithm.Insecure_MD5,
		strings.concatenate({salt, fmt.tprint(index)}),
	)
	defer delete(digest)
	for b, i in digest {
		buf[i * 2] = HEX_DIGITS[int(b >> 4)]
		buf[i * 2 + 1] = HEX_DIGITS[int(b & 0x0f)]
	}
}

// Find the first occurrence where char repeats itself n times.
// If no char is given, search for the first char that repeats n times.
// Return the found char, or `0` if nothing found.
find_n_repeats_of :: proc(hex_digest: Hex_Digest, n: int, char: u8 = 0) -> u8 {
	found: bool
	for i in 0 ..= len(hex_digest) - n {
		if char != 0 && char != hex_digest[i] do continue
		found = true
		for j in 1 ..< n {
			found = found && (hex_digest[i] == hex_digest[i + j])
			if j == n - 1 && found do return hex_digest[i]
		}
	}
	return 0
}
