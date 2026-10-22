#+feature dynamic-literals
package main

import "core:fmt"
import "core:os"
import "core:strings"

import input "aoc/input"

// A Keypad maps a key to all its possible "outs".
Keypad :: map[string]map[rune]string
KEYPAD_1 := Keypad {
	"1" = {'R' = "2", 'D' = "4"},
	"2" = {'R' = "3", 'D' = "6", 'L' = "1"},
	"3" = {'D' = "6", 'L' = "2"},
	"4" = {'U' = "1", 'R' = "5"},
	"5" = {'U' = "2", 'R' = "6", 'D' = "8", 'L' = "4"},
	"6" = {'U' = "3", 'D' = "9", 'L' = "5"},
	"7" = {'U' = "4", 'R' = "8"},
	"8" = {'U' = "5", 'R' = "9", 'L' = "7"},
	"9" = {'U' = "6", 'R' = "8"},
}
KEYPAD_2 := Keypad {
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

do_move :: proc(keypad: Keypad, key: string, move: rune) -> string {
	if key in keypad && move in keypad[key] {
		return keypad[key][move]
	}
	return key
}

main :: proc() {
	part1 := ""
	part2 := ""
	defer delete(part1)
	defer delete(part2)
	lines, _ := input.read_lines()
	defer delete(lines)

	// Start at key "5"
	curr1, curr2 := "5", "5"

	for line in lines {
		for move in line {
			curr1 = do_move(KEYPAD_1, curr1, move)
			curr2 = do_move(KEYPAD_2, curr2, move)
		}
		part1 = strings.concatenate({part1, curr1})
		part2 = strings.concatenate({part2, curr2})
	}
	fmt.println(part1)
	fmt.println(part2)
}
