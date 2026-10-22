package main

import "core:fmt"

/*

It seemed impossible to me to have to check for a sequence that goes on
forever.
Trying to analyze the program itself... GOTO considered harmful...
Keeping track of all the jnz's and the reg values was getting tedious

**But!**

The key is in te first part for the start values of the B and C registers:
```assembunny
cpy 7 c
cpy 365 b
```
Which are then used in an outer- and inner loop in the beginning, effectively
creating an equation:
x = start + 2555                  (i.e.7*365)
x being our desired result, which are 1's and 0's alternately repeated forever.

  100111111011  (2555)
+ reg A         (our input for reg A)
--------------
  101010101010  (Desired output, 2730)

We basically need to subtract 2555 from 2730 to get the missing input?
*/

main :: proc() {
	fmt.println(2730 - 2555)
}
