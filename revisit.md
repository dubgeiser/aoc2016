# To revisit / learn / fun ...

## Day 1
Optimized orientation state transition by considering the orientation as an index of 4 possible combinations of movement along X/Y axis.
You can model a simpel state machine with a list and modulo calcs involving the length of that list, for instance:

```python
o = ['N', 'E', 'S', 'W']
current = 0 # we start facing North

# turning right, clockwise, state goes from left to right in the list
current = (current + 1) % 4
# or
current = (current + 1) % len(o)

# turning left, counter clockwise, state goes from right to left in the list.
current = (current + 3) % 4
# or
current = (current + len(o) - 1) % len(o)
```

I've kept my original solution with the dictionary in `2.py` for a bit of easier comparison.
