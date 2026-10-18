package main

import "aoc"
import "core:fmt"
import "core:strconv"
import "core:strings"

is_triangle :: proc(sides: [3]int) -> bool {
	return(
		sides[0] + sides[1] > sides[2] &&
		sides[0] + sides[2] > sides[1] &&
		sides[1] + sides[2] > sides[0] \
	)
}

main :: proc() {
	triangles: [dynamic][3]int
	lines, _ := aoc.read_lines()
	for line in lines {
		n: [3]int
		ns, _ := strings.split(line, " ")
		i := 0
		for s in ns {
			(strings.trim_space(s) != "") or_continue
			n[i], _ = strconv.parse_int(strings.trim_space(s))
			i += 1
		}
		append(&triangles, n)
	}

	part1 := 0
	for n in triangles {
		if is_triangle(n) {
			part1 += 1
		}
	}
	fmt.println(part1)

	part2 := 0
	for x := 0; x < 3; x += 1 {
		for y := 0; y < len(triangles) - 2; y += 3 {
			n := [3]int{triangles[y][x], triangles[y + 1][x], triangles[y + 2][x]}
			if is_triangle(n) {
				part2 += 1
			}
		}
	}
	fmt.println(part2)
}
