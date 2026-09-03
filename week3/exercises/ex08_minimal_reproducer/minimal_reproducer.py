"""最小复现器：可变默认列表参数导致状态跨调用泄漏（与 report.py 同根因）。

`warnings=[]` 只在函数定义时求值一次，之后未显式传入 warnings 的调用共享
同一个列表。第一次调用 append 的告警残留在默认列表中，第二次调用即使没有
新增内容，也仍会看到第一次留下的内容。仅使用标准库，不 import report.py。
"""


def validate(invalid, warnings=[]):
    if invalid:
        warnings.append("warning")
    return warnings


first = validate(True)   # 第一次调用：修改默认列表，追加一条告警
print("1st call (invalid) ->", first)

second = validate(False)  # 第二次调用：没有修改默认列表
print("2nd call (clean)   ->", second)
print("expected           ->", [])

# bug 存在时第二次调用本应返回 []，断言失败使脚本以非 0 状态退出
assert second == [], f"second call returned {second!r}, expected []"
