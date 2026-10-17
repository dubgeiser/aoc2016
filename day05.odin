package main

import "core:crypto/hash"
import "core:fmt"
import "core:os"
import "core:strconv"

import "aoc"

HEX_DIGITS := "0123456789abcdef"

generate_pass :: proc(prefix: string, is_part2: bool = false) -> string {
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
	pass: [dynamic]u8
	// Set to keep track of indices already used in part2
	used := make(map[u8]struct{})
	if is_part2 {
		pass = make([dynamic]u8, 8, 8)
	} else {
		pass = make([dynamic]u8, 0, 8)
	}
	count := 0
	for i: u64 = 0; count < 8; i += 1 {
		suffix := strconv.write_uint(candidate_buf[len(prefix):], i, 10)
		candidate := string(candidate_buf[:len(prefix) + len(suffix)])
		hash.hash_string_to_buffer(hash.Algorithm.Insecure_MD5, candidate, digest[:])

		// 5 leading hex 0's means first 20bits are 0
		if digest[0] == 0 && digest[1] == 0 && (digest[2] & 0xf0) == 0 {
			for b, j in digest {
				hex_buf[j * 2] = HEX_DIGITS[int(b >> 4)]
				hex_buf[j * 2 + 1] = HEX_DIGITS[int(b & 0x0f)]
			}
			if is_part2 {
				pi := u8(hex_buf[5] - u8('0'))
				if pi > 7 || pi < 0 || pi in used {
					continue
				} else {
					pass[pi] = hex_buf[6]
					used[pi] = {}
				}
			} else {
				append(&pass, hex_buf[5])
			}
			count += 1
		}
	}
	return string(pass[:])
}

main :: proc() {
	lines, _ := aoc.read_lines()
	fmt.println(generate_pass(lines[0]))
	fmt.println(generate_pass(lines[0], true))
}
