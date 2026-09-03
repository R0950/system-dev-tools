import tempfile
import unittest
from pathlib import Path

from app import analyze_file, analyze_text


class AppTests(unittest.TestCase):

    def test_analyze_text(self):
        result = analyze_text("hello world\npython\n")
        self.assertEqual(result["lines"], 2)
        self.assertEqual(result["words"], 3)
        self.assertEqual(result["characters"], 19)

    def test_analyze_file(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "sample.txt"
            path.write_text("one two\nthree\n", encoding="utf-8")

            result = analyze_file(str(path))

            self.assertEqual(result["lines"], 2)
            self.assertEqual(result["words"], 3)
            self.assertEqual(result["characters"], 14)

    def test_missing_file(self):
        with self.assertRaises(FileNotFoundError):
            analyze_file("file-that-does-not-exist.txt")


if __name__ == "__main__":
    unittest.main()
