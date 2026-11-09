package main

import "core:container/queue"
import "core:fmt"

/*

	Make a list of the presents, index+1 -> Elf's number
	[1, 1, 1, 1, 1] Start
	[2, 0, 1, 1, 1] Elf 1 takes elf 2's presents
	[2, 0, 2, 0, 1] Elf 3 takes elf 4's presents
	[0, 0, 2, 0, 3] Elf 5 takes elf 1's presents
	[0, 0, 5, 0, 0] Elf 3 takes elf 5's presents
	NOPE This is going to be a drag to keep track of it all, especially since
	we have about 3 million elves

	It seems the sequence is always the same; presents move to the right, while
	the elf to the left is disregarded.
	But we need to find the elf's _number_, the actual present count doesn't
	actually matter.

	List the elves' numbers and reduce?
	[1, 2, 3, 4, 5] Start
	[2, 3, 4, 5, 1] Elf 1 takes elf 2's presents
	[3, 4, 5, 1]    Leaving elf 2 to be skipped -> 2
	[4, 5, 1, 3]    Elf 3 takes elf 4's presents
	[5, 1, 3]       Leaving elf 4 to be skipped -> 4
	[1, 3, 5]       Elf 5 takes elf 1's presents
	[3, 5]          Leaving elf 1 to be skipped -> 1
	[5, 3]          Elf 3 takes elf 5's presents
	[3]			    Leaving elf 5 to be skipped -> 5
	[3]             Elf 3 takes nothing
	[]              Leaving elf 3 "to be skipped" -> 3

	This is basically a double ended queue with a -1 rotate + pop left
	The last popped elf nr. will be the one with all the presents.
*/

main :: proc() {
	input := 3014387
	q : queue.Queue(int)
	queue.init(&q, input)
	for i in 1..=input do queue.push_back(&q, i)
	elf := -1
	for queue.len(q) > 0 {
		queue.push_back(&q, queue.pop_front(&q))
		elf = queue.pop_front(&q)
	}
	fmt.println(elf)
}
