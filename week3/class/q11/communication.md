## Issue

环境：Windows；系统版本、Python 版本、greetlab 版本待确认。

复现命令：`sdt-greet --name " "`

期望结果：拒绝纯空白姓名并以退出码 2 结束。

实际结果：输出 `Hello,  !`，并以退出码 0 结束。

## Commit Message

Reject blank names in CLI

Reject whitespace-only `--name` values with argparse so invalid input exits with code 2.

## Review

**Blocking**：当前程序接受纯空白姓名并返回成功，可能使调用方误判输入有效。建议在参数解析阶段拒绝空白姓名，并增加对应测试。
