# Bug Report

## Symptom

A clean record sometimes reports warnings from an earlier validation.

## Expected behavior

Each call to `validate_records()` should start with an empty warning list unless
a warning list is explicitly supplied.

For example:

1. Validate an invalid record.
2. Validate a clean record.

The second validation should return an empty list.

## Actual behavior

Warnings from the first call can unexpectedly appear in later calls.

## Goal

Do not fix the production implementation yet.

First create the smallest standalone Python program that reliably reproduces
the same underlying bug.
