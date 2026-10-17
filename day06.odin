package main

import "core:fmt"

import "aoc"

Frequency_Map :: map[u8]int

max_occurrences :: proc(freqmap: Frequency_Map) -> u8 {
	letter: u8
	max := 0
	for k, v in freqmap {
		if v > max {
			letter = k
			max = v
		}
	}
	return letter
}

main :: proc() {
	part1 := 0
	lines, _ := aoc.read_lines()
	R, C := len(lines), len(lines[0])
	cmax := make([dynamic]u8, C, C)
	defer delete(cmax)
	for c := 0; c < C; c += 1 {
		freqmap := make(Frequency_Map, context.allocator)
		for r := 0; r < R; r += 1 {
			freqmap[lines[r][c]] += 1
		}
		cmax[c] = max_occurrences(freqmap)
	}
	fmt.println(string(cmax[:]))
}
