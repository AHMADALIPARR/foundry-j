#!/usr/bin/env bash
# Copyright (C) 2026 Foundry J contributors
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# Run the Foundry J verification suite and capture real stdout.
set -u
cd "$(dirname "$0")"

JCONSOLE="${JCONSOLE:-/home/box/j/j9.7/bin/jconsole}"
if [[ ! -x "$JCONSOLE" ]]; then
  if [[ -x /home/box/j/j9.7/jconsole.sh ]]; then
    JCONSOLE=/home/box/j/j9.7/jconsole.sh
  else
    echo "FAIL harness: jconsole not found at $JCONSOLE" >&2
    exit 1
  fi
fi

TS="$(date '+%Y%m%d-%H%M%S')"
LOG="logs/run-${TS}.log"
mkdir -p logs

echo "Using jconsole: $JCONSOLE" | tee "$LOG"
echo "Working directory: $(pwd)" | tee -a "$LOG"
echo "Timestamp (PT): $(date '+%Y-%m-%d %H:%M:%S %Z')" | tee -a "$LOG"
echo "Core present: $([[ -d ../j ]] && echo yes || echo no)" | tee -a "$LOG"
echo "────────────────────────────────────────" | tee -a "$LOG"

set +e
"$JCONSOLE" run.ijs 2>&1 | tee -a "$LOG"
RC=${PIPESTATUS[0]}
set -e

echo "────────────────────────────────────────" | tee -a "$LOG"
echo "exit_code=$RC" | tee -a "$LOG"
echo "log=$LOG" | tee -a "$LOG"
exit "$RC"
