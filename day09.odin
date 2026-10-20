package main

import "aoc"
import "core:fmt"
import "core:strconv"
import "core:strings"


main :: proc() {
	part1 := 0
	lines := aoc.read_lines() or_else []string{""}
	compressed := lines[0]
	for len(compressed) > 0 {
		// Consume chars until opening `(` is encountered.
		if compressed[0] != '(' {
			part1 += 1
			compressed = compressed[1:]
			continue
		}
		// take A and B from `(AxB)` part
		end := strings.index_byte(compressed, ')')
		parts := strings.split(compressed[1:end], "x")
		char_count, char_ok := strconv.parse_int(parts[0])
		ensure(char_ok)
		repeat, repeat_ok := strconv.parse_int(parts[1])
		ensure(repeat_ok)

		// Continue consuming after the `)`
		compressed = compressed[end + 1:]
		part1 += repeat * char_count
		// Don't count string we repeated into account
		compressed = compressed[char_count:]
	}
	fmt.println(part1)
}
