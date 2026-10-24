# Advent of Code 2016
Noob learning Odin

## Strings
You can use the slice notation for strings, example: `s[1:]` but this divides by
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

## Day 15
There's a simpler, or more efficient way at least, to solve this, probably.
The positions are all prime numbers, it might be a coincidence but I doubt it.
I presented the puzzle to an AI, asking to just name related algorithms, it presented me the following:
 |Algorithm|Purpose|
 |---------|-------|
 |CRT: Chinese Remainder Theorem|Solves systems of linear congruences; finds the smallest T satisfying all constraints simultaneously|
 |Extended Euclidean Algorithm|Computes modular inverses; verifies whether a solution exists (checks if moduli are pairwise coprime)|
 |Brute force|Simpler but slower; iterate through starting times until one satisfies all disc positions|

> Chinese Remainder Theorem is the elegant solution here—it efficiently
> combines multiple modular constraints into a single answer. The Extended
> Euclidean Algorithm supports CRT by handling cases where the moduli share
> common factors (though CRT works best when they're coprime).

In [68212a3] I noted that the puzzle felt like gcd and some system of equations or something, seems that my hunch was at least somewhat in the right directions, since coprime means that 2 numbers share no common factor, their GCD = 1 _and_ 2 prime numbers are always coprime.

  - [ ] Investigate CRT, Chinese Remainder Theorem

## Day 16
Implemented straight forward, using `strings.Builder` seemed efficient enough, still, there's probably a way faster method/algorithm to solve this.
  - [ ] Check for repetitions in the strings, might be a shortcut
  - [ ] Might be there's a faster algorithm
