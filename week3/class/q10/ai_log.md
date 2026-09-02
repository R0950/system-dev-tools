核心提示：要求纯空白 --name 以 SystemExit(2) 结束，只做最小修改，并运行指定 pytest。
智能体改动：使用 argparse.ArgumentTypeError 为 --name 增加纯空白输入校验。
人工检查：使用 git diff 检查修改，确认未修改测试且无无关改动。
人工验证：再次运行 PYTHONPATH=src python -m pytest -q，结果为 1 passed。
