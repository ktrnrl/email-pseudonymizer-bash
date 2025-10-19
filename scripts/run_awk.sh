#!/usr/bin/env bash
set -euo pipefail
ROOTS=("$@"); [ ${#ROOTS[@]} -gt 0 ] || ROOTS=("test-data")
while IFS= read -r -d '' f; do
  tmp="${f}.tmp"
  awk -f "$(dirname "$0")/json_name_to_title.awk" "$f" > "$tmp"
  mv "$tmp" "$f"
  echo "✓ $f"
done < <(find "${ROOTS[@]}" -type f -name '*.json' -print0)
