# Portable Shell Scripting Guide

This guide outlines best practices for writing shell scripts (Bash, sh, ksh, zsh) that function reliably across Linux, FreeBSD, and OpenBSD environments.

## Shebangs

Using `/usr/bin/env` is mandatory to locate binaries across different system paths (e.g., `/usr/local/bin` on BSD vs `/bin` on Linux).

* **Strict POSIX**: `#!/usr/bin/env sh`
    * *Context*: On OpenBSD this is `ksh`, on Debian it is `dash`. Do not assume `local` support outside simple functions.
* **Bash**: `#!/usr/bin/env bash`
    * *Context*: On OpenBSD, Bash is an external package. Ensure it is installed if the script relies on it.

## GNU vs. BSD Utilities

Core utilities like `sed`, `grep`, `date`, `awk`, and `find` often have different default flags and behaviors between GNU (Linux) and BSD (FreeBSD, OpenBSD, macOS).

### `sed` (In-place Editing)

The `-i` flag is radically different and lacks a compatible syntax between both worlds.

- **Bad (GNU)**: `sed -i 's/a/b/' file`
- **Bad (BSD)**: `sed -i '' 's/a/b/' file`
- **Portable (Recommended)**: Use a temporary file.
    ```bash
    sed 's/foo/bar/g' file > file.tmp && mv file.tmp file
    ```

### `date`

- **Timestamp generation**:
    - **GNU**: `date -d "@$timestamp"`
    - **BSD**: `date -r "$timestamp"`
    - **Portable**: Use Python or Perl for complex date math if `date` flags vary too much.

### `grep` (Regex and Output)

- **Avoid**: `-P` (Perl), `--color`, `-o`.
- **Portability**: Use `-E` (Extended Regex) for complex patterns. If you need to extract specific text, prefer `awk`.

### `find` (Recursion and Deletion)

- **Avoid**: `-maxdepth` (Non-POSIX, though supported by Linux and recent OpenBSD).
- **Portable Depth Limitation**:
    ```bash
    # Instead of find . -maxdepth 1
    find . -name "." -o -prune -name "*.log"
    ```
- **Deletion**: Use `-exec rm {} +` instead of `-delete`.

### `doas` vs `sudo`


## Shell Syntax (Bash vs. POSIX sh)

If targeting `sh`, avoid Bash-isms:

- **Arrays**: `sh` does not support arrays (`arr=(a b c)`).
- **Process Substitution**: `<(command)` is not POSIX sh.
- **Double Brackets**: `[[ ... ]]` is Bash/Ksh/Zsh; use `[ ... ]` for POSIX sh.
- **`local`**: Not strictly POSIX, but widely supported in `sh` implementations (ash, dash).

## Environment Variables

- **PATH**: Ensure critical paths (`/usr/local/bin`, `/usr/bin`, `/bin`) are included.
- **HOME**: Always rely on `$HOME`, not `~` in scripts (though `~` works in most modern shells, `$HOME` is safer).

## Conditionals & Loops

- **String Comparison**: Use `=` for POSIX compatibility (`[ "$a" = "$b" ]`), though `==` works in Bash.
- **Integer Comparison**: Use `-eq`, `-ne`, `-lt`, `-le`, `-gt`, `-ge`.

## Hardware and System Access

| Resource | Linux (Debian/Fedora) | OpenBSD |
| :--- | :--- | :--- |
| **GPU Render** | `/dev/dri/renderD128` | `/dev/dri/renderD128` (Drm) |
| **Sensors** | `/sys/class/thermal/` | `sysctl -n hw.sensors` |
| **CPU Info** | `/proc/cpuinfo` | `sysctl -n hw.model` |

**OS Detection Snippet**:
```bash
case "$(uname -s)" in
    Linux*)   OS="linux" ;;
    OpenBSD*) OS="openbsd" ;;
    FreeBSD*) OS="freebsd" ;;
    *)        OS="unknown" ;;
esac

## Testing

Test your scripts on:
1.  **Linux**: Debian/Ubuntu (uses `dash` as `/bin/sh`), Fedora/RHEL.
2.  **FreeBSD**: Uses `sh` (Almquist shell variant).
3.  **OpenBSD**: Uses `ksh` (Public Domain Korn Shell) as `/bin/sh` and `/bin/ksh`.
