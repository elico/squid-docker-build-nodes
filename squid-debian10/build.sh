#!/usr/bin/env bash

docker image inspect squidbuild:debian10 || docker build -t squidbuild:debian10 .

SOURCES_URL="https://www.squid-cache.org/Versions/v4/squid-4.8.tar.xz"
SOURCES_URL="http://ngtech.co.il/squid/src/squid-4.8.tar.xz"

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
		squidbuild:debian10
