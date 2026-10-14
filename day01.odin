package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import "core:strings"

// Distance on X/Y axis when travelling
// N, E, S, W respectively
DX := [4]int{0, 1, 0, -1}
DY := [4]int{1, 0, -1, 0}

do_turn :: proc(turn: string, facing: int) -> int {
	return turn == "L" ? (facing + 3) % 4 : (facing + 1) % 4
}

part1 :: proc(moves: []string) -> int {
	x, y := 0, 0
	facing := 0
	for move in moves {
		facing = do_turn(move[:1], facing)
		d, _ := strconv.parse_int(move[1:])
		x += d * DX[facing]
		y += d * DY[facing]
	}
	return math.abs(x) + math.abs(y)
}

// Don't know yet re. Odin generics...
Visited_Positions :: map[[2]int]bool
Pos :: [2]int

part2 :: proc(moves: []string) -> int {
	x, y := 0, 0
	facing := 0
	visited := &Visited_Positions{}
	visited[{x,y}] = true
	for move in moves {
		facing = do_turn(move[:1], facing)
		d, _ := strconv.parse_int(move[1:])
		for i := 0; i < d; i += 1 {
			x += DX[facing]
			y += DY[facing]
			if visited[{x,y}] {
				return math.abs(x) + math.abs(y)
			}
			visited[{x, y}] = true
		}
	}
	assert(true == false, "We're supposed to re-visit a certain position!!")
	return -1
}

main :: proc() {
	data, err := os.read_entire_file(os.stdin, context.allocator)
	if err != nil {
		fmt.eprintfln("[%s] Did you supplied via STDIN?", err)
	}
	moves := strings.split(string(data), ", ")
	defer delete(moves)
	fmt.println(part1(moves))
	fmt.println(part2(moves))
}
