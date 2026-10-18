package main

import "core:fmt"
import "core:strconv"
import "core:strings"

import "aoc"

SCREEN_WIDTH :: 50
SCREEN_HEIGHT :: 6

Screen :: [SCREEN_HEIGHT][SCREEN_WIDTH]int

print_screen :: proc(screen: ^Screen) {
	for r := 0; r < SCREEN_HEIGHT; r += 1 {
		for c := 0; c < SCREEN_WIDTH; c += 1 {
			c := screen[r][c] == 1 ? "#" : " "
			fmt.printf("%s", c)
		}
		fmt.printf("\n")
	}
}

/*
`rect AxB` turns on all of the pixels in a rectangle at the top-left of the
screen which is A wide and B tall.
*/
rect :: proc(screen: ^Screen, w, h: int) {
	for r := 0; r < h; r += 1 {
		for c := 0; c < w; c += 1 {
			screen[r][c] = 1
		}
	}
}

/*
`rotate row y=A by B` shifts all of the pixels in row A (0 is the top row)
right by B pixels. Pixels that would fall off the right end appear at the left
end of the row.

Rotating right can be done by creating a new array and then copying over the
elements to their destination index in that array.

Given a row `a` and a new array `b` of same type, calculating the destination
index can be done with

	`b[(i + k) mod n] = a[i]`

	(`b[i] = a[(i + k) mod n]` for rotating left)

*/
rotate_row :: proc(screen: ^Screen, i, d: int) {
	rr := [SCREEN_WIDTH]int{}
	for c := 0; c < SCREEN_WIDTH; c += 1 {
		rr[(c + d) % SCREEN_WIDTH] = screen[i][c]
	}
	screen[i] = rr
}

/*
`rotate column x=A by B` shifts all of the pixels in column A (0 is the left
column) down by B pixels. Pixels that would fall off the bottom appear at the
top of the column.

Rotating downwards is the same as rotating right
See `rotate_row` proc for explanation.
*/
rotate_col :: proc(screen: ^Screen, i, d: int) {
	cc := [SCREEN_HEIGHT]int{}
	for r := 0; r < SCREEN_HEIGHT; r += 1 {
		cc[(r + d) % SCREEN_HEIGHT] = screen[r][i]
	}
	// Cannot simply assign a column, so set elements one by one
	for r := 0; r < SCREEN_HEIGHT; r += 1 {
		screen[r][i] = cc[r]
	}
}

count_pixels :: proc(screen: ^Screen) -> int {
	count := 0
	for r := 0; r < SCREEN_HEIGHT; r += 1 {
		for c := 0; c < SCREEN_WIDTH; c += 1 {
			count += screen[r][c]
		}
	}
	return count
}

parse_command :: proc(line, prefix, split_s: string) -> (int, int) {
	parts := strings.split(line[len(prefix):], split_s)
	n1, _ := strconv.parse_int(parts[0])
	n2, _ := strconv.parse_int(parts[1])
	return n1, n2
}

main :: proc() {
	lines, _ := aoc.read_lines()
	screen := Screen{}
	part1 := 0
	for line in lines {
		if strings.starts_with(line, "rect ") {
			// `rect AxB`
			w, h := parse_command(line, "rect ", "x")
			rect(&screen, w, h)
		} else if strings.starts_with(line, "rotate row") {
			// rotate row y=A by B
			y, dy := parse_command(line, "rotate row y=", " by ")
			rotate_row(&screen, y, dy)
		} else if strings.starts_with(line, "rotate column") {
			// rotate column x=A by B
			x, dx := parse_command(line, "rotate column x=", " by ")
			rotate_col(&screen, x, dx)
		} else {
			assert(true == false, "unknown command")
		}
	}
	part1 = count_pixels(&screen)
	fmt.println(part1)
	// part 2, Read output!
	print_screen(&screen)
}
