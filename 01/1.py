#!/usr/bin/env python3

with open("input") as data:
    instructions = data.read().strip().split(", ")

NORTH = 'N'
EAST = 'E'
SOUTH = 'S'
WEST = 'W'
LEFT = 'L'
RIGHT = 'R'

orientation_state = {
        NORTH: {
            LEFT: [0, -1, WEST],
            RIGHT: [0,  1, EAST],
            },
        EAST: {
            LEFT: [-1, 0, NORTH],
            RIGHT: [1,  0, SOUTH],
            },
        SOUTH: {
            LEFT: [0, 1, EAST],
            RIGHT: [0, -1, WEST],
            },
        WEST: {
            LEFT: [ 1, 0, SOUTH],
            RIGHT: [-1, 0, NORTH],
            },
        }

facing = NORTH
start = pos = (0, 0)
for move in instructions:
    direction = move[:1]
    distance = int(move[1:])
    row, col, facing = orientation_state[facing][direction]
    pos = (pos[0] + row * distance, pos[1] + col *distance)

answer = abs(pos[0]) + abs(pos[1])
print(f"{answer = }")
