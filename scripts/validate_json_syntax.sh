#!/usr/bin/env bash
set -euo pipefail

exit_code=0
for f in $(find spec -name '*.json'); do
  if ! python3 -m json.tool "$f" > /dev/null 2>&1; then
    echo "FAIL: $f"
    exit_code=1
  else
    echo "OK: $f"
  fi
done
exit $exit_code
