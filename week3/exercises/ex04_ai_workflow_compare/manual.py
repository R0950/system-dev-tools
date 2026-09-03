def summarize_numbers(values):
    """Return count, min, max and average for a list of numbers."""
    if not values:
        raise ValueError("values must not be empty")

    return {
        "count": len(values),
        "min": min(values),
        "max": max(values),
        "average": round(sum(values) / len(values), 2),
    }
