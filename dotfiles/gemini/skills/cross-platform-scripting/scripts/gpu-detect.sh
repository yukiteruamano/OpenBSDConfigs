#!/usr/bin/env sh
# ==============================================================================
# NAME: gpu-detect.sh
# DESCRIPTION: POSIX script to identify GPU vendor and renderer using glxinfo.
# Fallback for environments where vainfo is missing.
# ==============================================================================

set -eu

# 1. Check if glxinfo is installed
if ! command -v glxinfo >/dev/null 2>&1; then
    echo "Error: glxinfo is not installed or not in PATH." >&2
    exit 1
fi

# 2. Extract GPU information safely
# We use 'sed' to clean up the output and make it easily parsable for the AI.
GPU_INFO=$(glxinfo | grep "OpenGL" | grep -E "vendor string|renderer string")

# 3. Output logic
if [ -n "$GPU_INFO" ]; then
    echo "[GPU Detection Report]"
    echo "$GPU_INFO" | while read -r line; do
        # Clean leading whitespace and print
        echo "  - $(echo "$line" | sed 's/^[[:space:]]*//')"
    done
else
    echo "Status: OpenGL information could not be retrieved via glxinfo."
    exit 1
fi

# 4. Specific Vendor Detection for internal logic
if echo "$GPU_INFO" | grep -iq "Intel"; then
    echo "Internal: INTEL_DETECTED=true"
elif echo "$GPU_INFO" | grep -iq "AMD"; then
    echo "Internal: AMD_RADEON_DETECTED=true"
elif echo "$GPU_INFO" | grep -iq "NVIDIA"; then
    echo "Internal: NVIDIA_DETECTED=true"
fi