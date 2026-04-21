#!/usr/bin/env bash
set -euo pipefail

VIRT_SINK="virt_mic"
COMBINED_SINK="combined_mic"

# ---------------------------------------------------------------------------
# Resolve real microphone source (skip monitors, prefer default)
# Override by setting REAL_MIC env var: REAL_MIC=my_source ./setup-virt-mic.sh
# ---------------------------------------------------------------------------
if [[ -n "${REAL_MIC:-}" ]]; then
    echo "Using overridden microphone: $REAL_MIC"
else
    REAL_MIC=$(pactl get-default-source)
    if [[ "$REAL_MIC" == *.monitor ]]; then
        # Default is a monitor — find the first real source instead
        REAL_MIC=$(pactl list sources short | awk '{print $2}' | grep -v '\.monitor' | head -1)
        if [[ -z "$REAL_MIC" ]]; then
            echo "Error: could not detect a real microphone source."
            echo "Set REAL_MIC=<source-name> and re-run."
            exit 1
        fi
        echo "Warning: default source was a monitor; using '$REAL_MIC' instead."
        echo "Override with: REAL_MIC=<source-name> $0"
    fi
    echo "Using microphone: $REAL_MIC"
fi

# ---------------------------------------------------------------------------
# Virtual sink: audio played by play-to-virt-mic.sh goes here
# ---------------------------------------------------------------------------
if pactl list sinks short | grep -q "^[0-9]*[[:space:]]*${VIRT_SINK}[[:space:]]"; then
    echo "Virtual sink '$VIRT_SINK' already exists, skipping."
else
    pactl load-module module-null-sink \
        sink_name="$VIRT_SINK" \
        sink_properties="device.description='VirtualMic' device.class='filter'"
    echo "Created virtual sink: $VIRT_SINK"
fi

# ---------------------------------------------------------------------------
# Combined sink: merges real mic + played audio — point voice call here
# ---------------------------------------------------------------------------
if pactl list sinks short | grep -q "^[0-9]*[[:space:]]*${COMBINED_SINK}[[:space:]]"; then
    echo "Combined sink '$COMBINED_SINK' already exists, skipping."
else
    pactl load-module module-null-sink \
        sink_name="$COMBINED_SINK" \
        sink_properties="device.description='CombinedMic' device.class='filter'"
    echo "Created combined sink: $COMBINED_SINK"
fi

# ---------------------------------------------------------------------------
# Remap sources: expose sink monitors as proper microphone source devices
# ---------------------------------------------------------------------------
remap_source() {
    local source_name="$1" master="$2" description="$3"
    if pactl list sources short | grep -q "^[0-9]*[[:space:]]*${source_name}[[:space:]]"; then
        echo "Remap source '$source_name' already exists, skipping."
    else
        pactl load-module module-remap-source \
            source_name="$source_name" \
            master="$master" \
            source_properties=device.description="$description"
        echo "Created source: $source_name ($description)"
    fi
}

remap_source "combined_mic_source" "${COMBINED_SINK}.monitor" "CombinedMic"

# ---------------------------------------------------------------------------
# Loopbacks — each is skipped if an identical one already exists
# ---------------------------------------------------------------------------
load_loopback() {
    local source="$1" sink="$2" label="$3"
    if pactl list modules short | grep -q "module-loopback.*source=${source}.*sink=${sink}"; then
        echo "Loopback '$label' already exists, skipping."
    else
        pactl load-module module-loopback \
            source="$source" sink="$sink" latency_msec=50
        echo "Created loopback: $label"
    fi
}

# Real mic -> combined
load_loopback "$REAL_MIC" "$COMBINED_SINK" "real mic -> combined_mic"

# Played sounds -> combined
load_loopback "${VIRT_SINK}.monitor" "$COMBINED_SINK" "virt_mic -> combined_mic"

# Played sounds -> speakers (so you hear them locally)
load_loopback "${VIRT_SINK}.monitor" "@DEFAULT_SINK@" "virt_mic -> speakers"

echo ""
echo "Done. In your voice call app, set the microphone to:"
echo "  'CombinedMic'"
