# ex08 - Minimal Reproducer

This exercise demonstrates how to reduce a bug from a larger program into a
small standalone reproduction.

The workflow is:

1. reproduce the original failure;
2. isolate the relevant state and function behavior;
3. remove unrelated application logic;
4. create a standalone minimal reproducer;
5. explain the root cause before changing production code.

The production implementation is intentionally left unfixed during the
reproduction stage.
