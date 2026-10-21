package main

import "aoc"
import "core:fmt"
import "core:strconv"
import "core:strings"


len_decompressed :: proc(input: ^string, we_must_recurse: bool = false) -> int {
	count := 0
	compressed := input^
	for len(compressed) > 0 {
		// Consume chars until opening `(` is encountered.
		if compressed[0] != '(' {
			count += 1
			compressed = compressed[1:]
			continue
		}
		// take A (`char_count`) and B (`repeat`) from `(AxB)` part
		end := strings.index_byte(compressed, ')')
		parts := strings.split(compressed[1:end], "x")
		char_count, char_ok := strconv.parse_int(parts[0])
		ensure(char_ok)
		repeat, repeat_ok := strconv.parse_int(parts[1])
		ensure(repeat_ok)

		// Continue consuming after the `)`
		compressed = compressed[end + 1:]
		if we_must_recurse {
			// Don't change the original string in the recursion
			foo := compressed[:char_count]
			count += repeat * len_decompressed(&foo, true)
		} else {
			count += repeat * char_count
		}
		// Don't count string we repeated into account
		compressed = compressed[char_count:]
	}
	return count
}

main :: proc() {
	lines := aoc.read_lines() or_else []string{""}
	part1 := len_decompressed(&lines[0])
	part2 := len_decompressed(&lines[0], true)
	fmt.println(part1)
	fmt.println(part2)
}
