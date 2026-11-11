package main

import "core:container/queue"
import "core:fmt"

// The floors where the generator/microchip pairs are.
// Made a fixed length array for easy comparison, but it's tied to the puzzle
// input size, so this needs to be changed when start State is different.
// ATM I cannot run sample/input easily next to each other.
State :: [14]int

// This data structure will be put on the queue, it takes the floor we're going
// to into account and the number of moves that was needed to get there.
Queue_Entry :: struct {
	elevator: int,   // The elevator is on the floor we moved to
	moves:    int,   // The number of moves we did to get there.
	state:    State, // The state of the generator/microchip pairs.
}

// For keeping an eye on the seen states, so we don't 'm twice.
// Since the order of (RTG/chip) pairs doesn't matter for BFS, it pays off to
// sort the state pair-wise before storing them into a set.
Seen_State :: struct {
	elevator: int,
	state:    State,
}

MIN_FLOOR :: 0
MAX_FLOOR :: 3

main :: proc() {
	// Sample input
	// ------------
	// The first floor contains a hydrogen-compatible microchip and a
	// 	lithium-compatible microchip.
	// The second floor contains a hydrogen generator.
	// The third floor contains a lithium generator.
	// The fourth floor contains nothing relevant.
	// start := State{1, 0, 2, 0}
	// end := State{3, 3, 3, 3}

	// Part1 input
	// -----------
	// The first floor contains a strontium generator, a strontium-compatible
	// 	microchip, a plutonium generator, and a plutonium-compatible microchip.
	// The second floor contains a thulium generator, a ruthenium generator, a
	// 	ruthenium-compatible microchip, a curium generator, and a
	// 	curium-compatible microchip.
	// The third floor contains a thulium-compatible microchip.
	// The fourth floor contains nothing relevant.
	// start := State{0, 0, 0, 0, 1, 2, 1, 1, 1, 1}
	// end := State{3, 3, 3, 3, 3, 3, 3, 3, 3, 3}

	// Part2 input
	// -----------
	// Addition elements on the first floor:
	//   - An elerium generator.
	//   - An elerium-compatible microchip.
	//   - A dilithium generator.
	//   - A dilithium-compatible microchip.
	start := State{0, 0, 0, 0, 1, 2, 1, 1, 1, 1, 0, 0, 0, 0}
	end := State{3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}

	q: queue.Queue(Queue_Entry)
	queue.init(&q)
	queue.enqueue(&q, Queue_Entry{0, 0, start})
	defer queue.destroy(&q)
	seen := make(map[Seen_State]struct{})
	defer delete(seen)
	seen[Seen_State{0, sorted(start)}] = {}
	for queue.len(q) > 0 {
		curr := queue.dequeue(&q)
		if curr.state == end {
			fmt.println(curr.moves)
			break
		}
		nbs := neighbors(curr)
		for nb in nbs {
			ss := Seen_State{nb.elevator, sorted(nb.state)}
			if ss in seen do continue
			seen[ss] = {}
			queue.enqueue(&q, nb)
		}
		delete(nbs)
	}
}

// Given a State and the elevator floor, generate all valid next states.
// "At most yourself and 2 RTGs or microchips in any combination"
@(private="file")
neighbors :: proc(e: Queue_Entry) -> [dynamic]Queue_Entry {
	nbs := make([dynamic]Queue_Entry)
	ds := [2]int{-1, +1}
	for i in 0 ..< len(e.state) {
		if e.state[i] != e.elevator do continue
		for j in i ..< len(e.state) {
			if e.state[j] != e.elevator do continue
			for d in ds {
				next_floor := e.elevator + d
				if next_floor < MIN_FLOOR || next_floor > MAX_FLOOR do continue
				nb := e
				nb.state[i] = next_floor
				if j != i {
					nb.state[j] = next_floor
				}
				nb.elevator = next_floor
				nb.moves += 1
				if valid(nb.state) {
					append(&nbs, nb)
				}
			}
		}
	}
	return nbs
}

// > In other words, if a chip is ever left in the same area as another RTG, and
// > it's not connected to its own RTG, the chip will be fried. Therefore, it is
// > assumed that you will follow procedure and keep chips connected to their
// > corresponding RTG when they're in the same room, and away from other RTGs
// > otherwise.
@(private="file")
valid :: proc(s: State) -> bool {
	for i_chip := 1; i_chip < len(s); i_chip += 2 {
		// Chip's connected to its generator, cannot be harmed
		if s[i_chip] == s[i_chip - 1] {
			continue
		}

		// Chip's alone, check for generators on the same floor
		for i_gen := 0; i_gen < len(s); i_gen += 2 {
			// Chip's on the same floor as another RTG that chip will be fried.
			if s[i_chip] == s[i_gen] {
				return false
			}
		}
	}
	return true
}

sorted :: proc(s: State) -> State {
	result := s
	for i in 0 ..< len(s) / 2 {
		for j in i + 1 ..< len(s) / 2 {
			gi := result[i * 2]
			ci := result[i * 2 + 1]
			gj := result[j * 2]
			cj := result[j * 2 + 1]
			if gj < gi || (gj == gi && cj < ci) {
				result[i * 2] = gj
				result[i * 2 + 1] = cj
				result[j * 2] = gi
				result[j * 2 + 1] = ci
			}
		}
	}
	return result
}
