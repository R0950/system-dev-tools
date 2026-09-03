from miniapp.io import parse_numbers
from miniapp.stats import summarize
from miniapp.service import analyze_text


assert parse_numbers("1, 2, 3") == [1.0, 2.0, 3.0]

assert summarize([1.0, 2.0, 3.0]) == {
    "count": 3,
    "min": 1.0,
    "max": 3.0,
    "average": 2.0,
}

assert analyze_text("1,2,3,4") == {
    "count": 4,
    "min": 1.0,
    "max": 4.0,
    "average": 2.5,
}

try:
    parse_numbers("1,,2")
except ValueError:
    pass
else:
    raise AssertionError("invalid input should raise ValueError")

print("PASS: repository behavior verified")
