#+feature dynamic-literals
package main

import "core:fmt"
import "core:os"
import "core:strings"

import "aoc"


DXY := map[rune][2]int {
	'U' = {0, 1},
	'D' = {0, -1},
	'L' = {-1, 0},
	'R' = {1, 0},
}

KEYPAD := map[[2]int]string {
	{-1, 1} = "1",
	{0, 1} = "2",
	{1, 1} = "3",
	{-1, 0} = "4",
	{0, 0} = "5",
	{1, 0} = "6",
	{-1, -1} = "7",
	{0, -1} = "8",
	{1, -1} = "9",
}

main :: proc() {
	part1 := ""
	defer delete(part1)
	lines, _ := aoc.read_lines()
	defer delete(lines)
	curr_key := [2]int{0, 0} // Start at 5
	for line in lines {
		for move in line {
			dx := DXY[move][0] + curr_key[0]
			dy := DXY[move][1] + curr_key[1]
			if dx >= -1 && dx <= 1 && dy >= -1 && dy <= 1 {
				curr_key = {dx, dy}
			}
		}
		part1 = strings.concatenate({part1, KEYPAD[curr_key]})
	}
	fmt.println(part1)
}
