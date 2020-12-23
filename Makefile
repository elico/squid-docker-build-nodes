
all: touch-all-build-flags build


install-fedora-deps:
	cat fedora-build-deps |head -2 |xargs -l2 dnf install -y

build-centos: clean-build-flags touch-centos-flags build 

build-centos-7: clean-build-flags touch-centos-7-flags build 

build-centos-8: clean-build-flags touch-centos-8-flags build 

build-fedora-33: clean-build-flags touch-fedora-33-flags build 


centos-7: build-centos-7

centos-8: build-centos-8

fedora-33: build-fedora-33



build-oracle: clean-build-flags touch-oracle-flags build 

build-oracle-7: clean-build-flags touch-oracle-7-flags build 

build-oracle-8: clean-build-flags touch-oracle-8-flags build 

oracle-7: build-oracle-7

oracle-8: build-oracle-8


build-ubuntu: clean-build-flags touch-ubuntu-flags build 

build-ubuntu-16.04: clean-build-flags touch-ubuntu-16.04-flags build 

build-ubuntu-18.04: clean-build-flags touch-ubuntu-18.04-flags build 

build-ubuntu-20.04: clean-build-flags touch-ubuntu-20.04-flags build 


build-debian: clean-build-flags touch-debian-flags build 

build-debian-9: clean-build-flags touch-debian-9-flags build 

build-debian-10: clean-build-flags touch-debian-10-flags build 

debian-9: build-debian-9

debian-10: build-debian-10


build-amzn: clean-build-flags touch-amzn-flags build 

build-amzn-1: clean-build-flags touch-amzn-1-flags build 

build-amzn-2: clean-build-flags touch-amzn-2-flags build 

amzn-1: build-amzn-1

amzn-2: build-amzn-2


touch-centos-flags: touch-centos-7-flags touch-centos-8-flags

touch-centos-7-flags:
	touch ./squid-centos-7/build

touch-centos-8-flags:
	touch ./squid-centos-8/build

touch-fedora-33-flags:
	touch ./squid-fedora-33/build


touch-amzn-flags: touch-amzn-1-flags touch-amzn-2-flags

touch-amzn-1-flags:
	touch ./squid-amzn-1/build

touch-amzn-2-flags:
	touch ./squid-amzn-2/build


touch-oracle-flags: touch-oracle-7 touch-oracle-8

touch-oracle-7-flags:
	touch ./squid-oracle-7/build

touch-oracle-8-flags:
	touch ./squid-oracle-8/build


touch-debian-flags: touch-debian-9-flags touch-debian-10-flags

touch-debian-9-flags:
	touch ./squid-debian9/build

touch-debian-10-flags:
	touch ./squid-debian10/build


touch-ubuntu-flags: touch-ubuntu-16.04-flags touch-ubuntu-18.04-flags touch-ubuntu-20.04-flags

touch-ubuntu-16.04-flags:
	touch ./squid-ubuntu1604/build

touch-ubuntu-18.04-flags:
	touch ./squid-ubuntu1804/build

touch-ubuntu-20.04-flags:
	touch ./squid-ubuntu2004/build


touch-all-build-flags:
	touch ./squid-*/build

build:
	bash build-all.sh

clean:	clean-ccache clean-packages

clean-ccache:
	yes| bash clean-packages.sh ccache

clean-packages:
	yes| bash clean-packages.sh packages

clean-build-flags:
	bash clean-packages.sh build

clean-centos-containers: clean-centos-7-container clean-centos-8-container

clean-centos-7-container:
	podman rmi squidbuild:centos7 -f

clean-centos-8-container:
	podman rmi squidbuild:centos8 -f

clean-fedora-containers: clean-fedora-33-container 

clean-fedora-33-container:
	podman rmi squidbuild:fedora33 -f


clean-ubuntu-containers: clean-ubuntu-16.04-container clean-ubuntu-18.04-container clean-ubuntu-20.04-container

clean-ubuntu-16.04-container:
	podman rmi squidbuild:centos1604 -f

clean-ubuntu-18.04-container:
	podman rmi squidbuild:centos1804 -f

clean-ubuntu-20.04-container:
	podman rmi squidbuild:centos2004 -f


clean-amzn-containers: clean-amzn-1-container clean-amzn-2-container

clean-amzn-1-container:
	podman rmi squidbuild:amzn1 -f

clean-amzn-2-container:
	podman rmi squidbuild:amzn2 -f


clean-oracle-containers: clean-oracle-7-container clean-oracle-8-container

clean-oracle-7-container:
	podman rmi squidbuild:ol7 -f

clean-oracle-8-container:
	podman rmi squidbuild:ol8 -f


clean-debian-container: clean-debian-9-container clean-debian-10-container

clean-debian-10-container:
	podman rmi squidbuild:debian10 -f

clean-debian-9-container:
	podman rmi squidbuild:debian9 -f

fetch-podman-images: fetch-oracle-images fetch-centos-images fetch-amzn-images fetch-debian-images fetch-ubuntu-images


fetch-oracle-images: fetch-oracle-7-image fetch-oracle-8-image

fetch-oracle-7-image:
	podman pull oraclelinux:7
fetch-oracle-8-image:
	podman pull oraclelinux:8


fetch-centos-images:  fetch-centos-7-image fetch-centos-8-image

fetch-centos-7-image:
	podman pull centos:7
fetch-centos-8-image:
	podman pull centos:8

fetch-debian-images: fetch-debian-9-image fetch-debian-10-image

fetch-debian-9-image:
	podman pull debian:stretch

fetch-debian-10-image:
	podman pull debian:buster


fetch-ubuntu-images: fetch-ubuntu-16.04-image fetch-ubuntu-18.04-image fetch-ubuntu-20.04-image

fetch-ubuntu-20.04-image:
	podman pull ubuntu:20.04

fetch-ubuntu-18.04-image:
	podman pull ubuntu:18.04

fetch-ubuntu-16.04-image:
	podman pull ubuntu:16.04

fetch-amzn-images: fetch-amzn-1-image fetch-amzn-2-image

fetch-amzn-1-image:
	podman pull amazonlinux:1

fetch-amzn-2-image:
	podman pull amazonlinux:2



