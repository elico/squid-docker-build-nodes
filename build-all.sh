#!/usr/bin/env bash 

set -xe

# Use specified squid version
if [[ ! -z "${SQUID_VERSION}" ]]; then
	BASE_VERSION=`echo "${SQUID_VERSION}" | cut -f 1 -d .`
	export SOURCES_URL="http://www.squid-cache.org/Versions/v${BASE_VERSION}/squid-${SQUID_VERSION}.tar.xz"
else
# Find and use latest stable availble version. There has to be a better way..???
	SQUID_LATEST=`curl -sS http://www.squid-cache.org/Versions/ |sed -n '/>Stable Versions<\/a>:<\/h3>/,/<\/a><\/td><td>/p'| grep -oh -E '>[0-9].[0-9][0-9]?' |head -1 |sed 's/>//g'`
	BASE_VERSION=`echo "${SQUID_LATEST}" | grep -oE '^\s*[0-9]+'`
	export SOURCES_URL="http://www.squid-cache.org/Versions/v${BASE_VERSION}/squid-${SQUID_LATEST}.tar.xz"
fi

# Use custom url
if [[ ! -z "${CUSTOM_SOURCES_URL}" ]];then
       	export SOURCES_URL=${CUSTOM_SOURCES_URL}
fi

COMPRESSION="store"
DEBUG_MODE="1"
USE_CCACHE="1"
CCACHE_DIR="/srv/ccache"
RELEASE_NUMBER="1"

BUILD_ARRAY=`ls -d squid*/`

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
