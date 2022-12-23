#!/bin/bash

cd /etc/openvpn/easy-rsa
#mkdir backup
yes|cp /etc/openvpn/easy-rsa/pki/private/server_* /etc/openvpn/easy-rsa/backup
yes|cp /etc/openvpn/easy-rsa/pki/reqs/server* /etc/openvpn/easy-rsa/backup
yes|cp /etc/openvpn/easy-rsa/pki/issued/server* /etc/openvpn/easy-rsa/backup


rm /etc/openvpn/easy-rsa/pki/private/server_*
rm /etc/openvpn/easy-rsa/pki/reqs/server_*
rm /etc/openvpn/easy-rsa/pki/issued/server_*

s=$(basename /etc/openvpn/server_*.crt .crt)

./easyrsa build-server-full "$s" nopass

cd /etc/openvpn/easy-rsa/pki/issued
yes|cp server_* ../../../

cd /etc/openvpn/easy-rsa/pki/private
yes|cp server_* ../../../
