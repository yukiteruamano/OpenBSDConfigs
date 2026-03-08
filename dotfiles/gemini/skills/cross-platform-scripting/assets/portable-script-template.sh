#!/usr/bin/env sh
# ==============================================================================
# NAME: portable-task-runner.sh
# DESCRIPTION: A POSIX-compliant boilerplate for cross-platform automation.
# COMPATIBILITY: OpenBSD (ksh), Debian (dash), Fedora (bash), FreeBSD (sh).
# ==============================================================================

# 1. Exit immediately on error, treat unset variables as an error
set -eu

# 2. OS Detection
OS_TYPE="$(uname -s)"
readonly OS_TYPE

# 3. Resource Cleanup (Graceful Shutdown)
cleanup() {
    echo ""
    echo "[!] Signal received. Cleaning up temporary files..."
    # Add logic to stop background processes or remove temp files
    exit 0
}

# Trap SIGINT (Ctrl+C) and SIGTERM
trap cleanup INT TERM

# 4. Environment / Configuration
# Use default values if environment variables are not set
LOG_LEVEL="${LOG_LEVEL:-INFO}"
TEMP_DIR="/tmp/automation_$(date +%s)"

# 5. Helper: Cross-platform Hardware Check
check_hardware() {
    echo "[*] Checking hardware for: $OS_TYPE"
    case "$OS_TYPE" in
        Linux*)
            [ -e /dev/dri/renderD128 ] && echo "-> Intel GPU detected (Linux VAAPI)"
            ;;
        OpenBSD*)
            [ -e /dev/dri/renderD128 ] && echo "-> Intel GPU detected (OpenBSD DRM)"
            ;;
        *)
            echo "-> Generic hardware profile loaded."
            ;;
    esac
}

# 6. Helper: Portable 'In-place' Edit logic
# Avoids the incompatible 'sed -i' across GNU/BSD
safe_edit() {
    local pattern="$1"
    local target="$2"
    sed "$pattern" "$target" > "$target.tmp" && mv "$target.tmp" "$target"
}

# 7. Main Execution Logic
main() {
    echo "[+] Starting script on $OS_TYPE..."
    
    check_hardware
    
    # Example of portable logging
    printf "[%s] [%s] Script initialized.\n" "$(date +%H:%M:%S)" "$LOG_LEVEL"
    
    # Add your automation logic here
}

# Execute main
main "$@"