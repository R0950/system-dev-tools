# Repository Analysis Report

Project: ex05 - Agent Repository Exploration

This report describes an unfamiliar, small Python CLI repository. No source
files were modified; only this report (`agent_report.md`) was created.

## 1. Program entry point

The actual program entry point is the top-level script **`run.py`**.

`run.py`:

```python
from miniapp.cli import main

if __name__ == "__main__":
    main()
```

When invoked as `python3 run.py --numbers "..."`, the `if __name__ ==
"__main__"` guard triggers and delegates to **`miniapp.cli.main()`**. The
real argument handling / orchestration entry is therefore
`src/miniapp/cli.py::main()`.

## 2. Call chain starting from the entry point

```
run.py
  (if __name__ == "__main__")
  -> miniapp.cli.main()                      # cli.py
       argparse: reads --numbers (required)
       -> miniapp.service.analyze_text(args.numbers)     # service.py
            -> miniapp.io.parse_numbers(text)            # io.py
            -> miniapp.stats.summarize(values)           # stats.py
       json.dumps(result, sort_keys=True) -> print       # cli.py
  on ValueError:
       -> argparse parser.error(str(exc)) -> prints usage, sys.exit(2)
```

## 3. Responsibilities of every module under src/miniapp

| Module | Responsibility |
| --- | --- |
| `src/miniapp/__init__.py` | Empty file. Makes `miniapp` a package so the `miniapp.*` imports used by `run.py` / `test_flow.py` resolve. |
| `src/miniapp/cli.py` | Command-line interface. Defines `main()`: builds an `argparse` parser, requires `--numbers`, calls `analyze_text()` inside a `try` block, converts a `ValueError` into an `argparse` usage error (`parser.error`) and prints the successful result as JSON on stdout. |
| `src/miniapp/service.py` | Orchestration layer. `analyze_text(text)` is the single business entry point that composes parsing + statistics. |
| `src/miniapp/io.py` | Input parsing / validation. `parse_numbers(text)` splits a comma-separated string, strips whitespace, rejects empty items, and converts each item to `float`. Raises `ValueError` on bad input. |
| `src/miniapp/stats.py` | Statistics computation. `summarize(values)` validates a non-empty sequence and returns `{count, min, max, average}`, with `average` rounded to 2 decimals. Raises `ValueError` when empty. |

## 4. Complete data flow for `--numbers "1,2,3,4"`

1. Shell passes `"1,2,3,4"` as the value of `--numbers`.
2. `argparse` in `cli.main()` parses it into `args.numbers == "1,2,3,4"`.
3. `cli.main()` calls `analyze_text("1,2,3,4")` (service.py).
4. `service.analyze_text` calls `parse_numbers("1,2,3,4")` (io.py):
   - `text.split(",")` -> `["1", "2", "3", "4"]`
   - strip each item -> `["1", "2", "3", "4"]` (unchanged)
   - no empty item -> validation passes
   - `[float(item) for item in items]` -> `[1.0, 2.0, 3.0, 4.0]`
5. `service.analyze_text` calls `summarize([1.0, 2.0, 3.0, 4.0])` (stats.py):
   - `count` = 4
   - `min` = 1.0
   - `max` = 4.0
   - `average` = `round(10.0 / 4, 2)` = `2.5`
6. `cli.main()` prints `json.dumps(result, sort_keys=True)`:
   - `{"average": 2.5, "count": 4, "max": 4.0, "min": 1.0}`

## 5. Where invalid input such as `"1,,2"` is detected

Detection happens in **`src/miniapp/io.py` inside `parse_numbers()`**:

```python
def parse_numbers(text):
    items = [part.strip() for part in text.split(",")]

    if not items or any(item == "" for item in items):
        raise ValueError("numbers must be a comma-separated list")

    return [float(item) for item in items]
```

For `"1,,2"`, `split(",")` yields `["1", "", "2"]`; the middle part is empty
even after `strip()`, so `any(item == "")` is `True` and a `ValueError` is
raised immediately (before any `float` conversion).

Note: the same `ValueError` type also covers structurally empty input and,
for non-numeric tokens (e.g. `"1,a"`), the `float()` conversion raises
`ValueError` as well. Both propagate up through `service.analyze_text`.

## 6. Exception / exit behavior produced for invalid input

Two layers of behavior, verified by execution:

1. **Library level** — `parse_numbers("1,,2")` raises `ValueError`
   (`"numbers must be a comma-separated list"`). `test_flow.py` asserts this
   exact behavior (lines 22-27).
2. **CLI level** — `cli.main()` wraps the `analyze_text` call in
   `try/except ValueError` and calls `argparse`'s `parser.error(str(exc))`.
   This prints the usage line plus `run.py: error: numbers must be a
   comma-separated list` to **stderr** and terminates with **exit code 2**
   (argparse's standard error exit code).

Verified output for `PYTHONPATH=src python3 run.py --numbers "1,,2"`:

```
usage: run.py [-h] --numbers NUMBERS
run.py: error: numbers must be a comma-separated list
exit_code=2
```

## Verification commands used

The commands below were executed from the repository root
(`/home/jk/system-dev-tools/week3/exercises/ex05_agent_repo_explore`):

```bash
# 1. Test suite / behavior assertions (required by ai_prompt.txt)
PYTHONPATH=src python3 test_flow.py
# Output: PASS: repository behavior verified

# 2. Happy-path CLI run (required by ai_prompt.txt)
PYTHONPATH=src python3 run.py --numbers "1,2,3,4"
# Output: {"average": 2.5, "count": 4, "max": 4.0, "min": 1.0}

# 3. Invalid-input behavior of the CLI
PYTHONPATH=src python3 run.py --numbers "1,,2"
echo "exit_code=$?"
# Output: usage + error message on stderr, then exit_code=2

# 4. Integrity check that no protected file was modified
sha256sum run.py test_flow.py src/miniapp/*.py
# Hashes match source_hashes_before.txt exactly.
```

## Conclusion

- Entry point: `run.py` -> `miniapp.cli.main()`.
- Module chain: cli -> service -> io (parse) and stats (summarize).
- Input validation lives in `miniapp.io.parse_numbers`.
- Invalid input surfaces as `ValueError` at the library level and as an
  argparse usage error with exit code 2 at the CLI level.
- All protected files are untouched; only `agent_report.md` was created.
