package main

import "core:container/queue"
import "core:fmt"
import "core:strconv"

import "aoc/input"

// {x, y}
Pos :: [2]int

// {x, y, steps}
Pos_Q :: struct {
	pos:   Pos,
	steps: int,
}

main :: proc() {
	lines := input.read_lines() or_else []string{}
	secret, _ := strconv.parse_int(lines[0])
	target := Pos{31, 39}
	steps := 0
	start := Pos{1, 1}
	q: queue.Queue(Pos_Q)
	queue.init(&q)
	defer queue.destroy(&q)
	queue.enqueue(&q, Pos_Q{start, 0})
	visited := make(map[Pos]struct{})
	defer delete(visited)
	visited[start] = {}
	max_steps_reached := false
	for queue.len(q) > 0 {
		curr := queue.dequeue(&q)
		if !max_steps_reached && curr.steps >= 50 {
			fmt.println("Part 2:", len(visited))
			max_steps_reached = true
		}
		if curr.pos == target {
			fmt.println("Part 1:", curr.steps)
			break
		}
		nbs := neighbors(curr.pos, secret)
		for nb in nbs {
			if nb in visited do continue
			visited[nb] = {}
			queue.enqueue(&q, Pos_Q{nb, curr.steps + 1})
		}
		delete(nbs)
	}
}

dirs := []Pos{{0, 1}, {1, 0}, {0, -1}, {-1, 0}}

neighbors :: proc(pos: Pos, secret: int) -> [dynamic]Pos {
	nbs := make([dynamic]Pos)
	for d in dirs {
		p := pos + d
		if valid(p, secret) do append(&nbs, p)
	}
	return nbs
}

valid :: proc(p: Pos, secret: int) -> bool {
	x, y := p[0], p[1]
	if x < 0 || y < 0 do return false

	// Find x*x + 3*x + 2*x*y + y + y*y.
	// Add the office designer's favorite number (your puzzle input).
	n := x * x + 3 * x + 2 * x * y + y + y * y + secret

	// Find the binary representation of that sum; count the number of bits that are 1.
	//

	//     If the number of bits that are 1 is even, it's an open space.
	//     If the number of bits that are 1 is odd, it's a wall.
	return (popcount(n) % 2) == 0
}

// "Kernighan's population count"
// Count the number of bits set.
// From notes re. https://www.youtube.com/watch?v=ZRNO-ewsNcQ
popcount :: proc(x: int) -> int {
	count := 0
	n := x
	for n != 0 {
		n = n & (n - 1)
		count += 1
	}
	return count
}
