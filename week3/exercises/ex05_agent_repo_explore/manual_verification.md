# Manual Verification

## 1. Entry Point

Verified that `run.py` imports `main` from `miniapp.cli` and calls it when
executed directly.

Result: PASS.

## 2. Call Chain

Verified the source-level call relationship:

run.py
-> miniapp.cli.main
-> miniapp.service.analyze_text
-> miniapp.io.parse_numbers
-> miniapp.stats.summarize
-> JSON output

Result: PASS.

## 3. Normal Input

Running:

`PYTHONPATH=src python3 run.py --numbers "1,2,3,4"`

produced:

`{"average": 2.5, "count": 4, "max": 4.0, "min": 1.0}`

Result: PASS.

## 4. Invalid Input

Input `1,,2` is rejected inside `miniapp.io.parse_numbers`.

The function raises `ValueError`, which is caught by the CLI and passed to
`argparse.ArgumentParser.error`.

The command terminates with exit code 2.

Result: PASS.

## 5. Source Integrity

SHA-256 hashes before and after agent analysis were identical.

Result: PASS.

## Conclusion

The coding agent's repository analysis was verified against source inspection,
runtime execution, automated tests and source-file hashes.
