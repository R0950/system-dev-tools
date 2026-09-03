# ex03 - Semantic Versioning and Changelog

## Goal

Practice Semantic Versioning and document releases using a changelog.

Semantic Versioning uses the format:

`MAJOR.MINOR.PATCH`

## Rules

- PATCH: backward-compatible bug fix.
- MINOR: backward-compatible new functionality.
- MAJOR: incompatible API change.

## Example

Starting from version `1.2.3`:

- Bug fix: `1.2.3 -> 1.2.4`
- New compatible feature: `1.2.4 -> 1.3.0`
- Breaking API change: `1.3.0 -> 2.0.0`

## Files

- `versioning.py`: implements version number bumping.
- `test_versioning.py`: verifies PATCH, MINOR and MAJOR behavior.
- `CHANGELOG.md`: records example release changes.
- `result.txt`: records the execution result.
