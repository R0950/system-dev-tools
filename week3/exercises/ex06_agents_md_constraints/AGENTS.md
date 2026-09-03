# Agent Instructions

These rules apply to the entire repository.

## Allowed changes

The coding agent may modify only:

- src/calculator.py

## Forbidden changes

Do not modify:

- test_calculator.py
- AGENTS.md
- README.md
- task.txt

Do not create unnecessary files.

## Coding requirements

1. Use Python standard library only.
2. Add type hints to public functions.
3. Keep the implementation minimal.
4. Do not remove existing functions.
5. Do not weaken or bypass tests.

## Required verification

After modifying the implementation, run:

PYTHONPATH=src python3 -m unittest -v test_calculator.py

The task is complete only if all tests pass.
