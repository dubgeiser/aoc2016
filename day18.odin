package main

import "base:intrinsics"
import ba "core:container/bit_array"
import "core:fmt"

// Values to represent a trap or a safe place in a Bit_Array
// Since we want to count the safe places with Kernighan's population count, a safe place needs to be represented by a 1 (`true`)
TRAP :: false
SAFE :: true

Check_Tile :: [3]bool

main :: proc() {
	start_row := "^^.^..^.....^..^..^^...^^.^....^^^.^.^^....^.^^^...^^^^.^^^^.^..^^^^.^^.^.^.^.^.^^...^^..^^^..^.^^^^"

	row := ba.create(len(start_row))
	defer ba.destroy(row)
	for i in 0 ..< len(start_row) do ba.set(row, i, start_row[i] == '^' ? TRAP : SAFE)
	total := popcount(row)
	for i in 1 ..< 40 {
		row = next_row(row)
		total += popcount(row)
	}
	fmt.println(total)


	// Part 2
	// 20000795
	for i in 0 ..< len(start_row) do ba.set(row, i, start_row[i] == '^' ? TRAP : SAFE)
	total = popcount(row)
	for i in 1 ..< 400000 {
		row = next_row(row)
		total += popcount(row)
	}
	fmt.println(total)
}

next_row :: proc(row: ^ba.Bit_Array) -> ^ba.Bit_Array {
	next_row := ba.create(ba.len(row))
	for i := 0; i < ba.len(row); i += 1 {
		ba.set(next_row, i, new_tile(row, i))
	}
	return next_row
}

new_tile :: proc(row: ^ba.Bit_Array, index: int) -> bool {
	// out of bounds is a safe place
	check := Check_Tile {
		(index > 0 ? ba.get(row, index - 1) : SAFE),
		ba.get(row, index),
		(index < ba.len(row) - 1 ? ba.get(row, index + 1) : SAFE),
	}

	// A new tile is a trap only in one of following cases:
	//  - left and center are traps, but right is not -> 110 -> 6
	//  - center and right are traps, but left is not -> 011 -> 3
	//  - only left is a trap -> 100 -> 4
	//  - only right is a trap -> 001 -> 1
	return(
		check == {TRAP, TRAP, SAFE} || check == {SAFE, TRAP, TRAP} || check == {TRAP, SAFE, SAFE} || check == {SAFE, SAFE, TRAP} ? TRAP : SAFE \
	)
}

popcount :: proc(tiles: ^ba.Bit_Array) -> int {
	n := ba.len(tiles)
	full := n / 64
	total := 0
	for i in 0 ..< full {
		total += int(intrinsics.count_ones(tiles.bits[i]))
	}
	rem := n % 64
	if rem > 0 {
		mask := (u64(1) << uint(rem)) - 1
		total += int(intrinsics.count_ones(tiles.bits[full] & mask))
	}
	return total
}
