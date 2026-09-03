from versioning import bump


assert bump("1.2.3", "patch") == "1.2.4"
assert bump("1.2.4", "minor") == "1.3.0"
assert bump("1.3.0", "major") == "2.0.0"

try:
    bump("1.2.3", "unknown")
except ValueError:
    pass
else:
    raise AssertionError("invalid change type should raise ValueError")

print("PASS: all semantic version tests passed")
