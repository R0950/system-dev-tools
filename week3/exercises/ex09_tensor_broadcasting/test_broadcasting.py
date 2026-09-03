import unittest

import torch

from broadcasting import (
    add_row_vector,
    incompatible_addition,
    scale_rows,
)


class BroadcastingTests(unittest.TestCase):

    def test_add_row_vector(self):
        matrix = torch.tensor([
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0],
        ])

        row = torch.tensor([10.0, 20.0, 30.0])

        expected = torch.tensor([
            [11.0, 22.0, 33.0],
            [14.0, 25.0, 36.0],
        ])

        result = add_row_vector(matrix, row)

        self.assertTrue(torch.equal(result, expected))
        self.assertEqual(result.shape, torch.Size([2, 3]))

    def test_scale_rows(self):
        matrix = torch.tensor([
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0],
        ])

        factors = torch.tensor([
            [2.0],
            [3.0],
        ])

        expected = torch.tensor([
            [2.0, 4.0, 6.0],
            [12.0, 15.0, 18.0],
        ])

        result = scale_rows(matrix, factors)

        self.assertTrue(torch.equal(result, expected))

    def test_row_shape(self):
        self.assertEqual(
            torch.broadcast_shapes((2, 3), (3,)),
            torch.Size([2, 3]),
        )

    def test_column_shape(self):
        self.assertEqual(
            torch.broadcast_shapes((2, 3), (2, 1)),
            torch.Size([2, 3]),
        )

    def test_incompatible(self):
        with self.assertRaises(RuntimeError):
            incompatible_addition()


if __name__ == "__main__":
    unittest.main()
