# Line Counter

A small Python command-line program that counts the number of lines, words and
characters in a UTF-8 text file.

## Requirements

- Python 3.9 or later
- No third-party dependencies

Python 3.9+ is required because the source code uses built-in generic type
annotations such as `dict[str, int]`.

## Installation

No installation step is required.

Clone or download the repository and run the program directly with Python.

## Usage

Run the program with:

    python3 app.py <file>

Display command-line help with:

    python3 app.py --help

## Example

Suppose `sample.txt` contains:

    hello world
    python

Run:

    python3 app.py sample.txt

Expected output:

    lines=2
    words=3
    characters=19

## Error Handling

If the specified file does not exist, the program reports an argument error.

For example:

    python3 app.py missing.txt

The error output contains:

    error: file not found: missing.txt

The command exits with status code 2.

## Testing

Run the automated tests with:

    python3 -m unittest -v test_app.py

A successful test run ends with:

    Ran 3 tests
    OK

## Project Structure

- `app.py` - command-line program and text-analysis functions
- `test_app.py` - automated unit tests
- `README.md` - improved project documentation
- `README.original.md` - original incomplete documentation
- `audit_checklist.md` - README review criteria
- `ai_prompt.txt` - instructions supplied to the coding agent
- `ai_audit.md` - coding-agent audit of the original README

## Summary

The README documents the purpose, runtime requirements, usage, expected output,
error behavior and test procedure so that a new user can run the project
without first inspecting the source code.
