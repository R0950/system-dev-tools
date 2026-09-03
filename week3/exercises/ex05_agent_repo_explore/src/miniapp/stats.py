def summarize(values):
    """Return basic statistics for a non-empty sequence."""
    if not values:
        raise ValueError("values must not be empty")

    return {
        "count": len(values),
        "min": min(values),
        "max": max(values),
        "average": round(sum(values) / len(values), 2),
    }
