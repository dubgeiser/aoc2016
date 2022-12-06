#!/usr/bin/env python3

with open("input") as data:
    instructions = data.read().strip().split(", ")

# N, E, S, W
# Corresponds to index of possible x, y movements
orientation = 0
DX = [ 0, 1, 0, -1]
DY = [-1, 0, 1,  0]
LEFT = 'L'
RIGHT = 'R'
x = y = 0
for move in instructions:
    direction = move[:1]
    distance = int(move[1:])

    if direction == LEFT:
        orientation = (orientation + 3) % 4 # move counter-clockwise: W -> S -> E -> N
    else:
        orientation = (orientation + 1) % 4 # move clockwise: N -> E -> S -> W

    x += DX[orientation] * distance
    y += DY[orientation] * distance

answer = abs(x) + abs(y)
print(f"{answer = }")
