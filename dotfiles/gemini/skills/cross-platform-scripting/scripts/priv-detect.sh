#!/usr/bin/env sh
# ==============================================================================
# NAME: priv-detect.sh
# DESCRIPTION: POSIX script to detect privilege escalation tools (sudo/doas).
# Uses binary checks and dry-run flags to verify user permissions safely.
# ==============================================================================

set -eu

# 1. Detection Logic (Binary existence)
ESC_TOOL="none"
CAN_RUN="false"

if command -v doas >/dev/null 2>&1; then
    ESC_TOOL="doas"
    # Check if the user can at least run the 'check syntax' flag
    # In OpenBSD, 'doas -C config' checks if the user is permitted
    if doas -C /etc/doas.conf >/dev/null 2>&1; then
        CAN_RUN="true"
    fi
elif command -v sudo >/dev/null 2>&1; then
    ESC_TOOL="sudo"
    # 'sudo -n -l' checks for list permissions non-interactively
    if sudo -n -l >/dev/null 2>&1; then
        CAN_RUN="true"
    fi
fi

# 2. Report for the AI
echo "[Privilege Escalation Report]"
echo "  - Available Tool: $ESC_TOOL"
echo "  - Permissions Verified: $CAN_RUN"

# 3. Internal Flags
echo "Internal: PRIV_ESC=$ESC_TOOL"
echo "Internal: CAN_ELEVATE=$CAN_RUN"