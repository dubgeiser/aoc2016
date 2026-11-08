package main

import "core:crypto/hash"
import "core:fmt"
import "core:strings"

import hd "aoc/digest"
import "aoc/input"

Hex_Digest :: [32]u8
CACHE: map[string][]u8
MD5 :: hash.Algorithm.Insecure_MD5

main :: proc() {
	salt := input.read_one_string() or_else ""
	index := -1
	hex_digest: Hex_Digest
	key_count := 0
	CACHE = make(map[string][]byte)
	defer delete(CACHE)

	// --[ Part 1
	for key_count < 64 {
		index += 1
		if is_key(salt, index, &hex_digest, 0) do key_count += 1
	}
	fmt.println(index)

	// --[ Part 2
	index = -1
	key_count = 0
	for key_count < 64 {
		index += 1
		if is_key(salt, index, &hex_digest, 2016) do key_count += 1
	}
	fmt.println(index)
}

is_key :: proc(
	salt: string,
	index: int,
	hex_digest: ^Hex_Digest,
	stretch: int,
) -> bool {

	hex_digest_create(salt, index, hex_digest, stretch)
	triplet_char := find_n_repeats_of(hex_digest, 3)

	if triplet_char != 0 {
		for i in 1 ..= 1000 {
			hex_digest_create(salt, index + i, hex_digest, stretch)
			quintet_char := find_n_repeats_of(hex_digest, 5, triplet_char)
			if quintet_char != 0 {
				return true
			}
		}
	}
	return false
}

hex_digest_create :: proc(
	salt: string,
	index: int,
	hex_digest: ^Hex_Digest,
	stretch: int,
) {
	seed := strings.concatenate({salt, fmt.tprint(index)})
	cache_key := strings.concatenate({seed, fmt.tprint(stretch)})

	if cache_key in CACHE {
		hd.copy_to_hex_digest(CACHE[cache_key], hex_digest)
		return
	}

	// Store first hash (of salt + index) as stretch 0, so cache check above
	// can find it.
	digest := hash.hash_string(MD5, seed)
	CACHE[strings.concatenate({seed, fmt.tprint(0)})] = digest
	hd.copy_to_hex_digest(digest, hex_digest)

	for i in 1 ..= stretch {
		digest = hash.hash_string(MD5, string(hex_digest^[:]))
		hd.copy_to_hex_digest(digest, hex_digest)
	}
	CACHE[cache_key] = digest
}

// Find the first occurrence where char repeats itself n times.
// If no char is given, search for the first char that repeats n times.
// Return the found char, or `0` if nothing found.
find_n_repeats_of :: proc(
	hex_digest: ^Hex_Digest,
	n: int,
	char: u8 = 0,
) -> u8 {
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
