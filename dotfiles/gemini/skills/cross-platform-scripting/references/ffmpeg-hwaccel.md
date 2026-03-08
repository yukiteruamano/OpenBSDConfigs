# FFmpeg Hardware Acceleration Guide

This guide details common hardware acceleration methods for FFmpeg across Linux, FreeBSD, and OpenBSD, including detection and usage examples.

## Supported Hardware & OS

| Method | Description | Linux | FreeBSD | OpenBSD |
| :--- | :--- | :--- | :--- | :--- |
| **VAAPI** | Video Acceleration API (Intel/AMD) | ✅ (kernel/mesa) | ✅ (libva/mesa) | ✅ (limited/Intel) |
| **NVENC** | NVIDIA Encoder | ✅ (drivers) | ✅ (drivers) | ❌ (check docs) |
| **QSV** | Intel Quick Sync Video | ✅ (kernel/media-driver) | ❌ (limited/check) | ❌ |
| **V4L2** | Video4Linux2 (Raspberry Pi/others) | ✅ | ❌ | ❌ |

## Detection

### Linux
- **VAAPI**: `vainfo` (package `libva-utils`)
- **NVENC**: `nvidia-smi`
- **QSV**: Check `/dev/dri/renderD128` and `lsmod | grep i915`

### FreeBSD
- **VAAPI**: `vainfo` (package `libva-utils`). Ensure `drm-kmod` is loaded.
- **NVENC**: Check `nvidia-driver` package and `/dev/nvidia*`.

### OpenBSD
- **VAAPI**: Check `dmesg | grep inteldrm` and `/dev/drm*`. Ensure `intel-firmware` is installed. Acceleration support varies by GPU generation.

## FFmpeg Command Examples

### VAAPI (Linux/FreeBSD/OpenBSD)

Common flags: `-hwaccel vaapi -hwaccel_output_format vaapi -vaapi_device /dev/dri/renderD128`

**Example (Transcode to H.264):**
```bash
ffmpeg -hwaccel vaapi -hwaccel_output_format vaapi -vaapi_device /dev/dri/renderD128 \
  -i input.mp4 -vf 'format=nv12,hwupload' -c:v h264_vaapi -b:v 2M output.mp4
```

### NVENC (Linux/FreeBSD)

Common flags: `-c:v h264_nvenc` or `-c:v hevc_nvenc`

**Example (Transcode to H.264):**
```bash
ffmpeg -i input.mp4 -c:v h264_nvenc -preset p4 -b:v 2M output.mp4
```

### QSV (Linux - Intel)

Common flags: `-hwaccel qsv -c:v h264_qsv`

**Example (Transcode to H.264):**
```bash
ffmpeg -hwaccel qsv -c:v h264_qsv -i input.mp4 -b:v 2M output.mp4
```

## Troubleshooting Tips

1.  **Permissions**: Ensure the user is in the `video` or `render` group to access `/dev/dri/*`.
2.  **Drivers**: Verify correct drivers (Mesa, NVIDIA, Intel Media Driver) are installed.
3.  **Codecs**: Check supported codecs with `ffmpeg -codecs | grep <codec>`.
