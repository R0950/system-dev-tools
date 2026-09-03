import argparse
from pathlib import Path


def analyze_text(text: str) -> dict[str, int]:
    return {
        "lines": len(text.splitlines()),
        "words": len(text.split()),
        "characters": len(text),
    }


def analyze_file(path: str) -> dict[str, int]:
    file_path = Path(path)

    if not file_path.is_file():
        raise FileNotFoundError(path)

    return analyze_text(file_path.read_text(encoding="utf-8"))


def main():
    parser = argparse.ArgumentParser(
        description="Count lines, words and characters in a UTF-8 text file."
    )
    parser.add_argument("file", help="path to a UTF-8 text file")
    args = parser.parse_args()

    try:
        result = analyze_file(args.file)
    except FileNotFoundError:
        parser.error(f"file not found: {args.file}")

    print(f"lines={result['lines']}")
    print(f"words={result['words']}")
    print(f"characters={result['characters']}")


if __name__ == "__main__":
    main()
