import sys
from pathlib import Path

if len(sys.argv) != 3:
    print("Usage: python3 generate_data.py OUTPUT NUMBER_OF_LINES")
    raise SystemExit(2)

output = Path(sys.argv[1])
count = int(sys.argv[2])

with output.open("w", encoding="utf-8") as f:
    for i in range(count):
        if i % 20 == 0:
            f.write(
                f"ERROR request={i} "
                f"service=api latency_ms={100 + i % 900}\n"
            )
        else:
            f.write(
                f"INFO request={i} "
                f"service=api latency_ms={20 + i % 200}\n"
            )

print(f"generated={count}")
print(f"output={output}")
