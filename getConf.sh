#!/bin/bash
. .env

IMAGE="icarrilloquero/rpi-openvpn"
OVPN_DATA="ovpn-data-2fa"

CLIENT_NAME="client"
CONTAINER=ovpn2fa_vpn_1

docker exec $CONTAINER rm /etc/openvpn/pki/reqs/$CLIENT_NAME.req
docker exec $CONTAINER rm /etc/openvpn/pki/private/$CLIENT_NAME.key
docker run -v $OVPN_DATA:/etc/openvpn --rm -it $IMAGE easyrsa build-client-full $CLIENT_NAME nopass && \
docker run -v $OVPN_DATA:/etc/openvpn --rm -t $IMAGE ovpn_otp_user $CLIENT_NAME && \
docker run -v $OVPN_DATA:/etc/openvpn --rm $IMAGE ovpn_getclient $CLIENT_NAME > $CLIENT_NAME.ovpn && \
sed --expression="s/1194 $PROTOCOL/$VPN_PORT $PROTOCOL/g" -i $CLIENT_NAME.ovpn
