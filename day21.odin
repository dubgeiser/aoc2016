#+feature dynamic-literals
package main

import "core:bytes"
import "core:fmt"
import "core:slice"
import "core:strings"

import "aoc/input"

main :: proc() {
	lines := input.read_lines() or_else {}
	defer delete(lines)

	s := [dynamic]u8{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}

	for line in lines {
		tokens := strings.split(line, " ")
		switch tokens[0] {
		case "swap":
			switch tokens[1] {
			case "position":
				// swap position <i> with position <j>
				// 0    1         2   3     4       5
				i, j := tokens[2][0] - 48, tokens[5][0] - 48
				s[i], s[j] = s[j], s[i]
			case "letter":
				// swap letter <a> with letter <b>
				// 0    1       2  3     4      5
				a, b := tokens[2][0], tokens[5][0]
				for i in 0 ..< len(s) {
					if s[i] == a do s[i] = b
					else if s[i] == b do s[i] = a
				}
			case:
				fmt.println("ERROR: Unknown swap:", tokens[1])
			}

		case "rotate":
			// rotate lef|right <r> steps
			//  0        1       2    3
			rotate: int
			if tokens[1] == "left" {
				rotate = -int(tokens[2][0] - 48)
			} else if tokens[1] == "right" {
				rotate = int(tokens[2][0] - 48)
			} else if tokens[1] == "based" {
				// rotate based on position of letter <a>
				//   0      1   2     3      4   5     6
				rotate = bytes.index_byte(s[:], tokens[6][0])
				if rotate >= 4 do rotate += 1
				rotate += 1
			} else {
				fmt.println("ERROR: Unknown rotation:", tokens[1])
			}
			rotate = rotate % len(s)
			if rotate == 0 do break
			if rotate < 0 {
				rotate = -rotate
				temp := slice.clone(s[:rotate])
				remove_range_dynamic_array(&s, 0, rotate)
				append(&s, ..temp)
			} else {
				temp := slice.clone(s[len(s) - rotate:])
				remove_range_dynamic_array(&s, len(s) - len(temp), len(s))
				for i := len(temp) - 1; i >= 0; i -= 1 do inject_at(&s, 0, temp[i])
			}

		case "reverse":
			// remove positions <i> through <j>
			//  0      1         2    3      4
			i, j := tokens[2][0] - 48, tokens[4][0] - 48
			for k in 0 ..= (j - i) / 2 do s[i + k], s[j - k] = s[j - k], s[i + k]

		case "move":
			// move position <i> to position <j>
			//  0    1        2   3    4      5
			i, j := tokens[2][0] - 48, tokens[5][0] - 48
			temp := s[i]
			ordered_remove(&s, i)
			inject_at(&s, j, temp)

		case:
			fmt.println("ERROR: Unknown command:", tokens[0])
		}
	}
	fmt.printf("%s", s)
}
