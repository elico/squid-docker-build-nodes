#!/usr/bin/env bash

FILENAME="$1"

SOURCES_FILENAME="${FILENAME}"
export SOURCES_VERSION=$(echo ${SOURCES_FILENAME} |sed -e 's@\.tar\.bz2$@@g'  |sed -e 's@\.tar\.gz$@@g'|sed -e 's@\.tar\.xz$@@g'|sed -e 's@\.tar$@@g')
CUSTOM_VERSION="$2"

TMP="/tmp"

tar xf "${FILENAME}" -C "${TMP}/"

stat "${TMP}" && \
	mv "${TMP}/${SOURCES_VERSION}" "${TMP}/${CUSTOM_VERSION}" && \
	tar cvf "${CUSTOM_VERSION}.tar" -C "${TMP}/" "./${CUSTOM_VERSION}" && \
	stat "${CUSTOM_VERSION}.tar"
