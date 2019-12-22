#!/usr/bin/env bash 

set -xe

SOURCES_URL="https://www.squid-cache.org/Versions/v4/squid-4.9.tar.xz"
SOURCES_URL="http://ngtech.co.il/squid/src/squid-4.9.tar.xz"

if [[ -z "${CUSTOM_SOURCES_URL}" ]];then
        echo ""
else
# Validate that the url exists?
# curl -I "${CUSTOM_SOURCES_URL}"|grep "200 OK"
        export SOURCES_URL=${CUSTOM_SOURCES_URL}
fi

COMPRESSION="store"
DEBUG_MODE="1"
USE_CCACHE="1"
CCACHE_DIR="/srv/ccache"
RELEASE_NUMBER="1"

BUILD_ARRAY=`ls -d */`

if [[ ! -z "${BUILD_ONLY}" ]];then
	BUILD_ARRAY=`ls -d */|egrep "${BUILD_ONLY}"`
fi

#for Build in `find ./ -type d -maxdepth 1`
for Build in ${BUILD_ARRAY}
do
	echo $Build
	cd "$Build"
	DOCKER_IMAGE=`cat dockerimage`
	echo "${DOCKER_IMAGE}"
	stat dockerimage && \
		( docker image inspect  "${DOCKER_IMAGE}" || docker build . -t "${DOCKER_IMAGE}" )
	stat build && docker run -it \
	        -e COMPRESSION="${COMPRESSION}" \
	        -e DEBUG_MODE="${DEBUG_MODE}" \
	        -e USE_CCACHE="${USE_CCACHE}" \
	        -e CCACHE_DIR="${CCACHE_DIR}" \
	        -e RELEASE_NUMBER="${RELEASE_NUMBER}" \
	        -e SOURCES_URL="${SOURCES_URL}" \
	        -v `pwd`/srv:/srv \
	                "${DOCKER_IMAGE}"
	cd -
done

set +xe
