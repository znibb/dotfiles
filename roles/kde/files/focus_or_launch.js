// Multi-app focus-or-launch script with JSON config and window cycling

var CONFIG_FILE = "~/.config/kwin/focus_or_launch_apps.json";

// Helper to expand ~ in paths
function expandPath(path) {
    if (path.startsWith("~")) {
        return path.replace("~", callDBus("org.kde.klauncher5","/KLauncher","org.kde.KLauncher","expandPath", [path]));
    }
    return path;
}

// Read JSON config
var apps = [];

try {
    var f = new QFile(expandPath(CONFIG_FILE));
    if (f.open(QIODevice.ReadOnly | QIODevice.Text)) {
        var data = f.readAll();
        apps = JSON.parse(data);
        f.close();
    } else {
        print("Failed to open config file: " + CONFIG_FILE);
    }
} catch (e) {
    print("Error reading JSON: " + e);
}

// Track last-focused window per app
var lastFocusedIndex = {};

apps.forEach(function(app) {
    var APP_CLASS = app.class;
    var APP_CMD   = app.command;
    var SHORTCUT  = app.shortcut;

    function focusOrLaunchCycle() {
        var clients = workspace.clientList().filter(function(c) {
            return c.resourceClass.toLowerCase() === APP_CLASS.toLowerCase();
        });

        if (clients.length === 0) {
            // No window found → launch program
            callDBus(
                "org.kde.klauncher5",
                "/KLauncher",
                "org.kde.KLauncher",
                "exec_blind",
                [APP_CMD, [], ""]
            );
            return;
        }

        // Cycle through windows
        var index = lastFocusedIndex[APP_CLASS] || 0;
        workspace.activeClient = clients[index];
        lastFocusedIndex[APP_CLASS] = (index + 1) % clients.length;
    }

    registerShortcut(
        "FocusOrLaunchConfig_" + APP_CLASS,
        "Focus or Launch (Cycle) " + APP_CLASS,
        SHORTCUT,
        focusOrLaunchCycle
    );
});
