#!/usr/bin/env sh
# ==============================================================================
# NAME: check-deps.sh
# DESCRIPTION: Universal POSIX dependency checker. 
# USAGE: ./check-deps.sh bin1 bin2 bin3 ...
# ==============================================================================

set -eu

# Function to attempt version detection based on common flags
get_version() {
    bin="$1"
    # Try common version flags in order of popularity
    for flag in "--version" "-version" "version" "-v" "-V"; do
        if out=$("$bin" "$flag" 2>/dev/null | head -n 1); then
            # Clean up output (remove extra spaces/tabs)
            echo "$out" | sed 's/^[[:space:]]*//'
            return 0
        fi
    done
    echo "Unknown version"
}

check_bin() {
    target="$1"
    if command -v "$target" >/dev/null 2>&1; then
        path=$(command -v "$target")
        version=$(get_version "$target")
        printf "  [OK] %-12s | %-30s | %s\n" "$target" "$version" "$path"
    else
        printf "  [FAIL] %-12s | %-30s | NOT FOUND\n" "$target" "N/A"
        return 1
    fi
}

# Main Logic
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <binary1> [binary2] ..."
    echo "Example: $0 ffmpeg python3 git"
    exit 0
fi

echo "[Dependency Audit Report]"
printf "  %-17s | %-30s | %s\n" "BINARY" "VERSION/INFO" "LOCATION"
echo "  --------------------------------------------------------------------------------"

errors=0
for cmd in "$@"; do
    check_bin "$cmd" || errors=$((errors + 1))
done

echo "  --------------------------------------------------------------------------------"
if [ "$errors" -eq 0 ]; then
    echo "Status: All dependencies satisfied."
else
    echo "Status: Missing $errors dependency(ies)."
    exit 1
fi