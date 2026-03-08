#!/usr/bin/env sh
# ==============================================================================
# NAME: os-detect.sh
# DESCRIPTION: POSIX-compliant script to identify the OS, Distro, and Init system.
# Used by Gemini to adapt command suggestions in real-time.
# ==============================================================================

set -eu

# 1. Base OS Detection (Kernel)
OS_KERNEL="$(uname -s)"
OS_ARCH="$(uname -m)"

# 2. Detailed Distro/Version Detection
DISTRO="Unknown"
VERSION="Unknown"

if [ "$OS_KERNEL" = "Linux" ]; then
    if [ -f /etc/os-release ]; then
        # POSIX way to parse os-release without 'source'
        DISTRO=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
        VERSION=$(grep '^VERSION_ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
    elif [ -f /etc/debian_version ]; then
        DISTRO="debian"
        VERSION=$(cat /etc/debian_version)
    fi
elif [ "$OS_KERNEL" = "OpenBSD" ] || [ "$OS_KERNEL" = "FreeBSD" ]; then
    DISTRO="$OS_KERNEL"
    VERSION="$(uname -r)"
fi

# 3. Virtualization Check (LXC/Docker/Baremetal)
VIRT="baremetal"
if [ "$OS_KERNEL" = "Linux" ]; then
    if [ -f /proc/1/environ ] && grep -qa "container=lxc" /proc/1/environ; then
        VIRT="lxc"
    elif [ -f /.dockerenv ]; then
        VIRT="docker"
    fi
fi

# 4. Final Report for the AI
echo "[System Context Report]"
echo "  - Kernel:   $OS_KERNEL"
echo "  - Arch:     $OS_ARCH"
echo "  - Distro:   $DISTRO"
echo "  - Version:  $VERSION"
echo "  - Environment: $VIRT"

# 5. Internal Flags for Logic Branching
echo "Internal: OS_FAMILY=$(echo "$OS_KERNEL" | tr '[:upper:]' '[:lower:]')"
echo "Internal: PKG_MANAGER=$(case "$DISTRO" in debian|ubuntu) echo "apt";; fedora) echo "dnf";; openbsd) echo "pkg_add";; *) echo "unknown";; esac)"