#!/bin/bash
set -e

docker run -d --name mynfs --privileged monstar/nfs-server $@

# Source the script to populate MYNFSIP env var
export MYNFSIP=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' mynfs)

echo "Nfs Server IP: "$MYNFSIP
