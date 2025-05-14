#!/bin/bash
export NOTMUCH_CONFIG="/Users/jose/jose/soadmail/notmuch-config"
LOG="$HOME/.cache/mail-sync.log"

echo "[$(date)] Sync iniciado" >> "$LOG"
mbsync -a >> "$LOG" 2>&1
notmuch new >> "$LOG" 2>&1
echo "[$(date)] Sync terminado" >> "$LOG"

