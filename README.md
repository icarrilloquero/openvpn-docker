# Docker VPN

Helpful scripts to easily set up an OpenVPN with docker.

# Getting Started

### Prerequisites

You will need docker and docker-compose configured in your system.
The docker image referenced here is meant for ARM. If you plan to deploy this in an x86 architecture, just make sure to replace the image [icarrilloquero/rpi-openvpn](https://hub.docker.com/r/icarrilloquero/rpi-openvpn) for [kylemanna/openvpn](https://hub.docker.com/r/kylemanna/openvpn/).

### Installing

Clone the repo and add a custom .env file as follows:

```
PROTOCOL=<tcp or udp>
OVPN_URI="$PROTOCOL://<YOUR_HOST>"
FORCE_DNS=<Set to 1 if you want to specify a custom DNS server, 0 otherwise>
DNS=<YOUR_DNS_SERVER_IP>
VPN_PORT=<YOUR_VPN_PORT>
```

Then just run initVPN.sh and follow the steps to initialize the configuration and server certificates. When done, run the OpenVPN container:

```
docker-compose up -d
```

### Generate client configuration file

Just edit the getConf.sh script with the desired client name and the client configuration file (.ovpn) will be generated in the working directory.

## Acknowledgments

[kylemanna](https://github.com/kylemanna/docker-openvpn) for their great OpenVPN docker image.
