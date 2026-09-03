# ex10 - PyTorch Autograd

This exercise demonstrates automatic differentiation with PyTorch Autograd.

## Scalar Function

The function is:

    f(x, y) = x^2 + 3xy + y^2

Its analytical gradients are:

    df/dx = 2x + 3y
    df/dy = 3x + 2y

For:

    x = 2
    y = -1

the expected values are:

    f(x, y) = -1
    df/dx = 1
    df/dy = 4

PyTorch computes the same gradients using:

    output.backward()

The results are stored in:

    x.grad
    y.grad

## requires_grad

Tensors participate in automatic differentiation when created with:

    requires_grad=True

PyTorch records the operations and builds a computation graph.

## Gradient Accumulation

Gradients accumulate by default.

Calling backward twice without clearing `.grad` gives:

    first backward:  1
    second backward: 2

Training loops therefore normally clear gradients before the next backward pass.

## Vector Gradient

For:

    x = [1, 2, 3]
    loss = sum(x^2)

the gradient is:

    [2, 4, 6]

## Run

    python autograd_demo.py

## Test

    python -m unittest -v test_autograd.py
