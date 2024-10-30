#!/usr/bin/env bash

set -e

make build-centos-9 build-oracle-8 build-oracle-9 build-rockylinux-8 build-rockylinux-9 build-almalinux-8 build-almalinux-9 build-debian-10 build-debian-11  build-debian-12 build-ubuntu-22.04 build-ubuntu-20.04 build-ubuntu-24.04

make deploy-oracle-8-packages deploy-rocky-8-packages deploy-almalinux-8-packages deploy-amzn-2-packages deploy-ubuntu-packages deploy-debian-packages deploy-centos-9-packages deploy-oracle-9-packages deploy-rocky-9-packages deploy-almalinux-9-packages

make deploy-centos-packages deploy-oracle-packages deploy-amzn-packages create-repo-centos create-repo-oracle create-repo-amzn

set +e
