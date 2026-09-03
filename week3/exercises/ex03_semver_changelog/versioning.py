def bump(version: str, change: str) -> str:
    major, minor, patch = map(int, version.split("."))

    if change == "patch":
        patch += 1
    elif change == "minor":
        minor += 1
        patch = 0
    elif change == "major":
        major += 1
        minor = 0
        patch = 0
    else:
        raise ValueError("change must be patch, minor, or major")

    return f"{major}.{minor}.{patch}"


if __name__ == "__main__":
    version = "1.2.3"

    print("Initial version:", version)

    version = bump(version, "patch")
    print("Bug fix       ->", version)

    version = bump(version, "minor")
    print("New feature   ->", version)

    version = bump(version, "major")
    print("Breaking API  ->", version)
