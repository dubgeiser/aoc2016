package main

import "core:container/queue"
import "core:fmt"
import "core:sort"
import "core:strconv"
import "core:strings"

import input "aoc/input"

Bot :: [dynamic]int

// `cat data/day10.dat | grep ' output ' | cut -d " " -s -f 6,7 | sort -V`
// says that there are 21 outs.
Out :: [21]int

Instruction :: struct {
	src:              int,
	dest_low:         int,
	dest_low_is_bot:  bool,
	dest_high:        int,
	dest_high_is_bot: bool,
}

parse_bot_init :: proc(line: string) -> (int, int) {
	// "value V goes to bot B"
	parts := strings.split(line[len("value "):], " goes to bot ")
	bot, _ := strconv.parse_int(parts[1])
	val, _ := strconv.parse_int(parts[0])
	return bot, val
}

next_instruction :: proc(
	i: ^map[int]Instruction,
	q: ^queue.Queue(int),
	b: ^map[int]Bot,
	o: ^Out,
) -> (
	int,
	[]int,
) {
	idx := queue.dequeue(q)
	vals := make([dynamic]int, 2)
	vals[0], vals[1] = b[idx][0], b[idx][1]
	sort.quick_sort(vals[:])
	delete(b[idx])
	cmd := i[idx]
	if cmd.dest_low_is_bot {
		if !(cmd.dest_low in b) {
			b[cmd.dest_low] = make([dynamic]int)
		}
		append(&b[cmd.dest_low], vals[0])
		if len(b[cmd.dest_low]) == 2 {
			queue.enqueue(q, cmd.dest_low)
		}
	} else {
		o[cmd.dest_low] = vals[0]
	}
	if cmd.dest_high_is_bot {
		if !(cmd.dest_high in b) {
			b[cmd.dest_high] = make([dynamic]int)
		}
		append(&b[cmd.dest_high], vals[1])
		if len(b[cmd.dest_high]) == 2 {
			queue.enqueue(q, cmd.dest_high)
		}
	} else {
		o[cmd.dest_high] = vals[1]
	}
	return idx, vals[:]
}

parse_instruction :: proc(line: string) -> Instruction {
	parts := strings.split(line, " ")
	ins := Instruction {
		// bot `src` gives low to (bot|output) `dest_low` and high to (bot|output) `dest_high`
		// 0    1    2     3   4   5            6         7   8    0   10            11
		src              = strconv.parse_int(parts[1]) or_else -1,
		dest_low         = strconv.parse_int(parts[6]) or_else -1,
		dest_low_is_bot  = parts[5] == "bot",
		dest_high        = strconv.parse_int(parts[11]) or_else -1,
		dest_high_is_bot = parts[10] == "bot",
	}
	return ins
}

main :: proc() {
	bots := make(map[int]Bot)
	instructions := make(map[int]Instruction)
	defer delete(bots)
	defer delete(instructions)
	output := Out{}

	q: queue.Queue(int)
	q2: queue.Queue(int)
	queue.init(&q)
	defer queue.destroy(&q)

	lines := input.read_lines() or_else []string{}
	for line in lines {
		if strings.starts_with(line, "v") {
			bot_id, val := parse_bot_init(line)
			if !(bot_id in bots) {
				bots[bot_id] = make([dynamic]int)
			}
			append(&bots[bot_id], val)
			if len(bots[bot_id]) == 2 {
				queue.enqueue(&q, bot_id)
			}
		} else if strings.starts_with(line, "b") {
			ins := parse_instruction(line)
			instructions[ins.src] = ins
		} else {
			assert(true == false, "ERR Unkown instruction!")
		}
	}

	part1 := -1
	low_target, high_target := 17, 61
	for queue.len(q) > 0 {
		responsible, values := next_instruction(&instructions, &q, &bots, &output)
		if values[0] == low_target && values[1] == high_target {
			part1 = responsible
		}
	}
	fmt.println(part1)

	part2 := output[0]*output[1]*output[2]
	fmt.println(part2)
}
