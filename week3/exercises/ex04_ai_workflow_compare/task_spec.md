# Task

Implement:

summarize_numbers(values)

Requirements:

1. `values` is a list of numbers.
2. If the list is empty, raise `ValueError`.
3. Return a dictionary containing:
   - count
   - min
   - max
   - average
4. `average` must be rounded to two decimal places.
5. Do not modify the test program.
6. Do not use third-party libraries.

Example:

summarize_numbers([1, 2, 3, 4])

should return:

{
    "count": 4,
    "min": 1,
    "max": 4,
    "average": 2.5,
}
