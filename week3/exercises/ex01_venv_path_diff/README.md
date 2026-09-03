# ex01 - Compare Python Virtual Environment PATH

## Goal

Compare the shell environment before and after activating a Python virtual
environment, especially `PATH`, Python executable location, pip executable
location and `VIRTUAL_ENV`.

## Procedure

1. Save the original environment with `printenv`.
2. Create a virtual environment using `python3 -m venv .venv`.
3. Activate it using `source .venv/bin/activate`.
4. Record the environment again.
5. Compare the two environments using `diff`.
6. Use `command -v python` and `command -v pip` to inspect executable paths.
7. Run `deactivate` and verify that the original environment is restored.

## Observation

After activation, `.venv/bin` is inserted near the beginning of `PATH`.
Therefore the shell finds the virtual environment's Python and pip before
the system versions.

The `VIRTUAL_ENV` variable is also created and points to the active virtual
environment directory.

After running `deactivate`, the modified environment variables are restored
and the system Python becomes the default again.

## Files

- `before_env.txt`: environment variables before activation
- `after_env.txt`: environment variables after activation
- `env_diff.txt`: differences between the two environments
- `path_check.txt`: important Python, pip and PATH information
