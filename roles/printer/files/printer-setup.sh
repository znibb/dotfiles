#!/usr/bin/env bash
#
# Interactive CUPS printer discovery + setup.
# Mirrors the manual workflow: check CUPS/avahi are running, discover
# network/USB printers, let you pick one, add it via lpadmin, then
# optionally send a test page.

set -uo pipefail

# ---------------------------------------------------------------------------
# small helpers
# ---------------------------------------------------------------------------

info()  { printf '==> %s\n' "$*"; }
warn()  { printf '!!  %s\n' "$*" >&2; }
err()   { printf 'xx  %s\n' "$*" >&2; }

ask() { # ask "prompt" "default"  -> echoes answer
    local prompt="$1" default="${2:-}" reply
    if [[ -n "$default" ]]; then
        read -r -p "$prompt [$default]: " reply
        echo "${reply:-$default}"
    else
        read -r -p "$prompt: " reply
        echo "$reply"
    fi
}

confirm() { # confirm "prompt" [default y/n] -> 0=yes 1=no
    local prompt="$1" default="${2:-y}" reply
    read -r -p "$prompt [$default]: " reply
    reply="${reply:-$default}"
    [[ "$reply" =~ ^[Yy] ]]
}

urldecode() {
    local data="${1//+/ }"
    printf '%b' "${data//%/\\x}"
}

# avahi-browse -p emits names with DNS-SD style backslash-decimal escapes
# (e.g. "\032" for a space, "\040"/"\041" for parens) rather than % escapes.
decode_avahi_name() {
    local s="$1"
    local out="" i=0 c code dec ch
    local n=${#s}
    while (( i < n )); do
        c="${s:i:1}"
        if [[ "$c" == '\' && "${s:i+1:3}" =~ ^[0-9]{3}$ ]]; then
            code="${s:i+1:3}"
            dec=$((10#$code))
            printf -v ch "\\$(printf '%03o' "$dec")"
            out+="$ch"
            i=$((i+4))
        else
            out+="$c"
            i=$((i+1))
        fi
    done
    printf '%s' "$out"
}

require_cmd() {
    command -v "$1" &>/dev/null || { err "Required command '$1' not found. Install cups (and cups-filters) first."; exit 1; }
}

# ---------------------------------------------------------------------------
# init system detection (systemd / openrc / sysvinit "service")
# ---------------------------------------------------------------------------

detect_init() {
    if command -v systemctl &>/dev/null && [[ -d /run/systemd/system ]]; then
        echo systemd
    elif command -v rc-service &>/dev/null; then
        echo openrc
    elif command -v service &>/dev/null; then
        echo service
    else
        echo unknown
    fi
}

service_is_active() {
    local svc="$1"
    case "$INIT" in
        systemd) systemctl is-active --quiet "$svc" ;;
        openrc)  rc-service "$svc" status 2>/dev/null | grep -q started ;;
        service) service "$svc" status &>/dev/null ;;
        *) return 1 ;;
    esac
}

service_start() {
    local svc="$1"
    case "$INIT" in
        systemd) sudo systemctl start "$svc" ;;
        openrc)  sudo rc-service "$svc" start ;;
        service) sudo service "$svc" start ;;
        *) warn "Don't know how to start '$svc' on this init system, please start it yourself."; return 1 ;;
    esac
}

ensure_service_running() {
    local svc="$1" label="$2"
    if service_is_active "$svc"; then
        info "$label is running."
        return 0
    fi
    warn "$label does not appear to be running."
    if confirm "Start $label now?" y; then
        service_start "$svc" && info "$label started." || { err "Could not start $label."; return 1; }
    else
        warn "Continuing without $label; discovery or printing may not work."
    fi
}

# ---------------------------------------------------------------------------
# discovery
# ---------------------------------------------------------------------------

extract_name_from_uri() {
    local uri="$1" rest namepart
    rest="${uri#*://}"
    namepart="${rest%%._*}"
    if [[ "$namepart" == "$rest" ]]; then
        namepart="${rest%%/*}"
    fi
    urldecode "$namepart"
}

# populates DISPLAY_NAMES / DISPLAY_URIS / DISPLAY_KINDS
# Identity key is the IP address where we have one (from avahi or from a
# socket/lpd URI), so the same physical printer never shows up twice under
# a friendly name AND a bare IP. USB devices key on their own URI since
# they have no IP to dedupe on.
discover_printers() {
    DISPLAY_NAMES=(); DISPLAY_URIS=(); DISPLAY_KINDS=()
    local -A best_pri=() best_uri=() best_kind=() best_name=()

    if command -v avahi-browse &>/dev/null; then
        # type : priority : uri-scheme : path (or __PORT__ for raw socket) : kind
        local specs=(
            "_ipps._tcp:1:ipps:ipp/print:driverless"
            "_ipp._tcp:2:ipp:ipp/print:driverless"
            "_printer._tcp:3:lpd:lp:raw"
            "_pdl-datastream._tcp:3:socket:__PORT__:raw"
        )
        local spec svc_type pri scheme path kind
        local action iface proto raw_name svctype domain host address port rest
        for spec in "${specs[@]}"; do
            IFS=: read -r svc_type pri scheme path kind <<<"$spec"
            while IFS=';' read -r action iface proto raw_name svctype domain host address port rest; do
                [[ "$action" == "=" ]] || continue
                [[ "$proto" == "IPv4" ]] || continue
                [[ -n "$address" ]] || continue
                if [[ -z "${best_pri[$address]:-}" ]] || (( pri < best_pri[$address] )); then
                    local uri
                    if [[ "$path" == "__PORT__" ]]; then
                        uri="${scheme}://${address}:${port}"
                    else
                        uri="${scheme}://${address}/${path}"
                    fi
                    best_pri[$address]=$pri
                    best_uri[$address]="$uri"
                    best_kind[$address]="$kind"
                    best_name[$address]="$(decode_avahi_name "$raw_name")"
                fi
            done < <(avahi-browse -tpr "$svc_type" 2>/dev/null)
        done
    fi

    # supplement with lpinfo -v: USB devices (no IP to dedupe on), and any
    # raw network printer avahi didn't advertise (e.g. SNMP-discovered only)
    local line uri2 scheme2 host2 pri2 kind2 name2
    while IFS= read -r line; do
        uri2="$(awk '{print $2}' <<<"$line")"
        [[ "$uri2" == *"://"* ]] || continue
        scheme2="${uri2%%:*}"
        case "$scheme2" in
            usb)
                name2="$(extract_name_from_uri "$uri2")"
                [[ -n "$name2" ]] || name2="$uri2"
                best_pri["usb:$uri2"]=0
                best_uri["usb:$uri2"]="$uri2"
                best_kind["usb:$uri2"]="usb"
                best_name["usb:$uri2"]="$name2"
                ;;
            socket|lpd|http|https|smb|beh)
                host2="${uri2#*://}"
                host2="${host2%%[:/]*}"
                [[ -n "${best_uri[$host2]:-}" ]] && continue   # already found via avahi
                best_pri[$host2]=4
                best_uri[$host2]="$uri2"
                best_kind[$host2]="raw"
                best_name[$host2]="$host2"
                ;;
        esac
    done < <(lpinfo -v 2>/dev/null)

    local entries=() e key
    for key in "${!best_uri[@]}"; do
        entries+=("${best_name[$key]}|${best_uri[$key]}|${best_kind[$key]}")
    done
    IFS=$'\n' entries=($(sort <<<"${entries[*]:-}")); unset IFS

    for e in "${entries[@]}"; do
        [[ -n "$e" ]] || continue
        DISPLAY_NAMES+=("${e%%|*}")
        e="${e#*|}"
        DISPLAY_URIS+=("${e%%|*}")
        DISPLAY_KINDS+=("${e##*|}")
    done
}

kind_label() {
    case "$1" in
        usb)        echo "USB, direct" ;;
        driverless) echo "network, driverless (IPP)" ;;
        raw)        echo "network, raw/legacy - driver may be required" ;;
        *)          echo "unknown" ;;
    esac
}

# ---------------------------------------------------------------------------
# queue name sanitizing
# ---------------------------------------------------------------------------

sanitize_name() {
    local n="$1"
    n="${n// /-}"
    n="$(sed 's/[^A-Za-z0-9._-]//g' <<<"$n")"
    [[ -n "$n" ]] || n="printer"
    echo "$n"
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

require_cmd lpinfo
require_cmd lpadmin
require_cmd lpstat
require_cmd lp
require_cmd sudo

INIT="$(detect_init)"
info "Detected init system: $INIT"

ensure_service_running cupsd "CUPS"
if command -v avahi-daemon &>/dev/null || [[ "$INIT" != unknown ]]; then
    ensure_service_running avahi-daemon "Avahi (network printer discovery)" || true
fi

ADD_ANOTHER=y
while [[ "$ADD_ANOTHER" =~ ^[Yy] ]]; do
    echo
    info "Scanning for printers..."
    discover_printers

    if (( ${#DISPLAY_NAMES[@]} == 0 )); then
        warn "No printers auto-discovered."
    else
        echo
        printf '  %2s  %-40s %s\n' "#" "NAME" "TYPE"
        for i in "${!DISPLAY_NAMES[@]}"; do
            printf '  %2d  %-40s %s\n' "$((i+1))" "${DISPLAY_NAMES[$i]}" "$(kind_label "${DISPLAY_KINDS[$i]}")"
        done
    fi
    echo "   m  Enter a printer address manually"
    echo "   r  Rescan"
    echo "   q  Quit"
    echo

    choice="$(ask "Pick a printer" "")"

    case "$choice" in
        q|Q) break ;;
        r|R) continue ;;
        m|M)
            manual_host="$(ask "Printer hostname or IP" "")"
            [[ -n "$manual_host" ]] || { warn "No address given."; continue; }
            if confirm "Does this printer support driverless/AirPrint printing (IPP Everywhere)?" y; then
                SELECTED_URI="ipp://${manual_host}/ipp/print"
                SELECTED_KIND="driverless"
            else
                SELECTED_URI="socket://${manual_host}"
                SELECTED_KIND="raw"
            fi
            SELECTED_NAME="$manual_host"
            ;;
        ''|*[!0-9]*)
            warn "Not a valid choice."
            continue
            ;;
        *)
            idx=$((choice-1))
            if (( idx < 0 || idx >= ${#DISPLAY_NAMES[@]} )); then
                warn "No such printer number."
                continue
            fi
            SELECTED_NAME="${DISPLAY_NAMES[$idx]}"
            SELECTED_URI="${DISPLAY_URIS[$idx]}"
            SELECTED_KIND="${DISPLAY_KINDS[$idx]}"
            ;;
    esac

    echo
    info "Selected: $SELECTED_NAME"
    info "Device URI: $SELECTED_URI"

    default_queue="$(sanitize_name "$SELECTED_NAME")"
    queue_name="$(ask "Name for this print queue" "$default_queue")"
    queue_name="$(sanitize_name "$queue_name")"

    driver_arg=(-m everywhere)
    if [[ "$SELECTED_KIND" == "raw" ]]; then
        warn "This device wasn't advertised as driverless-capable."
        if confirm "Try driverless setup anyway (-m everywhere)?" y; then
            driver_arg=(-m everywhere)
        else
            search="$(ask "Search installed drivers for (e.g. manufacturer/model)" "")"
            if [[ -n "$search" ]]; then
                info "Matching drivers:"
                lpinfo -m 2>/dev/null | grep -i -- "$search" | nl -ba || true
            fi
            driver_id="$(ask "Enter the exact driver id to use (blank = generic raw queue)" "")"
            if [[ -n "$driver_id" ]]; then
                driver_arg=(-m "$driver_id")
            else
                driver_arg=(-o raw)
            fi
        fi
    fi

    echo
    info "About to run:"
    echo "    sudo lpadmin -p $queue_name -E -v $SELECTED_URI ${driver_arg[*]}"
    if ! confirm "Proceed?" y; then
        warn "Skipped."
    else
        if sudo lpadmin -p "$queue_name" -E -v "$SELECTED_URI" "${driver_arg[@]}"; then
            info "Queue '$queue_name' created."

            if confirm "Set '$queue_name' as your default printer?" n; then
                lpoptions -d "$queue_name"
            fi

            lpstat -p "$queue_name" 2>/dev/null

            if confirm "Send a test page to '$queue_name' now?" y; then
                testfile="/usr/share/cups/data/testprint"
                if [[ ! -r "$testfile" ]]; then
                    testfile="$(mktemp)"
                    printf 'CUPS test page\nPrinter: %s\n' "$queue_name" > "$testfile"
                    cleanup_test=1
                fi
                if lp -d "$queue_name" "$testfile"; then
                    info "Test page sent. Check the printer output tray."
                else
                    err "Failed to send test page. Check: lpstat -p $queue_name ; tail /var/log/cups/error_log"
                fi
                [[ "${cleanup_test:-0}" == 1 ]] && rm -f "$testfile"
            fi
        else
            err "lpadmin failed. Common causes: wrong URI, printer offline, or it doesn't actually support -m everywhere."
            err "You can retry with a manual driver search (choose 'm' and answer 'no' to driverless)."
        fi
    fi

    echo
    if confirm "Set up another printer?" n; then
        ADD_ANOTHER=y
    else
        ADD_ANOTHER=n
    fi
done

info "Done. Current printers:"
lpstat -p 2>/dev/null || true
