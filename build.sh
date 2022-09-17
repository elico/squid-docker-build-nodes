#!/usr/bin/env bash 

set -xe

BUILD="$1"

SOURCES_URL="$( cat latest-squid-url.txt )"

if [[ -z "${CUSTOM_SOURCES_URL}" ]];then
        echo ""
else
# Validate that the url exists?
# curl -I "${CUSTOM_SOURCES_URL}"|grep "200 OK"
        export SOURCES_URL="${CUSTOM_SOURCES_URL}"
fi

COMPRESSION="store"
DEBUG_MODE="1"
USE_CCACHE="1"
CCACHE_DIR="/srv/ccache"
RELEASE_NUMBER=$(head -1 release)

BUILD_ARRAY=`ls -d squid*/`

if [[ ! -z "${BUILD_ONLY}" ]];then
	BUILD_ARRAY=`ls -d */|egrep "${BUILD_ONLY}"`
fi

cd "${BUILD}"
DOCKER_IMAGE=`cat podmanimage`
echo "${DOCKER_IMAGE}"
stat podmanimage && \
	( podman image inspect  "${DOCKER_IMAGE}" || buildah bud -t "${DOCKER_IMAGE}" . )
podman run -it \
        -e COMPRESSION="${COMPRESSION}" \
        -e DEBUG_MODE="${DEBUG_MODE}" \
        -e USE_CCACHE="${USE_CCACHE}" \
        -e CCACHE_DIR="${CCACHE_DIR}" \
        -e RELEASE_NUMBER="${RELEASE_NUMBER}" \
        -e SOURCES_URL="${SOURCES_URL}" \
        -v `pwd`/srv:/srv \
                "${DOCKER_IMAGE}"
cd -

set +xe
