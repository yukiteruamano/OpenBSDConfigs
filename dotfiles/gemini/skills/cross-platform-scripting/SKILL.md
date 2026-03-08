---
name: cross-platform-scripting
description: Expert guidance on cross-platform shell scripting (Bash, Sh, Ksh, Zsh, Python) and automation for Linux, FreeBSD, and OpenBSD.
---

# Cross-Platform Scripting & Automation

This skill provides expert guidance and reusable resources for creating robust, portable scripts across Linux, FreeBSD, and OpenBSD environments. It covers shell scripting (Bash, Sh, Ksh, Zsh), Python automation, and specialized tasks like FFmpeg hardware acceleration.

## Portable Shell Scripting

Writing scripts that work seamlessly across different operating systems requires careful consideration of shell syntax and utility differences.

- **Portability Guide**: See [references/shell-portability.md](references/shell-portability.md) for detailed guidelines on writing portable shell scripts.
- **Key Considerations**:
    - Use `#!/usr/bin/env <shell>` for portability.
    - Avoid GNU-specific flags in standard utilities (`sed`, `grep`, `date`) unless you can guarantee GNU tools are installed.
    - Test on all target platforms if possible.

## FFmpeg & Hardware Acceleration

Automating video processing often requires leveraging hardware acceleration, which varies significantly by OS and hardware.

- **Hardware Acceleration Guide**: See [references/ffmpeg-hwaccel.md](references/ffmpeg-hwaccel.md) for details on VAAPI, NVENC, QSV, and OS-specific implementations.
- **Usage**: Use this guide to determine the correct FFmpeg flags and device paths for your target environment.

## Python & AI Automation

Optimized for developing AI agents and virtual background projects.

- **Environment**: Enforce `venv` usage on Debian to maintain system stability.
- **Patterns**: Use `signal` for graceful agent shutdowns and `logging` for headless automation.
- **Best Practices**: Refer to [references/python-api-best-practices.md] for robust API interactions.

## Internal Tools (Scripts)

The following scripts allow Gemini to gather real-time system context:

- `scripts/os-detect.sh`: Identifies the OS, version, and architecture.
- `scripts/priv-detect.sh`: Detects `sudo` vs `doas` and verifies user permissions.
- `scripts/gpu-detect.sh`: Identifies the GPU vendor/renderer via `glxinfo`.
- `scripts/check-deps.sh`: Audits a list of required binaries and detects their versions.
    - **Usage**: `scripts/check-deps.sh bin1 bin2 ...`
    - **Context**: Useful to verify the environment before suggesting a complex multi-tool command.

## General Best Practices

1.  **Idempotency**: Ensure your scripts can be run multiple times without causing unintended side effects.
2.  **Error Handling**: Always check for errors and fail gracefully. Use `set -e` in shell scripts where appropriate.
3.  **Logging**: Implement logging to track script execution and debug issues.
4.  **Security**: Never hardcode credentials. Use environment variables or secure configuration files.
