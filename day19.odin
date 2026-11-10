#+feature dynamic-literals

package main

import "core:container/queue"
import "core:fmt"
import "core:math"
import "core:math/bits"
import "core:time"

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
	// input = 9
	chrono: time.Stopwatch
	solutions := map[string]proc(n: int) -> int {
		"orig" = solve_orig,
		"log"  = solve_log,
		"bits" = solve_bits,
	}

	for name, fn in solutions {
		time.stopwatch_reset(&chrono)
		time.stopwatch_start(&chrono)
		solution := fn(input)
		time.stopwatch_stop(&chrono)
		fmt.printf("%s: %d in ", name, solution)
		fmt.println(time.stopwatch_duration(chrono))
	}

	// print_markdown_table(1024)

}

// This was my original solution for part 1
solve_orig :: proc(n: int) -> int {
	q: queue.Queue(int)
	queue.init(&q, n)
	for i in 1 ..= n do queue.push_back(&q, i)
	elf := -1
	for queue.len(q) > 0 {
		queue.push_back(&q, queue.pop_front(&q))
		elf = queue.pop_front(&q)
	}
	return elf
}

// https://oeis.org/A006257
// Python: return 0 if n==0 else 2*(n-2**int(math.log(n, 2)))+1
solve_log :: proc(n: int) -> int {
	// With ints (ie. binary numbers) you can `1 << ...` for `pow()`
	if n == 0 do return 0
	else do return 2 * (n - (1 << uint(math.log2(f64(n))))) + 1
}

// https://oeis.org/A006257
// Python return bool(n&(m:=1<<n.bit_length()-1))+((n&m-1)<<1) if n else 0
solve_bits :: proc(n: int) -> int {
	if n == 0 do return 0
	m := 1 << uint(bits.len(uint(n)) - 1)
	return int((n & m) != 0) + ((n & (m - 1)) << 1)
}

// Prints out a Markdown table with 2 columns:
// n: The number of elves participating
// x: Last elf standing
print_markdown_table :: proc(tot: int) {
	q: queue.Queue(int)
	fmt.println("|n|x|")
	fmt.println("|-:|-:|")
	for n in 1 ..= tot {
		queue.init(&q, n)
		for i in 1 ..= n do queue.push_back(&q, i)
		elf := -1
		for queue.len(q) > 0 {
			queue.push_back(&q, queue.pop_front(&q))
			elf = queue.pop_front(&q)
		}
		fmt.println("|", n, "|", elf, "|")
	}
}
