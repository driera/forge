#!/usr/bin/env bash
# Returns the next sequential ADR number as a zero-padded 3-digit string (e.g. "003").
# Usage: ./next-number.sh [directory]
# Defaults to docs/ADRs/ relative to the current working directory.

DIR="${1:-docs/ADRs}"

if [ ! -d "$DIR" ]; then
  echo "001"
  exit 0
fi

LAST=$(ls "$DIR"/*.md 2>/dev/null | grep -oE '^[^/]*/[0-9]+' | grep -oE '[0-9]+$' | sort -n | tail -1)

if [ -z "$LAST" ]; then
  echo "001"
else
  printf "%03d\n" $((10#$LAST + 1))
fi
