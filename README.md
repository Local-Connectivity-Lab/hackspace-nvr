# Config
Frigate configuration files.

# Media
Recordings saved by Frigate

# Passwords
Encrypted in the Frigate database, saved on VaultWarden in the hackspace-camera folder.

# Camera IP Addresses
Cameras are assigned a static IP starting with 10.9.3.100. 

# Frigate Host Network
The Frigate host needs to be on the same subnet to discover the cameras.

For the hackspace-nvr laptop, the camera-net was configured with nmcli.
`nmcli con add con-name "camera-net" ifname enxa0cec8004537 type ethernet ip4 10.9.3.1/24 ipv4.method manual`
