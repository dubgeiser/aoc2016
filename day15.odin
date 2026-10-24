package main

import "core:fmt"
import "core:strconv"
import "core:strings"

import input "aoc/input"


Disc_Info :: [3]int

NR :: 0
LEN :: 1
POS :: 2

main :: proc() {
	discs := make([dynamic]Disc_Info)
	defer delete(discs)
	lines := input.read_lines() or_else []string{}
	nr := 1
	for line in lines {
		append(&discs, parse_disc(nr, line))
		nr += 1
	}

	// Part 1
	t := 0
	for t < 1_000_000 {
		if push(t, discs[:]) {
			fmt.println(t)
			break
		}
		t += 1
	}

	// Part 2
	append(&discs, Disc_Info{len(discs) + 1, 11, 0})
	t = 0
	for t < 1_000_000_000 {
		if push(t, discs[:]) {
			fmt.println(t)
			break
		}
		t += 1
	}
}

parse_disc :: proc(nr: int, line: string) -> Disc_Info {
	// "Disc #D has P positions; at time=0, it is at position p."
	//  0    1  2   3 4          5  6       7  8  9  10       11
	parts := strings.split(line, " ") or_else []string{}
	len := strconv.parse_int(parts[3]) or_else 0
	start := strconv.parse_int(parts[11][:1]) or_else 0
	return Disc_Info{nr, len, start}
}

push :: proc(t: int, discs: []Disc_Info) -> bool {
		zero_count := 0
		for &disc in discs {
			pos := (disc[POS] + disc[NR] + t) % disc[LEN]
			if pos == 0 {
				zero_count += 1
			}
		}
		return zero_count == len(discs)
}
