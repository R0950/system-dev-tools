import importlib.util
import sys


def load_module(filename):
    spec = importlib.util.spec_from_file_location("candidate", filename)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def run_tests(filename):
    module = load_module(filename)
    f = module.summarize_numbers

    assert f([1, 2, 3, 4]) == {
        "count": 4,
        "min": 1,
        "max": 4,
        "average": 2.5,
    }

    assert f([2, 5, 9]) == {
        "count": 3,
        "min": 2,
        "max": 9,
        "average": 5.33,
    }

    assert f([-5, 0, 5]) == {
        "count": 3,
        "min": -5,
        "max": 5,
        "average": 0.0,
    }

    assert f([3.5]) == {
        "count": 1,
        "min": 3.5,
        "max": 3.5,
        "average": 3.5,
    }

    try:
        f([])
    except ValueError:
        pass
    else:
        raise AssertionError("empty list must raise ValueError")

    print(f"PASS: {filename}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 verify.py <file.py>")
        raise SystemExit(2)

    run_tests(sys.argv[1])
