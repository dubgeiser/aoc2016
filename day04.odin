package main

import "core:fmt"
import "core:slice"
import "core:sort"
import "core:strconv"
import "core:strings"

import "aoc"

parse_id_checksum :: proc(s: string) -> (uint, string) {
	// regexes ¯\_(ツ)_/¯
	parts := strings.split(s, "[")
	defer delete(parts)
	id, _ := strconv.parse_uint(parts[0])
	checksum := strings.trim_right(parts[1], "]")
	return id, checksum
}

parse_line :: proc(line: string) -> (string, uint, string) {
	parts := strings.split(line, "-")
	defer delete(parts)
	id, checksum := parse_id_checksum(slice.last(parts))
	assert(id < 1000)
	assert(len(checksum) == 5)
	room := strings.join(parts[:len(parts) - 1], "-")
	return room, id, checksum
}

Frequency :: struct {
	key:   u8,
	value: uint,
}

is_room :: proc(room: string, checksum_expected: string) -> bool {
	frequency_map := make(map[u8]uint)
	defer delete(frequency_map)
	for c in room {
		(c != '-') or_continue
		// Missing keys return the value's type zero value (0 for ints)
		frequency_map[u8(c)] += 1
	}

	frequencies: [dynamic]Frequency
	defer delete(frequencies)
	for key, value in frequency_map {
		append(&frequencies, {key, value})
	}
	// Compare values DESC, keys ASC (alphabetically)
	sort.quick_sort_proc(frequencies[:], proc(f1, f2: Frequency) -> int {
		if f1.value != f2.value {
			return sort.compare_uints(f2.value, f1.value)
		}
		return sort.compare_i32s(i32(f1.key), i32(f2.key))
	})
	checksum_calculated := [dynamic]u8{}
	defer delete(checksum_calculated)
	for f in frequencies[0:5] {
		append(&checksum_calculated, f.key)
	}

	return checksum_expected == string(checksum_calculated[:])
}

decrypt :: proc(room: string, id: uint) -> string {
	decrypted := [dynamic]u8{}
	defer delete(decrypted)
	shift := u8(id % 26)
	for i := 0; i < len(room); i += 1 {
		c: u8 = room[i]
		if 'a' <= c && c <= 'z' {
			append(&decrypted, (c - 'a' + shift) % 26 + 'a')
		} else {
			append(&decrypted, ' ')
		}
	}
	return string(decrypted[:])
}

main :: proc() {
	part1 := uint(0)
	part2 := uint(0)
	lines, _ := aoc.read_lines()
	defer delete(lines)
	for line in lines {
		room, id, checksum := parse_line(line)
		if is_room(room, checksum) {
			part1 += id
		}
		if decrypt(room, id) == "northpole object storage" {
			part2 = id
		}
	}
	fmt.println(part1)
	fmt.println(part2)
}
