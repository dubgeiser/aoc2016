#+feature dynamic-literals
package main

import "core:container/queue"
import "core:crypto/hash"
import "core:fmt"
import "core:strings"

WIDTH :: 4
HEIGHT :: 4

@(private="file")
Pos :: [2]int
Path :: string
Queue_Item :: struct {
	pos:  Pos,
	path: Path,
}

UP := Pos{-1, 0}
DOWN := Pos{1, 0}
LEFT := Pos{0, -1}
RIGHT := Pos{0, 1}
MOVES: map[Pos]string = {
	UP    = "U",
	DOWN  = "D",
	LEFT  = "L",
	RIGHT = "R",
}

main :: proc() {
	pass := "edjrjqaa"
	start := Pos{0, 0}
	end := Pos{3, 3}

	q: queue.Queue(Queue_Item)
	defer queue.destroy(&q)
	queue.init(&q)

	queue.enqueue(&q, {start, ""})
	qloop: for queue.len(q) > 0 {
		curr := queue.dequeue(&q)
		if curr.pos == end {
			fmt.printf("%s\n", curr.path)
			break qloop
		}
		nbs := neighbours(curr, pass)
		for nb in nbs {
			queue.enqueue(&q, nb)
		}
		delete(nbs)
	}

	// --[ Part 2
	qq := make([dynamic]Queue_Item)
	append(&qq, Queue_Item{start, ""})
	steps := 0
	for len(qq) > 0 {
		next := make([dynamic]Queue_Item)
		for curr in qq {
			if curr.pos == end {
				steps = max(steps, len(curr.path))
				continue
			}
			nbs := neighbours(curr, pass)
			for nb in nbs do append(&next, nb)
			delete(nbs)
		}
		delete(qq)
		qq = next
	}
	fmt.println(steps)
}

neighbours :: proc(item: Queue_Item, pass: string) -> []Queue_Item {
	nbs := make([dynamic]Queue_Item)
	seed := strings.concatenate({pass, item.path})
	valid_dirs := make([dynamic]Pos)
	defer delete(valid_dirs)
	digest := hash.hash_string(hash.Algorithm.Insecure_MD5, seed)
	defer delete(digest)
	if (digest[0] >> 4) >= 0x0b do append(&valid_dirs, UP)
	if (digest[0] & 0x0f) >= 0x0b do append(&valid_dirs, DOWN)
	if (digest[1] >> 4) >= 0x0b do append(&valid_dirs, LEFT)
	if (digest[1] & 0x0f) >= 0x0b do append(&valid_dirs, RIGHT)
	for d in valid_dirs {
		pp := item.pos + d
		if in_bounds(pp) {
			append(&nbs, {pp, strings.concatenate({item.path, MOVES[d]})})
		}
	}
	return nbs[:]
}

in_bounds :: proc(p: Pos) -> bool {
	return p[0] >= 0 && p[1] >= 0 && p[0] < HEIGHT && p[1] < WIDTH
}
