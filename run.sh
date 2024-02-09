#!/usr/bin/env bash

make build-centos-8 build-oracle-8 build-rockylinux-8 build-almalinux-8 build-amzn-2 build-debian-10 build-debian-11  build-ubuntu-22.04 build-ubuntu-20.04 build-ubuntu-23.04

make deploy-centos-8-packages deploy-oracle-8-packages deploy-rocky-8-packages deploy-almalinux-8-packages deploy-amzn-2-packages deploy-ubuntu-packages deploy-debian-packages

make deploy-centos-packages deploy-oracle-packages deploy-amzn-packages create-repo-centos create-repo-oracle create-repo-amzn
