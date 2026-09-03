# ex02 - Reproduce Python Dependencies with a Lock File

## Goal

Create a clean Python environment, lock exact dependency versions, and
reproduce the same environment from the lock file.

## Procedure

1. Define direct dependencies in `requirements.in`.
2. Create the first virtual environment.
3. Install the direct dependencies.
4. Use `pip freeze` to create `requirements.lock.txt`.
5. Create a second clean virtual environment.
6. Install only from the lock file.
7. Compare the package lists of the two environments.

## Key Idea

`requirements.in` describes the project's direct dependencies.

`requirements.lock.txt` records exact versions of direct and transitive
dependencies, making the environment reproducible.

## Verification

If `first_env.txt` and `second_env.txt` are identical, the dependency
environment has been reproduced successfully.
