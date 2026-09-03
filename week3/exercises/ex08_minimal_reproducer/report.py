def validate_records(records, warnings=[]):
    """Validate records and return accumulated warning messages."""
    for index, record in enumerate(records, start=1):
        if "name" not in record:
            warnings.append(f"record {index}: missing name")

        if "score" not in record:
            warnings.append(f"record {index}: missing score")

    return warnings


def build_report(records):
    warnings = validate_records(records)

    return {
        "record_count": len(records),
        "warning_count": len(warnings),
        "warnings": warnings,
    }


def format_report(report):
    lines = [
        f"records={report['record_count']}",
        f"warnings={report['warning_count']}",
    ]

    for warning in report["warnings"]:
        lines.append(f"- {warning}")

    return "\n".join(lines)
