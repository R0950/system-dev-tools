import torch


def add_row_vector(matrix: torch.Tensor, row: torch.Tensor) -> torch.Tensor:
    return matrix + row


def scale_rows(matrix: torch.Tensor, factors: torch.Tensor) -> torch.Tensor:
    return matrix * factors


def incompatible_addition() -> None:
    matrix = torch.tensor([
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
    ])

    bad = torch.tensor([10.0, 20.0])

    matrix + bad


def main() -> None:
    matrix = torch.tensor([
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
    ])

    row = torch.tensor([10.0, 20.0, 30.0])

    factors = torch.tensor([
        [2.0],
        [3.0],
    ])

    print("===== ORIGINAL MATRIX =====")
    print(matrix)
    print("shape =", tuple(matrix.shape))

    print()
    print("===== MATRIX + ROW =====")
    added = add_row_vector(matrix, row)
    print(added)
    print("shape =", tuple(added.shape))

    print()
    print("===== MATRIX * FACTORS =====")
    scaled = scale_rows(matrix, factors)
    print(scaled)
    print("shape =", tuple(scaled.shape))

    print()
    print("===== BROADCAST SHAPES =====")
    print(
        "(2, 3) + (3,) ->",
        tuple(torch.broadcast_shapes((2, 3), (3,)))
    )
    print(
        "(2, 3) * (2, 1) ->",
        tuple(torch.broadcast_shapes((2, 3), (2, 1)))
    )

    print()
    print("===== INCOMPATIBLE =====")

    try:
        incompatible_addition()
    except RuntimeError as exc:
        print("caught RuntimeError")
        print(exc)


if __name__ == "__main__":
    main()
