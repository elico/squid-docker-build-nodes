#!/usr/bin/env bash

IMAGE_NAME="$(head -1 podmanimage)"
docker image inspect ${IMAGE_NAME} || docker build -t ${IMAGE_NAME} .

SOURCES_URL="http://www.squid-cache.org/Versions/v4/squid-4.12.tar.xz"

if [[ -z "${CUSTOM_SOURCES_URL}" ]];then
        echo ""
else
# Validate that the url exists?
# curl -I "${CUSTOM_SOURCES_URL}"|grep "200 OK"
        export SOURCES_URL=${CUSTOM_SOURCES_URL}
fi


docker run -it \
	-e COMPRESSION="store" \
	-e DEBUG_MODE="1" \
	-e USE_CCACHE="1" \
	-e CCACHE_DIR="/srv/ccache" \
	-e RELEASE_NUMBER="1" \
	-e SOURCES_URL="${SOURCES_URL}" \
	-v `pwd`/srv:/srv \
		${IMAGE_NAME}
