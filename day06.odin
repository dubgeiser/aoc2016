package main

import "core:fmt"

import input "aoc/input"

Frequency_Map :: map[u8]int

least_most_occurring_letters :: proc(freqmap: Frequency_Map) -> (u8, u8) {
	min_letter, max_letter: u8
	min, max := 1000, 0
	for k, v in freqmap {
		if v < min {
			min_letter = k
			min = v
		}
		if v > max {
			max_letter = k
			max = v
		}
	}
	return min_letter, max_letter
}

main :: proc() {
	part1 := 0
	lines, _ := input.read_lines()
	R, C := len(lines), len(lines[0])
	cmax := make([dynamic]u8, C, C)
	defer delete(cmax)
	cmin := make([dynamic]u8, C, C)
	defer delete(cmin)
	for c := 0; c < C; c += 1 {
		freqmap := make(Frequency_Map, context.allocator)
		for r := 0; r < R; r += 1 {
			freqmap[lines[r][c]] += 1
		}
		cmin[c], cmax[c] = least_most_occurring_letters(freqmap)
	}
	fmt.println(string(cmax[:]))
	fmt.println(string(cmin[:]))
}
