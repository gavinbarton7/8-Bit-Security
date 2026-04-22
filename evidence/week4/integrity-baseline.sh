#!/bin/bash
# Capture known-good sha256 hashes of agent identity/bootstrap files.
# Run after any intentional edit to these files.

set -euo pipefail

INTEGRITY_DIR="$HOME/.openclaw/integrity"
BASELINE_FILE="$INTEGRITY_DIR/baseline.sha256"

FILES=(
  "$HOME/.openclaw/workspace/AGENTS.md"
  "$HOME/.openclaw/workspace/BOOTSTRAP.md"
  "$HOME/.openclaw/workspace/HEARTBEAT.md"
  "$HOME/.openclaw/workspace/IDENTITY.md"
  "$HOME/.openclaw/workspace/SOUL.md"
  "$HOME/.openclaw/workspace/TOOLS.md"
  "$HOME/.openclaw/workspace/USER.md"
  "$HOME/.openclaw/sandboxes/agent-main-f331f052/AGENTS.md"
  "$HOME/.openclaw/sandboxes/agent-main-f331f052/BOOTSTRAP.md"
  "$HOME/.openclaw/sandboxes/agent-main-f331f052/HEARTBEAT.md"
  "$HOME/.openclaw/sandboxes/agent-main-f331f052/IDENTITY.md"
  "$HOME/.openclaw/sandboxes/agent-main-f331f052/SOUL.md"
  "$HOME/.openclaw/sandboxes/agent-main-f331f052/TOOLS.md"
  "$HOME/.openclaw/sandboxes/agent-main-f331f052/USER.md"
)

TMP_OUT="$(mktemp)"
for f in "${FILES[@]}"; do
  if [[ -f "$f" ]]; then
    sha256sum "$f" >> "$TMP_OUT"
  else
    echo "[baseline] WARN: missing file: $f" >&2
  fi
done

mv "$TMP_OUT" "$BASELINE_FILE"
chmod 400 "$BASELINE_FILE"

echo "[baseline] Captured $(wc -l < "$BASELINE_FILE") hashes to $BASELINE_FILE"
