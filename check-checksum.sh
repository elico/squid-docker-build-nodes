#!/usr/bin/env bash

if [[ ! -z "${DEBUG}" ]]; then
	set -x
fi

FILENAME="$1"
stat ${FILENAME}.asc >/dev/null && stat ${FILENAME} >/dev/null

CHECKSUM=$( echo $2 | tr '[:upper:]' '[:lower:]')


function verify() {
	FILENAME="$1"
	CHECKSUM="$2"

	STORED_CHECKSUM=$(egrep -i "^${CHECKSUM}\: " "${FILENAME}.asc" | awk '{ print $2 }')

	echo ${STORED_CHECKSUM} |egrep '^([0-9a-f]{32}|[0-9a-f]{40})|[0-9a-f]{64}|[0-9a-f]{96}|[0-9a-f]{128}$' >/dev/null
	RES=$?

	if [[ "${RES}" -eq "0" ]];then
		FILE_CHECKSUM=$(${CHECKSUM}sum ${FILENAME} |awk '{ print $1 }')
		if [[ "${FILE_CHECKSUM}" == "${STORED_CHECKSUM}" ]];then
			echo "Checksums MATCH" >&2
			exit 0
		else
			echo "ERROR checksums Do not match" >&2
			exit 1
		fi
	else
		echo "ERROR Missing checksum" >&2
		exit 2
	fi

}

case $CHECKSUM in 
	md5)
		verify ${FILENAME} md5

	;;
	sha1)
		verify ${FILENAME} sha1
	;;
	sha256)
		verify ${FILENAME} sha256
	;;
	sha384)
		verify ${FILENAME} sha384
	;;
	sha512)
		verify ${FILENAME} sha512
	;;
	*)
		echo "STDERR: Defaults to SHA1" >&2
		verify ${FILENAME} sha1
	;;
esac

set +x
