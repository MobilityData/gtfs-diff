#!/usr/bin/env bash
set -euo pipefail

exit_code=0
for schema_dir in spec/*/json_schema; do
  version_dir=$(dirname "$schema_dir")
  examples_dir="$version_dir/examples"
  schema_file=$(find "$schema_dir" -name '*.json' | head -1)

  if [ -z "$schema_file" ] || [ ! -d "$examples_dir" ]; then
    continue
  fi

  echo "Schema: $schema_file"
  for example in "$examples_dir"/*.json; do
    echo "  Validating: $example"
    if python3 -c "
import json, jsonschema, sys
with open('$schema_file') as f:
    schema = json.load(f)
with open('$example') as f:
    instance = json.load(f)
try:
    jsonschema.validate(instance, schema)
    print('    PASS')
except jsonschema.ValidationError as e:
    print(f'    FAIL: {e.message}')
    sys.exit(1)
"; then
      :
    else
      exit_code=1
    fi
  done
done
exit $exit_code
