import unittest

import torch

from autograd_demo import (
    analytical_gradient,
    autograd_gradient,
    demonstrate_accumulation,
    vector_gradient,
)


class AutogradTests(unittest.TestCase):

    def test_function_value(self):
        value, _, _ = autograd_gradient(2.0, -1.0)

        self.assertAlmostEqual(value, -1.0)

    def test_manual_gradient(self):
        dx, dy = analytical_gradient(2.0, -1.0)

        self.assertEqual(dx, 1.0)
        self.assertEqual(dy, 4.0)

    def test_autograd_matches_manual_gradient(self):
        expected_dx, expected_dy = analytical_gradient(
            2.0,
            -1.0,
        )

        _, actual_dx, actual_dy = autograd_gradient(
            2.0,
            -1.0,
        )

        self.assertAlmostEqual(actual_dx, expected_dx)
        self.assertAlmostEqual(actual_dy, expected_dy)

    def test_gradient_accumulation(self):
        first, second = demonstrate_accumulation()

        self.assertAlmostEqual(first, 1.0)
        self.assertAlmostEqual(second, 2.0)

    def test_vector_gradient(self):
        result = vector_gradient()

        expected = torch.tensor(
            [2.0, 4.0, 6.0],
            dtype=torch.float64,
        )

        self.assertTrue(torch.equal(result, expected))


if __name__ == "__main__":
    unittest.main()
