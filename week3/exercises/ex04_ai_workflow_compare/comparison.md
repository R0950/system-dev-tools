# AI Coding Workflow Comparison

| Method | File | Verification | Observation |
|---|---|---|---|
| Manual coding | manual.py | PASS | Implemented directly without AI assistance |
| AI completion | autocomplete.py | PASS | DeepSeek API generated code from function context; the first result failed verification and was corrected using test feedback |
| AI chat | chat.py | PASS | DeepSeek Chat suggested an implementation which was reviewed and applied manually |
| Coding agent | agent.py | PASS | DeepSeek-based coding agent edited the target file and verified it automatically |

## Conclusion

All four implementations passed the same verification program.

Manual coding provides direct control. AI completion can quickly generate local
code, but generated results still require testing because the first completion
returned the wrong data structure. AI chat is useful for discussing and reviewing
a solution before applying it. A coding agent can inspect project files, modify
code, run tests and iterate automatically.

This exercise shows that AI-assisted programming still requires reproducible
tests and human verification.
