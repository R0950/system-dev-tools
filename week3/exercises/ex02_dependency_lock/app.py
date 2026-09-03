from importlib.metadata import version

print("Dependency check")
print("requests =", version("requests"))
print("rich     =", version("rich"))
