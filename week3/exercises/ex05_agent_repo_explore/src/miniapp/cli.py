import argparse
import json

from .service import analyze_text


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--numbers", required=True)

    args = parser.parse_args()

    try:
        result = analyze_text(args.numbers)
    except ValueError as exc:
        parser.error(str(exc))

    print(json.dumps(result, sort_keys=True))
