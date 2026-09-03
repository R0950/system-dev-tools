# AI Analysis — ex08 Minimal Reproducer

## 1. Root cause

`report.py` 的 `validate_records` 使用了**可变默认参数**：

```python
def validate_records(records, warnings=[]):
```

Python 对函数默认参数的处理是：默认值表达式只在**函数定义时求值一次**，
结果对象被永久绑定到该函数的 `__defaults__`。因此 `warnings=[]` 的默认
列表在模块被 import 时创建，之后**所有**未显式传入 `warnings` 的调用
共享的是同一个 list 对象。

函数体内的 `warnings.append(...)` 是原地修改，会改动这个共享对象。于是：

1. 第一次用无效记录调用时，告警被 append 进共享列表；
2. 后续调用（即使记录完全干净、无需新增任何告警）返回的仍是同一个列表，
   其中已经残留着前一次调用的告警。

这就造成 bug_report.md 描述的症状："A clean record sometimes reports
warnings from an earlier validation."

## 2. Why the bug persists across function calls

默认列表的生命周期不受调用结束影响：

- 它不在调用栈上创建，而是在**函数定义时**（`import report` 阶段）创建；
- 它保存在函数对象的 `__defaults__` 元组中，只要函数对象活着，列表就活着；
- 每次调用结束只丢弃局部变量 `record`、`index` 等，被 append 进默认列表的
  内容不会随调用结束被回收。

所以只要 `validate_records` 在调用时省略 `warnings` 参数（`build_report`
内部正是这样调用的：`warnings = validate_records(records)`），它就必然拿到
那个积累了全部历史告警的共享列表。状态跨越函数调用、跨过 `build_report`
的多次调用持续累积，导致先跑"无效记录"再跑"干净记录"时，干净记录也会
返回旧告警。

## 3. Which parts of the original project were irrelevant

复现本 bug 只需要"带默认列表参数并 append 的函数 + 连续两次调用（一次
触发追加、一次干净）"。以下部分与缺陷无关，已从 `minimal_reproducer.py`
中剔除：

- `records` / `record` 字典数据结构，以及校验所需的 `"name"` / `"score"`
  字段；
- `enumerate(..., start=1)` 序号和 `"record {index}: ..."` 这类告警文案
  拼接；
- `build_report` 的 dict 包装（`record_count` / `warning_count` /
  `warnings`）；
- `format_report` 的文本格式化逻辑；
- 测试框架结构（unittest 类、断言顺序、字母序执行等）；
- 工程目录、模块导入关系。

去掉这些之后，只剩根因本身：一个 `def validate(invalid, warnings=[])`
函数、一次 `validate(True)` 修改默认列表、一次 `validate(False)` 复现泄漏。

## 4. Why minimal_reproducer.py demonstrates the same underlying defect

`minimal_reproducer.py` 与被测代码共享**完全相同的缺陷机制**：

- 函数签名与生产代码同构：`def validate_records(records, warnings=[])`
  被精简为 `def validate(invalid, warnings=[])`——都是"必传参数 + 可变
  默认列表参数"，且调用时都省略第二个参数；
- 同样在未显式传入 `warnings` 时对默认列表做原地 append 并返回它；
- 调用序列复刻 bug 报告场景：第一次 `validate(True)`（产生一条告警），
  第二次 `validate(False)`（干净、不追加任何内容，本应返回空列表）。

运行脚本时，第二次调用打印出的结果是 `['warning']`，而期望是 `[]`——与
原始测试 `test_validate_records_directly` 的失败本质一致（残留告警
`!= []`）。因此它复现的是同一个根因，而不是某种表面相似但成因不同的行为。

## 5. How the production bug should eventually be fixed (report.py NOT modified)

正确的修复方式是**避免使用可变对象作为默认值**：改用 `None` 作哨兵，
在函数体内为每次调用创建全新的列表。这样每次未显式传入 `warnings` 的
调用都从空列表开始，历史告警不会再泄漏到后续调用：

```python
def validate_records(records, warnings=None):
    """Validate records and return accumulated warning messages."""
    if warnings is None:
        warnings = []
    for index, record in enumerate(records, start=1):
        if "name" not in record:
            warnings.append(f"record {index}: missing name")
        if "score" not in record:
            warnings.append(f"record {index}: missing score")
    return warnings
```

显式传入列表的调用（如需要累积到既有列表）行为保持不变，向后兼容。

依据任务要求，以上修复**暂未写入 `report.py`**；本次只创建了
`minimal_reproducer.py` 与本文档，生产代码保持原始状态以便演示 bug。
