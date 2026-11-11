# Advent of Code 2016
Noob learning Odin
There's a lot less input parsing than I have seen in other (later) AoC's, which doesn't sit well with the way I usually solve puzzles, switching between sample and real input.
Nothing too bad or anything, but it requires more editing some variable than I'd like to.

There's a bunch of MD5 hashing puzzles, still wondering if this is a hint... MD5 was deemed unsafe, so I'm still thinking there might be some way of exploiting that, since all the MD5 related puzzles come in at more than half a minute run time.
For sure, I'm certainly to blame too for not writing the optimal solutions, but still...

## TODO
  - [ ] Put `dayxx.odin` into its own folder `dayxx/dayxx.odin`, or `dayxx/main.odin`, just to shut up effing `ols` that doesn't seem to be able to handle single file programs?
    > [!NOTE] This might not be necessary, if we can work around with the `private` attribute as used in `day20.odin` with the `parse_line` declaration.

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
  - [ ] Memoization?

## Day 12
  - [ ] Optimize, 5s for both parts seems slow

## Day 14
Pure brute force again, adding memoization when working on part2 sped things up, but not by orders of magnitude.
The memoization, although I had some brainfarts getting the caching a bit right, _did_ help tremendously in part 2!
The whole day14 ran in about 30 seconds :seenoevil:

This might be worth investigating in day 5 though

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

## Day 19
After solving part 1, I wrote a function that generates the outcomes (`x`) for `n` number of elves.
It's a sequence that does `+2` until it reaches a power of `2`, then it resets to `1`.

|n|x|
|-:|-:|
| 1 | 1 |
| 2 | 1 |
| 3 | 3 |
| 4 | **1**|
| 5 | 3 |
| 6 | 5 |
| 7 | 7 |
| 8 | **1**|
| 9 | 3 |
| 10 | 5 |
| 11 | 7 |
| 12 | 9 |
| 13 | 11 |
| 14 | 13 |
| 15 | 15 |
| 16 | **1**|
| 17 | 3 |
| 18 | 5 |
| 19 | 7 |
| 20 | 9 |
| 21 | 11 |
| 22 | 13 |
| 23 | 15 |
| 24 | 17 |
| 25 | 19 |
|..|..|
| 31 | 31 |
| 32 | **1**|
| 33 | 3 |
| 34 | 5 |
| 35 | 7 |
| 36 | 9 |
| 37 | 11 |
| 38 | 13 |
| 39 | 15 |
| 40 | 17 |
|..|..|
| 63 | 63 |
| 64 | **1**|
| 65 | 3 |
|..|..|
| 126 | 125 |
| 127 | 127 |
| 128 | **1**|
| 129 | 3 |
|..|..|
| 254 | 253 |
| 255 | 255 |
| 256 | **1**|
|..|..|
| 511 | 511 |
| 512 | **1**|
| 513 | 3 |
|..|..|
| 1023 | 1023 |
| 1024 | **1**|

Threw it in the Online Encyclopedia of Integer Sequences: https://oeis.org/A006257
"Josephus problem"... yeah, I should've investigated the title of the puzzle :facepalm:

So I coded up 2 alternatives based on OEIS, one working out the sequence with logarithm, the other with some clever bit manipulation, not too scientific, but these are the numbers coming out:
|algo|runtime|
|:---|---:|
|Original|70-80ms|
|Log|1-1.6μs|
|Bits| 500-1000ns|

So my solution for part 1 is about 4 orders of magnitude slower :grin:
Doing `odin run -file day19.odin` still made it feel pretty instant though :-D
