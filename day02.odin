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

// This maps the keys and their "outs"
KEYPAD_2 := map[string]map[rune]string {
	"1" = {'D' = "3"},
	"2" = {'R' = "3", 'D' = "6"},
	"3" = {'U' = "1", 'R' = "4", 'D' = "7", 'L' = "2"},
	"4" = {'L' = "3", 'D' = "8"},
	"5" = {'R' = "6"},
	"6" = {'U' = "2", 'R' = "7", 'D' = "A", 'L' = "5"},
	"7" = {'U' = "3", 'R' = "8", 'D' = "B", 'L' = "6"},
	"8" = {'U' = "4", 'R' = "9", 'D' = "C", 'L' = "7"},
	"9" = {'L' = "8"},
	"A" = {'U' = "6", 'R' = "B"},
	"B" = {'U' = "7", 'R' = "C", 'D' = "D", 'L' = "A"},
	"C" = {'U' = "8", 'L' = "B"},
	"D" = {'U' = "B"},
}

move_p1 :: proc(pos: [2]int, move: rune) -> [2]int {
	curr_key := pos
	dx := DXY[move][0] + curr_key[0]
	dy := DXY[move][1] + curr_key[1]
	if dx >= -1 && dx <= 1 && dy >= -1 && dy <= 1 {
		curr_key = {dx, dy}
	}
	return curr_key
}

move_p2 :: proc(key: string, move: rune) -> string {
	if key in KEYPAD_2 && move in KEYPAD_2[key]{
		return KEYPAD_2[key][move]
	}
	return key
}

main :: proc() {
	part1 := ""
	part2 := ""
	defer delete(part1)
	defer delete(part2)
	lines, _ := aoc.read_lines()
	defer delete(lines)

	// Start at the "5" key
	curr1 := [2]int{0, 0}
	curr2 := "5"

	for line in lines {
		for move in line {
			curr1 = move_p1(curr1, move)
			curr2 = move_p2(curr2, move)
		}
		part1 = strings.concatenate({part1, KEYPAD[curr1]})
		part2 = strings.concatenate({part2, curr2})
	}
	fmt.println(part1)
	fmt.println(part2)
}
