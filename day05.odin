package main

import "core:crypto/hash"
import "core:fmt"
import "core:os"
import "core:strconv"

import "aoc"

generate_pass :: proc(prefix: string, n: int) -> string {
	// Buffer for storing the hash to try.
	// 20 digits for the index counter should be enough :fingerscrossed:
	// Add byte for `write_uint`.
	candidate_buf := make([]u8, len(prefix) + 21)
	defer delete(candidate_buf)
	copy(candidate_buf[:len(prefix)], transmute([]u8)prefix)
	// Store result of `hash_string_to_buffer`
	digest: [16]u8
	// Buffer for storing the found hexadecimal hash.
	// This will avoid allocating a new string for the digests.
	hex_buf: [32]u8
	hex_digits := "0123456789abcdef"
	pass := [dynamic]u8{}
	for i: u64 = 0; len(pass) < n; i += 1 {
		suffix := strconv.write_uint(candidate_buf[len(prefix):], i, 10)
		candidate := string(candidate_buf[:len(prefix) + len(suffix)])
		hash.hash_string_to_buffer(hash.Algorithm.Insecure_MD5, candidate, digest[:])

		// 5 leading hex 0's means first 20bits are 0
		if digest[0] == 0 && digest[1] == 0 && (digest[2] & 0xf0) == 0 {
			for b, j in digest {
				hex_buf[j * 2] = hex_digits[int(b >> 4)]
				hex_buf[j * 2 + 1] = hex_digits[int(b & 0x0f)]
			}
			append(&pass, hex_buf[5])
		}
	}
	return string(pass[:])
}

main :: proc() {
	lines, _ := aoc.read_lines()
	part1 := generate_pass(lines[0], 8)
	fmt.println(part1)
}
