import os
import sys


def fail(msg: str, code: int = 1) -> None:
    print(f"ERROR: {msg}")
    sys.exit(code)


env = os.getenv("ENVIRONMENT", "dev").strip().lower()
replica_raw = os.getenv("REPLICA_COUNT", "").strip()

# Default replica count for non-prod if not provided
if env != "prod" and replica_raw == "":
    print(f"OK: ENVIRONMENT={env} (defaulting REPLICA_COUNT=1 for non-prod)")
    sys.exit(0)

# For prod (and for any env where it's provided), REPLICA_COUNT must be a valid int
if replica_raw == "":
    fail("REPLICA_COUNT is required")

try:
    replica_count = int(replica_raw)
except ValueError:
    fail(f"REPLICA_COUNT must be an integer, got: {replica_raw!r}")

if replica_count < 1:
    fail("REPLICA_COUNT must be >= 1")

if env == "prod" and replica_count < 3:
    fail("prod requires REPLICA_COUNT >= 3")

print(f"OK: ENVIRONMENT={env}, REPLICA_COUNT={replica_count}")
sys.exit(0)
