package main

import "aoc"
import "core:fmt"
import "core:strconv"
import "core:strings"

Memory :: map[string]int

main :: proc() {
	mem := make(Memory)
	mem["a"] = 0
	mem["b"] = 0
	mem["c"] = 0
	mem["d"] = 0
	defer delete(mem)
	program := aoc.read_lines() or_else []string{""}
	ip := 0
	for ip < len(program) {
		ip = execute(ip, program[ip], &mem)
	}
	fmt.println(mem["a"])
}

execute :: proc(ip: int, ins: string, mem: ^Memory) -> int {
	parts := strings.split(ins, " ")
	jump := 1
	if len(parts) == 3 { 	// cpy/jnz
		v, ok := strconv.parse_int(parts[1])
		v = ok ? v : mem[parts[1]]
		if parts[0] == "cpy" {
			mem[parts[2]] = v
		} else {
			if v != 0 {
				jump, _ = strconv.parse_int(parts[2])
			}
		}
	} else { 	// inc/dec
		mem[parts[1]] += parts[0] == "inc" ? 1 : -1
	}
	return ip + jump
}
