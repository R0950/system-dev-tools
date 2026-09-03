# Changelog

All notable changes to this exercise are documented here.

## [2.0.0] - Breaking Change

### Changed

- Rename `calculate_total()` to `calculate_sum()`.
- Existing callers using the old function name must update their code.

Reason: this is an incompatible API change, so the MAJOR version increases.

## [1.3.0] - New Feature

### Added

- Add an optional `round_digits` argument for formatting results.
- Existing calls continue to work unchanged.

Reason: this adds backward-compatible functionality, so the MINOR version increases.

## [1.2.4] - Bug Fix

### Fixed

- Fix incorrect handling of negative values.
- No public API is changed.

Reason: this is a backward-compatible bug fix, so the PATCH version increases.

## [1.2.3] - Initial Version

- Initial example version used by this exercise.
