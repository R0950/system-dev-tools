from .io import parse_numbers
from .stats import summarize


def analyze_text(text):
    values = parse_numbers(text)
    return summarize(values)
