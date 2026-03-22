## Alpine
If you run `sudo apk update` and the output contains warnings about stale repos or if your ansible-playbook runs fails with something like `fatal: [localhost]: FAILED! => {"changed": false, "msg": "could not update package db"` one solution is to run `sudo setupapkrepos -cf` to scan for available/suitable repo mirrors to use

You might need to run `sudo apk update`, check which mirrors it's complaining about and manually remove them from `/etc/apk/repositories`