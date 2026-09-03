# ex04 - Compare AI Coding Workflows

## Goal

Compare four ways of completing the same programming task:

- manual coding
- AI autocomplete
- AI chat
- coding agent

All implementations use the same specification and verification program.

## Task

Implement `summarize_numbers(values)`.

The function returns count, minimum, maximum and average, and raises
`ValueError` for an empty input list.

## Verification

Each implementation is tested with the same command:

`python3 verify.py implementation.py`

Using the same tests makes the comparison reproducible.

## Files

- `task_spec.md`: common programming requirement
- `manual.py`: manual implementation
- `autocomplete.py`: autocomplete implementation
- `chat.py`: chat-assisted implementation
- `agent.py`: coding-agent implementation
- `verify.py`: shared verification program
- `comparison.md`: workflow comparison
