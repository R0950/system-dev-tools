import unittest

from calculator import clamp, mean


class CalculatorTests(unittest.TestCase):

    def test_clamp_inside_range(self):
        self.assertEqual(clamp(5, 0, 10), 5)

    def test_clamp_below_range(self):
        self.assertEqual(clamp(-3, 0, 10), 0)

    def test_clamp_above_range(self):
        self.assertEqual(clamp(20, 0, 10), 10)

    def test_clamp_invalid_range(self):
        with self.assertRaises(ValueError):
            clamp(5, 10, 0)

    def test_mean(self):
        self.assertEqual(mean([1, 2, 3, 4]), 2.5)

    def test_mean_float_values(self):
        self.assertEqual(mean([1.5, 2.5]), 2.0)

    def test_mean_empty(self):
        with self.assertRaises(ValueError):
            mean([])


if __name__ == "__main__":
    unittest.main()
