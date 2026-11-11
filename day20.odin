package main

import ba "core:container/bit_array"
import "core:fmt"
import "core:slice"
import "core:sort"
import "core:strconv"
import "core:strings"

import "aoc/input"

/*
We know that there's a 0-xxx in the input.
Sorting the list by the low value of the range makes things easier, because
then we can start with [0-h] range, where h will be the current highest value,
and thus h+1 the current lowest free IP.

	Read the first line -> first l, h range
	for subsequent elements from the list (ll, hh)
		if h+1 < ll: break (Found the smallest free IP, i.e. h+1)
		h=max(h, hh)

h+1 is lowest IP

For instance the sample:
0-2
4-7
5-8

	l, h := 0, 2
		4, 7: 2+1<4: yes, break

h + 1 -> 3

Some extra range:
0-2
3-6
4-7
5-8

	l, h := 0, 2
		3, 6: 2+1<3: no, h = max(h, 6), h = 6
		4, 7: 6+1<4: no, h = max(h, 7), h = 7
		5, 8: 7+1<5: no, h = max(h, 8), h = 8

h + 1 -> 9
*/

MAX_IP :: 4294967295

Range :: [2]int

main :: proc() {
	lines := input.read_lines() or_else {""}
	defer delete(lines)

	ranges := make([dynamic]Range)
	defer delete(ranges)

	for line in lines {
		append(&ranges, parse_line(line))
	}

	slice.sort_by(
		ranges[:],
		proc(r1, r2: Range) -> bool {return r1[0] < r2[0]},
	)

	l, h := ranges[0][0], ranges[0][1]
	for rr in ranges[1:] {
		ll, hh := rr[0], rr[1]
		if h + 1 < ll do break
		h = max(h, hh)
	}
	fmt.println(h + 1)

	// Part 2
	// Count the free IP in the "holes" and add (MAX_IP - h) to it
	l, h = ranges[0][0], ranges[0][1]
	free := 0
	for rr in ranges[1:] {
		ll, hh := rr[0], rr[1]
		if h + 1 < ll {
			free += ll - h - 1
		}
		h = max(h, hh)
	}
	free += MAX_IP - h
	fmt.println(free)
}

@(private = "file")
parse_line :: proc(line: string) -> Range {
	parts := strings.split(line, "-")
	defer delete(parts)
	return Range {
		strconv.parse_int(parts[0]) or_else 0,
		strconv.parse_int(parts[1]) or_else 0,
	}
}
