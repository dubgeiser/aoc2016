package main

import "aoc"
import "core:fmt"
import "core:strconv"
import "core:strings"

main :: proc() {
	part1 := 0
	lines, _ := aoc.read_lines()
	for line in lines {
		n: [3]int
		ns, _ := strings.split(line, " ")
		i := 0
		for s in ns {
			if strings.trim_space(s) == "" {
				continue
			}
			n[i], _ = strconv.parse_int(strings.trim_space(s))
			i += 1
		}
		if n[0] + n[1] > n[2] \
			&& n[0] + n[2] > n[1] \
			&& n[1] + n[2] > n[0] {
				part1 += 1
			}
	}
	fmt.println(part1)
}
