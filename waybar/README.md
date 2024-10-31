## Waybar Wireguard panel
1. Install Wireguard: `sudo apt install wireguard`
2. Enable passwordless usage of `wg` and `wg-quick` by adding a Wireguard entry under `/etc/sudoers.d/`:
```
echo "$USER ALL=NOPASSWD: /usr/bin/wg
$USER ALL=NOPASSWD: /usr/bin/wg-quick" | sudo tee /etc/sudoers.d/wireguard
```
3. Download your Wireguard config file and place it in `/etc/wireguard`
4. Give your config file a suitable name, the filename will control what the interface is named in your PC, here we'll call it `vpn-home.conf`
5. Make sure your config file is owned by root and can only be read by root:
- `sudo chown root:root /etc/wireguard/vpn-home.conf`
- `sudo chmod 600 /etc/wireguard/vpn-home.conf`
6. Double check that the `INTERFACE_NAME` variable is set to the same name as your .conf file, in this example `vpn-home`