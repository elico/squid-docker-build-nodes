
REPO_ROOT_FILE=repo_root.txt
REPO_ROOT=`head -1 $(REPO_ROOT_FILE)`

ifeq ($(REPO_ROOT),)
REPO_ROOT := "/mnt/staging_repo"
endif

all: 
	echo OK

build-all: build-oracle build-centos build-amzn build-alma build-rocky build-debian build-ubuntu

install-fedora-deps:
	cat fedora-build-deps |head -2 |xargs -l2 dnf install -y

get-latest-url-from-gogs:
	curl -s http://gogs.ngtech.home/NgTech-Home/squid-latest/raw/main/latest.json |jq -r .url > latest-squid-url.txt

get-latest-url-from-github:
	curl -s https://raw.githubusercontent.com/elico/squid-latest/main/latest.json |jq -r .url > latest-squid-url.txt

build-rpms: build-oracle build-centos build-amzn build-alma build-rocky

centos: build-centos

build-centos: build-centos-7 build-centos-8 build-centos-9

build-centos-7: 
	bash build.sh squid-centos-7

build-centos-8: 
	bash build.sh squid-centos-8

build-centos-9: 
	bash build.sh squid-centos-9

centos-7: build-centos-7

centos-8: build-centos-8

centos-9: build-centos-9

centos7: build-centos-7

centos8: build-centos-8

centos9: build-centos-9


build-almalinux: build-almalinux-8 build-almalinux-9

almalinux8: build-almalinux-8

almalinux9: build-almalinux-9

build-almalinux-8:
	bash build.sh squid-almalinux-8

build-almalinux-9:
	bash build.sh squid-almalinux-9

build-alma-8: build-almalinux-8

build-alma-9: build-almalinux-9

build-alma: build-almalinux

build-rockylinux: build-rockylinux-8 build-rockylinux-9

build-rockylinux-8:
	bash build.sh squid-rockylinux-8

build-rockylinux-9:
	bash build.sh squid-rockylinux-9

build-rocky: build-rockylinux

build-rocky-8: build-rockylinux-8

build-rocky-9: build-rockylinux-9

build-fedora: build-fedora-33 build-fedora-35 build-fedora-36 build-fedora-40

build-fedora-33:
	bash build.sh squid-fedora-33

build-fedora-35:
	bash build.sh squid-fedora-35

build-fedora-36:
	bash build.sh squid-fedora-36

build-fedora-38:
	bash build.sh squid-fedora-38

build-fedora-40:
	bash build.sh squid-fedora-40


fedora: build-fedora

fedora-33: build-fedora-33

fedora-35: build-fedora-35

fedora-36: build-fedora-36

fedora-38: build-fedora-38

fedora-40: build-fedora-40



build-oracle: build-oracle-7 build-oracle-8 

build-oracle-7: 
	bash build.sh squid-oracle-7

build-oracle-8:
	bash build.sh squid-oracle-8

build-oracle-9:
	bash build.sh squid-oracle-9

oracle-7: build-oracle-7

oracle-8: build-oracle-8

oracle-9: build-oracle-9

oracle7: build-oracle-7

oracle8: build-oracle-8

oracle9: build-oracle-9

ubuntu: build-ubuntu
 
build-ubuntu: build-ubuntu-16.04 build-ubuntu-18.04 build-ubuntu-20.04 build-ubuntu-22.04

build-ubuntu-16.04:
	bash build.sh squid-ubuntu1604 

build-ubuntu-18.04: 
	bash build.sh squid-ubuntu1804 

build-ubuntu-20.04: 
	bash build.sh squid-ubuntu2004 

build-ubuntu-22.04:
	bash build.sh squid-ubuntu2204 

build-ubuntu-23.04:
	bash build.sh squid-ubuntu2304 

build-ubuntu-24.04:
	bash build.sh squid-ubuntu2404 


debian: build-debian

build-debian: build-debian-9 build-debian-10 build-debian-11 build-debian-12

build-debian-9: 
	bash build.sh squid-debian9

build-debian-10: 
	bash build.sh squid-debian10

build-debian-11:
	bash build.sh squid-debian11

build-debian-12:
	bash build.sh squid-debian12


debian-9: build-debian-9

debian-10: build-debian-10

debian-11: build-debian-11

debian-12: build-debian-12




build-amzn: build-amzn-1 build-amzn-2

build-amzn-1: 
	bash build.sh squid-amzn-1

build-amzn-2:
	bash build.sh squid-amzn-2

amzn-1: build-amzn-1

amzn-2: build-amzn-2


clean:	clean-ccache clean-packages

clean-ccache:
	yes| bash clean-packages.sh ccache

clean-packages:
	yes| bash clean-packages.sh packages

clean-build-flags:
	bash clean-packages.sh build

clean-all-containers: clean-debian-container clean-oracle-containers clean-amzn-containers clean-ubuntu-containers clean-fedora-containers clean-centos-containers

clean-alma-containers: clean-alma-8-container clean-alma-9-container

clean-alma-8-container:
	podman rmi $$(head -1 squid-almalinux-8/podmanimage ) -f;true

clean-alma-9-container:
	podman rmi $$(head -1 squid-almalinux-9/podmanimage ) -f;true

clean-centos-containers: clean-centos-7-container clean-centos-8-container clean-centos-9-container

clean-centos-7-container:
	podman rmi squidbuild:centos7 -f;true

clean-centos-8-container:
	podman rmi squidbuild:centos8 -f;true

clean-centos-9-container:
	podman rmi squidbuild:centos9 -f;true

clean-fedora-containers: clean-fedora-33-container clean-fedora-35-container clean-fedora-36-container clean-fedora-38-container clean-fedora-40-container

clean-fedora-33-container:
	podman rmi squidbuild:fedora33 -f;true

clean-fedora-35-container:
	podman rmi squidbuild:fedora35 -f;true

clean-fedora-36-container:
	podman rmi squidbuild:fedora36 -f;true

clean-fedora-38-container:
	podman rmi squidbuild:fedora38 -f;true

clean-fedora-40-container:
	podman rmi squidbuild:fedora40 -f;true

clean-ubuntu-containers: clean-ubuntu-16.04-container clean-ubuntu-18.04-container clean-ubuntu-20.04-container  clean-ubuntu-22.04-container clean-ubuntu-23.04-container

clean-ubuntu-16.04-container:
	podman rmi squidbuild:ubuntu1604 -f;true

clean-ubuntu-18.04-container:
	podman rmi squidbuild:ubuntu1804 -f;true

clean-ubuntu-20.04-container:
	podman rmi squidbuild:ubuntu2004 -f;true

clean-ubuntu-22.04-container:
	podman rmi squidbuild:ubuntu2204 -f;true

clean-ubuntu-23.04-container:
	podman rmi squidbuild:ubuntu2304 -f;true

clean-ubuntu-24.04-container:
	podman rmi squidbuild:ubuntu2404 -f;true



clean-amzn-containers: clean-amzn-1-container clean-amzn-2-container

clean-amzn-1-container:
	podman rmi squidbuild:amzn1 -f;true

clean-amzn-2-container:
	podman rmi squidbuild:amzn2 -f;true


clean-oracle-containers: clean-oracle-7-container clean-oracle-8-container clean-oracle-9-container

clean-oracle-7-container:
	podman rmi squidbuild:ol7 -f;true

clean-oracle-8-container:
	podman rmi squidbuild:ol8 -f;true

clean-oracle-9-container:
	podman rmi squidbuild:ol9 -f;true


clean-debian-container: clean-debian-9-container clean-debian-10-container clean-debian-11-container clean-debian-12-container

clean-debian-12-container:
	podman rmi squidbuild:debian12 -f;true

clean-debian-11-container:
	podman rmi squidbuild:debian11 -f;true

clean-debian-10-container:
	podman rmi squidbuild:debian10 -f;true

clean-debian-9-container:
	podman rmi squidbuild:debian9 -f;true


fetch-podman-images: fetch-oracle-images fetch-centos-images fetch-amzn-images fetch-debian-images fetch-ubuntu-images


fetch-oracle-images: fetch-oracle-7-image fetch-oracle-8-image fetch-oracle-9-image

fetch-oracle-7-image:
	podman pull oraclelinux:7

fetch-oracle-8-image:
	podman pull oraclelinux:8

fetch-oracle-9-image:
	podman pull oraclelinux:9


fetch-centos-images:  fetch-centos-7-image fetch-centos-8-image fetch-centos-9-image

fetch-centos-7-image:
	podman pull centos:7

fetch-centos-8-image:
	podman pull centos:stream8

fetch-centos-9-image:
	podman pull centos:stream9


fetch-debian-images: fetch-debian-9-image fetch-debian-10-image fetch-debian-11-image fetch-debian-12-image

fetch-debian-9-image:
	podman pull debian:stretch

fetch-debian-10-image:
	podman pull debian:buster

fetch-debian-11-image:
	podman pull debian:bullseye

fetch-debian-12-image:
	podman pull debian:bookworm


fetch-ubuntu-images: fetch-ubuntu-16.04-image fetch-ubuntu-18.04-image fetch-ubuntu-20.04-image fetch-ubuntu-22.04-image fetch-ubuntu-23.04-image

fetch-ubuntu-20.04-image:
	podman pull ubuntu:20.04

fetch-ubuntu-22.04-image:
	podman pull ubuntu:22.04

fetch-ubuntu-23.04-image:
	podman pull ubuntu:23.04


fetch-ubuntu-18.04-image:
	podman pull ubuntu:18.04

fetch-ubuntu-16.04-image:
	podman pull ubuntu:16.04

fetch-amzn-images: fetch-amzn-1-image fetch-amzn-2-image

fetch-amzn-1-image:
	podman pull amazonlinux:1

fetch-amzn-2-image:
	podman pull amazonlinux:2


deploy-packages:

deploy-rpms: deploy-centos-packages deploy-oracle-packages deploy-amzn-2-packages deploy-almalinux-packages deploy-rockylinux-packages


deploy-centos-packages: deploy-centos-7-packages  deploy-centos-8-packages deploy-centos-9-packages

deploy-centos-7-packages:
	mkdir -p $(REPO_ROOT)/centos/7/x86_64
	mkdir -p $(REPO_ROOT)/centos/7/SRPMS
	cp -v squid-centos-7/srv/packages/*.x86_64.rpm $(REPO_ROOT)/centos/7/x86_64/;true
	cp -v squid-centos-7/srv/packages/*.src.rpm $(REPO_ROOT)/centos/7/SRPMS/;true

deploy-centos-8-packages:
	mkdir -p $(REPO_ROOT)/centos/8/x86_64
	mkdir -p $(REPO_ROOT)/centos/8/SRPMS
	cp -v squid-centos-8/srv/packages/*.x86_64.rpm $(REPO_ROOT)/centos/8/x86_64/;true
	cp -v squid-centos-8/srv/packages/*.src.rpm $(REPO_ROOT)/centos/8/SRPMS/

deploy-centos-9-packages:
	mkdir -p $(REPO_ROOT)/centos/9/x86_64
	mkdir -p $(REPO_ROOT)/centos/9/SRPMS
	cp -v squid-centos-9/srv/packages/*.x86_64.rpm $(REPO_ROOT)/centos/9/x86_64/;true
	cp -v squid-centos-9/srv/packages/*.src.rpm $(REPO_ROOT)/centos/9/SRPMS/;true

deploy-oracle-packages: deploy-oracle-7-packages deploy-oracle-8-packages deploy-oracle-9-packages

deploy-oracle-7-packages:
	mkdir -p $(REPO_ROOT)/oracle/7/x86_64
	mkdir -p $(REPO_ROOT)/oracle/7/SRPMS
	cp -v squid-oracle-7/srv/packages/*.x86_64.rpm $(REPO_ROOT)/oracle/7/x86_64/;true
	cp -v squid-oracle-7/srv/packages/*.src.rpm $(REPO_ROOT)/oracle/7/SRPMS/;true

deploy-oracle-8-packages:
	mkdir -p $(REPO_ROOT)/oracle/8/x86_64
	mkdir -p $(REPO_ROOT)/oracle/8/SRPMS
	cp -v squid-oracle-8/srv/packages/*.x86_64.rpm $(REPO_ROOT)/oracle/8/x86_64/;true
	cp -v squid-oracle-8/srv/packages/*.src.rpm $(REPO_ROOT)/oracle/8/SRPMS/;true

deploy-oracle-9-packages:
	mkdir -p $(REPO_ROOT)/oracle/9/x86_64
	mkdir -p $(REPO_ROOT)/oracle/9/SRPMS
	cp -v squid-oracle-9/srv/packages/*.x86_64.rpm $(REPO_ROOT)/oracle/9/x86_64/;true
	cp -v squid-oracle-9/srv/packages/*.src.rpm $(REPO_ROOT)/oracle/9/SRPMS/;true


deploy-oracle-8-beta-packages:
	mkdir -p $(REPO_ROOT)/oracle/8/beta/x86_64
	mkdir -p $(REPO_ROOT)/oracle/8/beta/SRPMS
	cp -v squid-oracle-8/srv/packages/*.x86_64.rpm $(REPO_ROOT)/oracle/8/beta/x86_64/;true
	cp -v squid-oracle-8/srv/packages/*.src.rpm $(REPO_ROOT)/oracle/8/beta/SRPMS/;true


deploy-rocky-packages: deploy-rocky-8-packages deploy-rocky-9-packages

deploy-rocky-8-packages:
	mkdir -p $(REPO_ROOT)/rocky/8/x86_64
	mkdir -p $(REPO_ROOT)/rocky/8/SRPMS
	cp -v squid-rockylinux-8/srv/packages/*.x86_64.rpm $(REPO_ROOT)/rocky/8/x86_64/;true
	cp -v squid-rockylinux-8/srv/packages/*.src.rpm $(REPO_ROOT)/rocky/8/SRPMS/;true

deploy-rocky-9-packages:
	mkdir -p $(REPO_ROOT)/rocky/9/x86_64
	mkdir -p $(REPO_ROOT)/rocky/9/SRPMS
	cp -v squid-rockylinux-9/srv/packages/*.x96_64.rpm $(REPO_ROOT)/rocky/9/x96_64/;true
	cp -v squid-rockylinux-9/srv/packages/*.src.rpm $(REPO_ROOT)/rocky/9/SRPMS/;true

deploy-rocky-8-beta-packages:
	mkdir -p $(REPO_ROOT)/rocky/8/beta/x86_64
	mkdir -p $(REPO_ROOT)/rocky/8/beta/SRPMS
	cp -v squid-rockylinux-8/srv/packages/*.x86_64.rpm $(REPO_ROOT)/rocky/8/beta/x86_64/;true
	cp -v squid-rockylinux-8/srv/packages/*.src.rpm $(REPO_ROOT)/rocky/8/beta/SRPMS/;true

deploy-amzn-packages: deploy-amzn-1-packages deploy-amzn-2-packages

deploy-amzn-1-packages:
	mkdir -p $(REPO_ROOT)/amzn/1/x86_64
	mkdir -p $(REPO_ROOT)/amzn/1/SRPMS
	cp -v squid-amzn-1/srv/packages/*.x86_64.rpm $(REPO_ROOT)/amzn/1/x86_64/;true
	cp -v squid-amzn-1/srv/packages/*.src.rpm $(REPO_ROOT)/amzn/1/SRPMS/;true

deploy-amzn-2-packages:
	mkdir -p $(REPO_ROOT)/amzn/2/x86_64
	mkdir -p $(REPO_ROOT)/amzn/2/SRPMS
	cp -v squid-amzn-2/srv/packages/*.x86_64.rpm $(REPO_ROOT)/amzn/2/x86_64/;true
	cp -v squid-amzn-2/srv/packages/*.src.rpm $(REPO_ROOT)/amzn/2/SRPMS/;true


deploy-centos-beta-packages: deploy-centos-7-beta-packages  deploy-centos-8-beta-packages deploy-centos-9-beta-packages

deploy-centos-7-beta-packages:
	mkdir -p $(REPO_ROOT)/centos/7/beta/x86_64

deploy-centos-8-beta-packages:
	mkdir -p $(REPO_ROOT)/centos/8/beta/x86_64
	mkdir -p $(REPO_ROOT)/centos/8/beta/SRPMS
	cp -v squid-centos-8/srv/packages/*.x86_64.rpm $(REPO_ROOT)/centos/8/beta/x86_64/;true
	cp -v squid-centos-8/srv/packages/*.src.rpm $(REPO_ROOT)/centos/8/beta/SRPMS/

deploy-fedora-packages: deploy-fedora-33-packages deploy-fedora-35-packages deploy-fedora-36-packages deploy-fedora-38-packages deploy-fedora-40-packages

deploy-fedora-33-packages:
	mkdir -p $(REPO_ROOT)/fedora/33/x86_64
	mkdir -p $(REPO_ROOT)/fedora/33/SRPMS
	cp -v squid-fedora-33/srv/packages/*.x86_64.rpm $(REPO_ROOT)/fedora/33/x86_64/;true
	cp -v squid-fedora-33/srv/packages/*.src.rpm $(REPO_ROOT)/fedora/33/SRPMS/;true

deploy-fedora-35-packages:
	mkdir -p $(REPO_ROOT)/fedora/35/x86_64
	mkdir -p $(REPO_ROOT)/fedora/35/SRPMS
	cp -v squid-fedora-35/srv/packages/*.x86_64.rpm $(REPO_ROOT)/fedora/35/x86_64/;true
	cp -v squid-fedora-35/srv/packages/*.src.rpm $(REPO_ROOT)/fedora/35/SRPMS/;true

deploy-fedora-36-packages:
	mkdir -p $(REPO_ROOT)/fedora/36/x86_64
	mkdir -p $(REPO_ROOT)/fedora/36/SRPMS
	cp -v squid-fedora-36/srv/packages/*.x86_64.rpm $(REPO_ROOT)/fedora/36/x86_64/;true
	cp -v squid-fedora-36/srv/packages/*.src.rpm $(REPO_ROOT)/fedora/36/SRPMS/;true

deploy-fedora-38-packages:
	mkdir -p $(REPO_ROOT)/fedora/38/x86_64
	mkdir -p $(REPO_ROOT)/fedora/38/SRPMS
	cp -v squid-fedora-38/srv/packages/*.x86_64.rpm $(REPO_ROOT)/fedora/38/x86_64/;true
	cp -v squid-fedora-38/srv/packages/*.src.rpm $(REPO_ROOT)/fedora/38/SRPMS/;true

deploy-fedora-40-packages:
	mkdir -p $(REPO_ROOT)/fedora/40/x86_64
	mkdir -p $(REPO_ROOT)/fedora/40/SRPMS
	cp -v squid-fedora-40/srv/packages/*.x86_64.rpm $(REPO_ROOT)/fedora/40/x86_64/;true
	cp -v squid-fedora-40/srv/packages/*.src.rpm $(REPO_ROOT)/fedora/40/SRPMS/;true


deploy-almalinux-packages: deploy-alma-8-packages deploy-alma-9-packages

deploy-alma-8-packages:
	mkdir -p $(REPO_ROOT)/alma/8/x86_64
	mkdir -p $(REPO_ROOT)/alma/8/SRPMS
	cp -v squid-almalinux-8/srv/packages/*.x86_64.rpm $(REPO_ROOT)/alma/8/x86_64/;true
	cp -v squid-almalinux-8/srv/packages/*.src.rpm $(REPO_ROOT)/alma/8/SRPMS/;true

deploy-alma-9-packages:
	mkdir -p $(REPO_ROOT)/alma/9/x86_64
	mkdir -p $(REPO_ROOT)/alma/9/SRPMS
	cp -v squid-almalinux-9/srv/packages/*.x86_64.rpm $(REPO_ROOT)/alma/9/x86_64/;true
	cp -v squid-almalinux-9/srv/packages/*.src.rpm $(REPO_ROOT)/alma/9/SRPMS/;true

deploy-alma-8-beta-packages:
	mkdir -p $(REPO_ROOT)/alma/8/beta/x86_64
	mkdir -p $(REPO_ROOT)/alma/8/beta/SRPMS
	cp -v squid-almalinux-8/srv/packages/*.x86_64.rpm $(REPO_ROOT)/alma/8/beta/x86_64/;true
	cp -v squid-almalinux-8/srv/packages/*.src.rpm $(REPO_ROOT)/alma/8/beta/SRPMS/;true


deploy-almalinux-8-packages: deploy-alma-8-packages

deploy-almalinux-9-packages: deploy-alma-9-packages

create-repo-rpms: create-repo-alma create-repo-rocky create-repo-oracle create-repo-fedora create-repo-amzn

create-repo-centos: create-repo-centos7 create-repo-centos8

create-repo-centos7:
	mkdir -p $(REPO_ROOT)/centos/7/x86_64
	mkdir -p $(REPO_ROOT)/centos/7/SRPMS
	cd $(REPO_ROOT)/centos/7/SRPMS && createrepo ./
	cd $(REPO_ROOT)/centos/7/x86_64 && createrepo ./
	touch $(REPO_ROOT)/centos/7

create-repo-centos8:
	mkdir -p $(REPO_ROOT)/centos/8/x86_64
	mkdir -p $(REPO_ROOT)/centos/8/SRPMS
	cd $(REPO_ROOT)/centos/8/SRPMS && createrepo ./
	cd $(REPO_ROOT)/centos/8/x86_64 && createrepo ./
	touch $(REPO_ROOT)/centos/8

create-repo-centos9:
	mkdir -p $(REPO_ROOT)/centos/9/x86_64
	mkdir -p $(REPO_ROOT)/centos/9/SRPMS
	cd $(REPO_ROOT)/centos/9/SRPMS && createrepo ./
	cd $(REPO_ROOT)/centos/9/x86_64 && createrepo ./
	touch $(REPO_ROOT)/centos/9

create-repo-fedora: create-repo-fedora33 create-repo-fedora34 create-repo-fedora36 create-repo-fedora38 create-repo-fedora40

create-repo-fedora33:
	mkdir -p $(REPO_ROOT)/fedora/33/x86_64
	mkdir -p $(REPO_ROOT)/fedora/33/SRPMS
	cd $(REPO_ROOT)/fedora/33/SRPMS && createrepo ./
	cd $(REPO_ROOT)/fedora/33/x86_64 && createrepo ./
	touch $(REPO_ROOT)/fedora/33

create-repo-fedora35:
	mkdir -p $(REPO_ROOT)/fedora/35/x86_64
	mkdir -p $(REPO_ROOT)/fedora/35/SRPMS
	cd $(REPO_ROOT)/fedora/35/SRPMS && createrepo ./
	cd $(REPO_ROOT)/fedora/35/x86_64 && createrepo ./
	touch $(REPO_ROOT)/fedora/35

create-repo-fedora36:
	mkdir -p $(REPO_ROOT)/fedora/36/x86_64
	mkdir -p $(REPO_ROOT)/fedora/36/SRPMS
	cd $(REPO_ROOT)/fedora/36/SRPMS && createrepo ./
	cd $(REPO_ROOT)/fedora/36/x86_64 && createrepo ./
	touch $(REPO_ROOT)/fedora/36

create-repo-fedora38:
	mkdir -p $(REPO_ROOT)/fedora/38/x86_64
	mkdir -p $(REPO_ROOT)/fedora/38/SRPMS
	cd $(REPO_ROOT)/fedora/38/SRPMS && createrepo ./
	cd $(REPO_ROOT)/fedora/38/x86_64 && createrepo ./
	touch $(REPO_ROOT)/fedora/38

create-repo-fedora40:
	mkdir -p $(REPO_ROOT)/fedora/40/x86_64
	mkdir -p $(REPO_ROOT)/fedora/40/SRPMS
	cd $(REPO_ROOT)/fedora/40/SRPMS && createrepo ./
	cd $(REPO_ROOT)/fedora/40/x86_64 && createrepo ./
	touch $(REPO_ROOT)/fedora/40


create-repo-almalinux: create-repo-alma

create-repo-alma: create-repo-alma8 create-repo-alma9

create-repo-alma8:
	mkdir -p $(REPO_ROOT)/alma/8/x86_64
	mkdir -p $(REPO_ROOT)/alma/8/SRPMS
	cd $(REPO_ROOT)/alma/8/SRPMS && createrepo ./
	cd $(REPO_ROOT)/alma/8/x86_64 && createrepo ./
	touch $(REPO_ROOT)/alma/8

create-repo-alma9:
	mkdir -p $(REPO_ROOT)/alma/9/x86_64
	mkdir -p $(REPO_ROOT)/alma/9/SRPMS
	cd $(REPO_ROOT)/alma/9/SRPMS && createrepo ./
	cd $(REPO_ROOT)/alma/9/x86_64 && createrepo ./
	touch $(REPO_ROOT)/alma/9


create-beta-repo-alma8:
	cd $(REPO_ROOT)/alma/8/beta/SRPMS && createrepo ./
	cd $(REPO_ROOT)/alma/8/beta/x86_64 && createrepo ./
	touch $(REPO_ROOT)/alma/8/beta

create-repo-rockylinux: create-repo-rocky

create-repo-rocky: create-repo-rocky8 create-repo-rocky9

create-repo-rocky8:
	cd $(REPO_ROOT)/rocky/8/SRPMS && createrepo ./
	cd $(REPO_ROOT)/rocky/8/x86_64 && createrepo ./
	touch $(REPO_ROOT)/rocky/8

create-repo-rocky9:
	cd $(REPO_ROOT)/rocky/9/SRPMS && createrepo ./
	cd $(REPO_ROOT)/rocky/9/x96_64 && createrepo ./
	touch $(REPO_ROOT)/rocky/9

create-repo-rocky-8: create-repo-rocky8

create-repo-rocky-9: create-repo-rocky9


create-beta-repo-rocky8:
	cd $(REPO_ROOT)/rocky/8/beta/SRPMS && createrepo ./
	cd $(REPO_ROOT)/rocky/8/beta/x86_64 && createrepo ./
	touch $(REPO_ROOT)/rocky/8/beta

create-beta-repos: create-beta-repo-centos create-beta-repo-oracle create-beta-repo-fedora create-beta-repo-amzn

create-beta-repo-centos: create-beta-repo-centos7 create-beta-repo-centos8 

create-beta-repo-centos7:
	cd $(REPO_ROOT)/centos/7/beta/SRPMS && createrepo ./
	cd $(REPO_ROOT)/centos/7/beta/x86_64 && createrepo ./
	touch $(REPO_ROOT)/centos/7/beta

create-beta-repo-centos8:
	cd $(REPO_ROOT)/centos/8/beta/SRPMS && createrepo ./
	cd $(REPO_ROOT)/centos/8/beta/x86_64 && createrepo ./
	touch $(REPO_ROOT)/centos/8/beta

create-repo-oracle: create-repo-oracle7 create-repo-oracle8 create-repo-oracle9

create-repo-oracle7:
	cd $(REPO_ROOT)/oracle/7/SRPMS && createrepo ./
	cd $(REPO_ROOT)/oracle/7/x86_64 && createrepo ./
	touch $(REPO_ROOT)/oracle/7

create-repo-oracle8:
	cd $(REPO_ROOT)/oracle/8/SRPMS && createrepo ./
	cd $(REPO_ROOT)/oracle/8/x86_64 && createrepo ./
	touch $(REPO_ROOT)/oracle/8

create-repo-oracle9:
	cd $(REPO_ROOT)/oracle/9/SRPMS && createrepo ./
	cd $(REPO_ROOT)/oracle/9/x86_64 && createrepo ./
	touch $(REPO_ROOT)/oracle/9

create-beta-repo-oracle: create-beta-repo-oracle7 create-beta-repo-oracle8 create-beta-repo-oracle9

create-beta-repo-oracle7:
	cd $(REPO_ROOT)/oracle/7/beta/SRPMS && createrepo ./
	cd $(REPO_ROOT)/oracle/7/beta/x86_64 && createrepo ./
	touch $(REPO_ROOT)/oracle/7/beta

create-beta-repo-oracle8:
	cd $(REPO_ROOT)/oracle/8/beta/SRPMS && createrepo ./
	cd $(REPO_ROOT)/oracle/8/beta/x86_64 && createrepo ./
	touch $(REPO_ROOT)/oracle/8/beta

create-beta-repo-oracle9:
	cd $(REPO_ROOT)/oracle/9/beta/SRPMS && createrepo ./
	cd $(REPO_ROOT)/oracle/9/beta/x86_64 && createrepo ./
	touch $(REPO_ROOT)/oracle/9/beta

create-repo-amzn: create-repo-amzn2

create-repo-amzn1:
	cd $(REPO_ROOT)/amzn/1/SRPMS && createrepo ./
	cd $(REPO_ROOT)/amzn/1/x86_64 && createrepo ./
	touch $(REPO_ROOT)/amzn/1

create-repo-amzn2:
	cd $(REPO_ROOT)/amzn/2/SRPMS && createrepo ./
	cd $(REPO_ROOT)/amzn/2/x86_64 && createrepo ./
	touch $(REPO_ROOT)/amzn/2

create-beta-repo-amzn: create-beta-repo-amzn2

create-beta-repo-amzn1:
	cd $(REPO_ROOT)/amzn/1/beta/SRPMS && createrepo ./
	cd $(REPO_ROOT)/amzn/1/beta/x86_64 && createrepo ./
	touch $(REPO_ROOT)/amzn/1/beta

create-beta-repo-amzn2:
	cd $(REPO_ROOT)/amzn/2/beta/SRPMS && createrepo ./
	cd $(REPO_ROOT)/amzn/2/beta/x86_64 && createrepo ./
	touch $(REPO_ROOT)/amzn/2/beta

create-beta-repo-fedora: create-beta-repo-fedora-33 create-beta-repo-fedora-35 create-beta-repo-fedora-36 create-beta-repo-fedora-38

create-beta-repo-fedora-33:
	mkdir -p $(REPO_ROOT)/fedora/33/x86_64
	mkdir -p $(REPO_ROOT)/fedora/33/SRPMS
	cd $(REPO_ROOT)/fedora/33/beta/x86_64 && createrepo ./
	cd $(REPO_ROOT)/fedora/33/beta/SRPMS && createrepo ./
	touch $(REPO_ROOT)/fedora/33/beta

create-beta-repo-fedora-35:
	mkdir -p $(REPO_ROOT)/fedora/35/x86_64
	mkdir -p $(REPO_ROOT)/fedora/35/SRPMS
	cd $(REPO_ROOT)/fedora/35/beta/x86_64 && createrepo ./
	cd $(REPO_ROOT)/fedora/35/beta/SRPMS && createrepo ./
	touch $(REPO_ROOT)/fedora/35/beta

create-beta-repo-fedora-36:
	mkdir -p $(REPO_ROOT)/fedora/36/x86_64
	mkdir -p $(REPO_ROOT)/fedora/36/SRPMS
	cd $(REPO_ROOT)/fedora/36/beta/x86_64 && createrepo ./
	cd $(REPO_ROOT)/fedora/36/beta/SRPMS && createrepo ./
	touch $(REPO_ROOT)/fedora/36/beta

create-beta-repo-fedora-38:
	mkdir -p $(REPO_ROOT)/fedora/38/x86_64
	mkdir -p $(REPO_ROOT)/fedora/38/SRPMS
	cd $(REPO_ROOT)/fedora/38/beta/x86_64 && createrepo ./
	cd $(REPO_ROOT)/fedora/38/beta/SRPMS && createrepo ./
	touch $(REPO_ROOT)/fedora/38/beta

deploy-debian-packages: deploy-debian-10-packages deploy-debian-9-packages deploy-debian-12-packages deploy-debian-11-packages


deploy-debian-buster-packages: deploy-debian-10-packages

deploy-buster-packages: deploy-debian-10-packages

deploy-debian-10-packages:
	mkdir -p $(REPO_ROOT)/debian/10/x86_64
	cp -v squid-debian10/srv/packages/*.tar $(REPO_ROOT)/debian/10/x86_64/;true


deploy-debian-bullseye-packages: deploy-debian-11-packages

deploy-bullseye-packages: deploy-debian-11-packages

deploy-debian-11-packages:
	mkdir -p $(REPO_ROOT)/debian/11/x86_64
	cp -v squid-debian11/srv/packages/*.tar $(REPO_ROOT)/debian/11/x86_64/;true


deploy-debian-bookworm-packages: deploy-debian-12-packages

deploy-bookworm-packages: deploy-debian-12-packages

deploy-debian-12-packages:
	mkdir -p $(REPO_ROOT)/debian/12/x86_64
	cp -v squid-debian12/srv/packages/*.tar $(REPO_ROOT)/debian/12/x86_64/;true



deploy-debian-jessie-packages: deploy-debian-9-packages

deploy-jessie-packages: deploy-debian-9-packages

deploy-debian-9-packages:
	mkdir -p $(REPO_ROOT)/debian/9/x86_64
	cp -v squid-debian9/srv/packages/*.tar $(REPO_ROOT)/debian/9/x86_64/;true



deploy-ubuntu-packages: deploy-ubuntu-1604-packages deploy-ubuntu-1804-packages deploy-ubuntu-2004-packages deploy-ubuntu-2204-packages deploy-ubuntu-2304-packages

deploy-1604-packages: deploy-ubuntu-1604-packages

deploy-ubuntu-1604-packages:
	mkdir -p $(REPO_ROOT)/ubuntu/16.04/x86_64
	cp -v squid-ubuntu1604/srv/packages/*.tar $(REPO_ROOT)/ubuntu/16.04/x86_64/;true

deploy-1804-packages: deploy-ubuntu-1804-packages

deploy-ubuntu-1804-packages:
	mkdir -p $(REPO_ROOT)/ubuntu/18.04/x86_64
	cp -v squid-ubuntu1804/srv/packages/*.tar $(REPO_ROOT)/ubuntu/18.04/x86_64/;true


deploy-2004-packages: deploy-ubuntu-2004-packages

deploy-ubuntu-2004-packages:
	mkdir -p $(REPO_ROOT)/ubuntu/20.04/x86_64
	cp -v squid-ubuntu2004/srv/packages/*.tar $(REPO_ROOT)/ubuntu/20.04/x86_64/;true

deploy-2204-packages: deploy-ubuntu-2204-packages

deploy-ubuntu-2204-packages:
	mkdir -p $(REPO_ROOT)/ubuntu/22.04/x86_64
	cp -v squid-ubuntu2204/srv/packages/*.tar $(REPO_ROOT)/ubuntu/22.04/x86_64/;true

deploy-2304-packages: deploy-ubuntu-2304-packages

deploy-ubuntu-2304-packages:
	mkdir -p $(REPO_ROOT)/ubuntu/23.04/x86_64
	cp -v squid-ubuntu2304/srv/packages/*.tar $(REPO_ROOT)/ubuntu/23.04/x86_64/;true

deploy-ubuntu-2404-packages:
	mkdir -p $(REPO_ROOT)/ubuntu/24.04/x86_64
	cp -v squid-ubuntu2404/srv/packages/*.tar $(REPO_ROOT)/ubuntu/24.04/x86_64/;true


clean-rpms-packages:
	rm -vf squid-centos-7/srv/packages/*.rpm 
	rm -vf squid-centos-8/srv/packages/*.rpm 
	rm -vf squid-centos-9/srv/packages/*.rpm 
	rm -vf squid-oracle-7/srv/packages/*.rpm 
	rm -vf squid-oracle-8/srv/packages/*.rpm 
	rm -vf squid-oracle-9/srv/packages/*.rpm 
	rm -vf squid-amzn-1/srv/packages/*.rpm
	rm -vf squid-amzn-2/srv/packages/*.rpm
	rm -vf squid-fedora-33/srv/packages/*.rpm
	rm -vf squid-fedora-35/srv/packages/*.rpm
	rm -vf squid-fedora-36/srv/packages/*.rpm
	rm -vf squid-fedora-38/srv/packages/*.rpm
	rm -vf squid-fedora-40/srv/packages/*.rpm
