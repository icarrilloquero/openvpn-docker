#!/bin/bash
IMAGE="icarrilloquero/rpi-openvpn"
OVPN_DATA="ovpn-data"

BUFFER_CLIENT=393216

if [ "$PROTOCOL" = "tcp" ]; then
	BUFFER_SERVER=0
else
	BUFFER_SERVER=$BUFFER_CLIENT
fi

if [ "$(docker volume ls -q -f name=$OVPN_DATA)" = "$OVPN_DATA" ]; then
	echo "Volume '$OVPN_DATA' already exists. Please run 'docker volume rm $OVPN_DATA' to remove it and try again"
	exit 1
fi

docker volume create --name $OVPN_DATA

if [ $FORCE_DNS -eq 1 ]; then
	docker run --rm -v $OVPN_DATA:/etc/openvpn $IMAGE \
		ovpn_genconfig \
			-u $OVPN_URI \
	                -n "$DNS" \
			-e "sndbuf $BUFFER_SERVER" \
			-e "rcvbuf $BUFFER_SERVER" \
			-p "sndbuf $BUFFER_CLIENT" \
			-p "rcvbuf $BUFFER_CLIENT" \
	                -p "script-security 2" \ &&
	docker run --rm -v $OVPN_DATA:/etc/openvpn -it $IMAGE ovpn_initpki
else
	docker run --rm -v $OVPN_DATA:/etc/openvpn $IMAGE \
	        ovpn_genconfig $OPTS \
        	        -u $OVPN_URI \
	                -e "sndbuf $BUFFER_SERVER" \
	                -e "rcvbuf $BUFFER_SERVER" \
	                -p "sndbuf $BUFFER_CLIENT" \
	                -p "rcvbuf $BUFFER_CLIENT" \ &&
        docker run --rm -v $OVPN_DATA:/etc/openvpn -it $IMAGE ovpn_initpki
fi

exit 0
