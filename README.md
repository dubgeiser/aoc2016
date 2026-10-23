# Advent of Code 2016
Noob learning Odin

## Strings
You can use the slice notation for strings, ex: `s[1:]` but this divides by
_bytes_, not runes.
While this is certainly okay for most, probably all, AoC puzzles, be aware, as
this can chop part of letters, leading to text corruption.

## Day 04
Feels like way too much code, iterations, ... 
  - [ ] Reduce looping, optimize

## Day 05
Juggling byte buffers around and doing bit arithmetic sped up the execution
time, but it still comes in at around 20s.
  - [ ] Optimize
  - [ ] Use threads

## Day 12
  - [ ] Optimize, 5s for both parts seems slow

