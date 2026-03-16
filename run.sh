#!/usr/bin/env bash

set -e

make get-latest-url-from-github

make build-oracle-9 \
	build-rockylinux-9 build-rockylinux-10 \
	build-almalinux-9 build-almalinux-10 \
	build-debian-12 \
	build-ubuntu-22.04 build-ubuntu-20.04 build-ubuntu-24.04 build-openeuler-2403

make deploy-oracle-9-packages \
	deploy-rocky-9-packages deploy-rocky-10-packages \
	deploy-almalinux-9-packages deploy-almalinux-10-packages \
	deploy-ubuntu-packages \
	deploy-debian-packages \
	deploy-openeuler

make create-repo-oracle create-repo-rocky create-repo-alma create-repo-openeuler 

set +e
