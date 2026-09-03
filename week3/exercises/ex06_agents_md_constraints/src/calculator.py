def clamp(value: float, minimum: float, maximum: float) -> float:
    """Limit value to the inclusive range [minimum, maximum]."""
    if minimum > maximum:
        raise ValueError("minimum must not exceed maximum")
    if value < minimum:
        return minimum
    if value > maximum:
        return maximum
    return value


def mean(values: list[float]) -> float:
    """Return the arithmetic mean of a non-empty list."""
    if not values:
        raise ValueError("values must not be empty")
    return sum(values) / len(values)
