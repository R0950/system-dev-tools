# README Audit — ai_audit.md

- **Date:** 2026-09-03
- **Repository:** `ex07_readme_audit` ("Line Counter")
- **Files audited:** `README.md` (current), `app.py`, `test_app.py`, `audit_checklist.md`
- **Verification performed:**
  - `python3 -m unittest -v test_app.py` → `Ran 3 tests ... OK` (3/3 pass)
  - `python3 app.py --help` → usage text confirmed (see below)
- **Integrity:** Hashes of `README.md`, `app.py`, `test_app.py`, and `audit_checklist.md` match the `source_hashes_before.txt` snapshot; none were modified during this audit. The only file created is `ai_audit.md`.

---

## Program behavior observed (baseline evidence)

`app.py` is a CLI tool that counts lines, words, and characters in a UTF-8 text file. Evidence from running the actual program:

```
$ python3 app.py --help
usage: app.py [-h] file

Count lines, words and characters in a UTF-8 text file.

positional arguments:
  file        path to a UTF-8 text file

options:
  -h, --help  show this help message and exit
```

- **Arguments:** one positional argument, `file` (path to a UTF-8 text file).
- **Output format:** three lines, `lines=N`, `words=N`, `characters=N`.
- **Missing file behavior:** `analyze_file()` raises `FileNotFoundError`; `main()` catches it and calls `parser.error(f"file not found: {args.file}")`, which prints the error plus usage and exits with status code 2.
- **Runtime:** Python 3 only, stdlib (`argparse`, `pathlib`). No third-party dependencies. The `dict[str, int]` type hints require **Python 3.9+**.
- **Tests:** `python3 -m unittest -v test_app.py` runs 3 tests, all passing (`test_analyze_text`, `test_analyze_file`, `test_missing_file`).

Current `README.md` content (92 bytes, complete):

```
# Line Counter

This is a Python program.

Run it with Python.

It counts things in a file.
```

---

## Criterion-by-criterion results

### 1. Project purpose — **PARTIAL**

The README title says "Line Counter" and the text says "It counts things in a file." That is directionally correct, but it never states *what* is counted (lines, words, characters) or that input must be a UTF-8 text file — both of which the program itself documents in `app.py` (`description="Count lines, words and characters in a UTF-8 text file."`). A reader cannot tell from the README alone what this program actually computes.

### 2. Requirements — **MISSING**

The README contains no Python version or runtime assumption. The code requires Python 3.9+ (built-in generic type hints `dict[str, int]` in `app.py` and `test_app.py`) and any stdlib-only Python 3 interpreter. None of this is stated.

### 3. Installation — **MISSING**

The README does not say whether installation is needed. The program has no third-party dependencies (only `argparse` and `pathlib` from the standard library) and needs no install step, but this fact is never documented.

### 4. Usage — **PARTIAL**

"Run it with Python" correctly points to Python as the interpreter, but it does not give the exact command. The real invocation is `python3 app.py <file>` (confirmed via `python3 app.py --help`). A reader is not told the script name, the required `file` argument, or the output format.

### 5. Example — **MISSING**

No concrete input and expected output example exists. The README never demonstrates even one run, so a reader cannot predict the `lines=… / words=… / characters=…` output produced by the program.

### 6. Error behavior — **MISSING**

Nothing is said about a missing input file. The actual behavior (confirmed by code and test `test_missing_file`) is that a missing file produces `app.py: error: file not found: <path>` via `argparse`, followed by usage text and exit code 2. None of this is documented.

### 7. Testing — **MISSING**

The README does not mention that tests exist or how to run them. The verified command is `python3 -m unittest -v test_app.py`, which runs 3 tests, all passing (OK). A contributor has no way to discover this from the README.

### 8. File structure — **MISSING**

No repository file is explained. `app.py` (the CLI implementation), `test_app.py` (unit tests), and the supporting files are never mentioned, so a new reader cannot tell where the code or tests live.

---

## Overall conclusion

The README is far below an acceptable standard for this repository: **0 PASS, 2 PARTIAL (project purpose, usage), 6 MISSING**. The four sentences it contains convey only that "a Python program counts something in a file." It omits essentially all actionable information — the exact command, an example, error behavior, testing instructions, requirements, and file layout — even though every one of those facts is readily observable in `app.py`, `test_app.py`, and their verified outputs.

---

## Three most important README improvements

1. **Add a precise purpose + usage + example section.** State that the tool counts lines, words, and characters in a UTF-8 text file, give the exact command `python3 app.py <file>`, and show a concrete run with expected output, e.g. a `sample.txt` containing `one two\nthree\n` producing `lines=2`, `words=3`, `characters=14`.

2. **Document error behavior for a missing file.** Explain that running `python3 app.py nonexistent.txt` prints `app.py: error: file not found: nonexistent.txt` (plus usage) and exits with a non-zero status (2) — with the caveat that the program checks the path via `Path.is_file()` first.

3. **Document testing and requirements.** Add the test command `python3 -m unittest -v test_app.py` (3 tests, all passing) and state the runtime assumption: Python 3.9+ required, standard library only, no installation or third-party dependencies needed.
