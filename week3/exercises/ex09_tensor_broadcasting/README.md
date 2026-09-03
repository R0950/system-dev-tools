# ex09 - PyTorch Tensor Broadcasting

This exercise demonstrates tensor shapes and broadcasting in PyTorch.

## Rules

Broadcasting compares dimensions from right to left.

Dimensions are compatible when:

- they are equal;
- one dimension is 1;
- or one tensor does not have that dimension.

## Examples

    (2, 3) + (3,)   -> (2, 3)

    (2, 3) * (2, 1) -> (2, 3)

The following shapes are incompatible:

    (2, 3) + (2,)

because the rightmost dimensions are 3 and 2.

## Run

    python broadcasting.py

## Test

    python -m unittest -v test_broadcasting.py
