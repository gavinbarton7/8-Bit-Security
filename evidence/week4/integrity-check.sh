#!/bin/bash
# Verify agent identity/bootstrap files against the recorded baseline.
# Writes drift events to ~/.openclaw/logs/integrity-events.jsonl.
# Exits 0 if clean, 1 if drift detected, 2 if baseline missing.

set -u

INTEGRITY_DIR="$HOME/.openclaw/integrity"
BASELINE_FILE="$INTEGRITY_DIR/baseline.sha256"
LOG_FILE="$HOME/.openclaw/logs/integrity-events.jsonl"
TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)"

if [[ ! -f "$BASELINE_FILE" ]]; then
  echo "{\"timestamp\":\"$TIMESTAMP\",\"event\":\"baseline_missing\",\"path\":\"$BASELINE_FILE\"}" >> "$LOG_FILE"
  echo "[integrity] ERROR: baseline not found at $BASELINE_FILE. Run baseline.sh first." >&2
  exit 2
fi

DRIFT_COUNT=0

while IFS= read -r line; do
  expected_hash="${line%% *}"
  filepath="${line#*  }"

  if [[ ! -f "$filepath" ]]; then
    echo "{\"timestamp\":\"$TIMESTAMP\",\"event\":\"file_missing\",\"path\":\"$filepath\",\"expectedHash\":\"$expected_hash\"}" >> "$LOG_FILE"
    DRIFT_COUNT=$((DRIFT_COUNT + 1))
    continue
  fi

  actual_hash="$(sha256sum "$filepath" | awk '{print $1}')"
  if [[ "$actual_hash" != "$expected_hash" ]]; then
    echo "{\"timestamp\":\"$TIMESTAMP\",\"event\":\"hash_drift\",\"path\":\"$filepath\",\"expectedHash\":\"$expected_hash\",\"actualHash\":\"$actual_hash\"}" >> "$LOG_FILE"
    DRIFT_COUNT=$((DRIFT_COUNT + 1))
  fi
done < "$BASELINE_FILE"

if [[ $DRIFT_COUNT -gt 0 ]]; then
  echo "[integrity] DRIFT DETECTED: $DRIFT_COUNT file(s) changed. See $LOG_FILE" >&2
  exit 1
fi

exit 0
