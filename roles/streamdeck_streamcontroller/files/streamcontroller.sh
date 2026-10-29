#!/bin/bash

# Wrapper for launching StreamController with the KDE session environment.
# Without these variables, programs started from StreamController buttons
# (e.g. dolphin, xdg-open) fall back to the wrong default apps and Qt theme.

export XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP:-KDE}"
export KDE_SESSION_VERSION="${KDE_SESSION_VERSION:-6}"
export QT_QPA_PLATFORMTHEME="${QT_QPA_PLATFORMTHEME:-kde}"

exec streamcontroller "$@"
