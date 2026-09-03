def summarize_numbers(values):
    if not values:
        raise ValueError("List cannot be empty")
    count = len(values)
    minimum = min(values)
    maximum = max(values)
    average = round(sum(values) / count, 2)
    return {"count": count, "min": minimum, "max": maximum, "average": average}
