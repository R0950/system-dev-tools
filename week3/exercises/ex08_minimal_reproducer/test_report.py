import unittest

from report import build_report, validate_records


class ReportTests(unittest.TestCase):

    def test_invalid_record_produces_warning(self):
        report = build_report([{"score": 80}])

        self.assertEqual(report["warning_count"], 1)
        self.assertEqual(
            report["warnings"],
            ["record 1: missing name"],
        )

    def test_clean_record_has_no_warning(self):
        report = build_report([
            {
                "name": "Alice",
                "score": 90,
            }
        ])

        self.assertEqual(report["warning_count"], 0)
        self.assertEqual(report["warnings"], [])

    def test_validate_records_directly(self):
        self.assertEqual(
            validate_records([
                {
                    "name": "Bob",
                    "score": 75,
                }
            ]),
            [],
        )


if __name__ == "__main__":
    unittest.main()
