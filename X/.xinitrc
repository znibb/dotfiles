# Load X-related parameters
xrdb -merge ~/.Xresources

# Font related settings
xset -fp ~/.fonts
xset fp rehash

# Start i3 with debug enabled
#exec i3 --shmlog-size=26214400

# Start i3 without debug enabled
exec i3
