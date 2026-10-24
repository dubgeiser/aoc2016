package main

import "core:fmt"
import "core:strconv"
import "core:strings"

import "aoc/input"


main :: proc() {
	lines := input.read_lines() or_else []string{}
	defer delete(lines)
	size := strconv.parse_int(lines[0]) or_else 0
	state := lines[1]

	b := strings.builder_make()
	defer strings.builder_destroy(&b)

	state = reverse_and_toggle(state, &b, size)
	fmt.println(checksum(state[:size], &b))
}

reverse_and_toggle :: proc(initial_state: string, b: ^strings.Builder, size: int) -> string {
	state := initial_state
	for len(state) < size {
		for i := len(state) - 1; i >= 0; i -= 1 {
			strings.write_byte(b, state[i] == '0' ? '1' : '0')
		}
		// Might be "better" to use a builder from the get go, and just write to it?
		state = strings.concatenate({state, "0", string(b.buf[:])})
		strings.builder_reset(b)
	}
	return state
}

checksum :: proc(initial_state: string, b: ^strings.Builder) -> string {
	state := initial_state
	for {
		for i := 0; i < len(state) - 1; i += 2 {
			strings.write_byte(b, state[i] == state[i + 1] ? '1' : '0')
		}
		if len(b.buf) % 2 != 0 {
			return string(b.buf[:])
		}
		state = string(b.buf[:])
		strings.builder_reset(b)
	}
}
