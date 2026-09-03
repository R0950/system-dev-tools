def parse_numbers(text):
    """Convert comma-separated text into a list of floats."""
    items = [part.strip() for part in text.split(",")]

    if not items or any(item == "" for item in items):
        raise ValueError("numbers must be a comma-separated list")

    return [float(item) for item in items]
