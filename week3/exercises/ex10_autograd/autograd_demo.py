import torch


def function_value(x: torch.Tensor, y: torch.Tensor) -> torch.Tensor:
    """Compute f(x, y) = x^2 + 3xy + y^2."""
    return x**2 + 3 * x * y + y**2


def analytical_gradient(x: float, y: float) -> tuple[float, float]:
    """Return the manually derived gradient of f."""
    dfdx = 2 * x + 3 * y
    dfdy = 3 * x + 2 * y
    return dfdx, dfdy


def autograd_gradient(x_value: float, y_value: float) -> tuple[float, float, float]:
    """Compute function value and gradients using PyTorch autograd."""
    x = torch.tensor(x_value, dtype=torch.float64, requires_grad=True)
    y = torch.tensor(y_value, dtype=torch.float64, requires_grad=True)

    output = function_value(x, y)
    output.backward()

    return output.item(), x.grad.item(), y.grad.item()


def demonstrate_accumulation() -> tuple[float, float]:
    """Show that calling backward twice accumulates gradients."""
    x = torch.tensor(2.0, dtype=torch.float64, requires_grad=True)
    y = torch.tensor(-1.0, dtype=torch.float64, requires_grad=True)

    output1 = function_value(x, y)
    output1.backward()

    first_x_grad = x.grad.item()

    output2 = function_value(x, y)
    output2.backward()

    second_x_grad = x.grad.item()

    return first_x_grad, second_x_grad


def vector_gradient() -> torch.Tensor:
    """Compute the gradient of sum(x^2) for a vector."""
    x = torch.tensor(
        [1.0, 2.0, 3.0],
        dtype=torch.float64,
        requires_grad=True,
    )

    loss = (x**2).sum()
    loss.backward()

    return x.grad


def main() -> None:
    x_value = 2.0
    y_value = -1.0

    print("===== FUNCTION =====")
    print("f(x, y) = x^2 + 3xy + y^2")
    print("x =", x_value)
    print("y =", y_value)

    expected_x, expected_y = analytical_gradient(
        x_value,
        y_value,
    )

    value, actual_x, actual_y = autograd_gradient(
        x_value,
        y_value,
    )

    print()
    print("===== FUNCTION VALUE =====")
    print("f(2, -1) =", value)

    print()
    print("===== MANUAL GRADIENT =====")
    print("df/dx =", expected_x)
    print("df/dy =", expected_y)

    print()
    print("===== AUTOGRAD GRADIENT =====")
    print("x.grad =", actual_x)
    print("y.grad =", actual_y)

    print()
    print("===== GRADIENT CHECK =====")
    print("x gradient matches =", actual_x == expected_x)
    print("y gradient matches =", actual_y == expected_y)

    first_grad, accumulated_grad = demonstrate_accumulation()

    print()
    print("===== GRADIENT ACCUMULATION =====")
    print("after first backward  =", first_grad)
    print("after second backward =", accumulated_grad)

    print()
    print("===== VECTOR GRADIENT =====")
    print("x = [1, 2, 3]")
    print("loss = sum(x^2)")
    print("gradient =", vector_gradient())


if __name__ == "__main__":
    main()
