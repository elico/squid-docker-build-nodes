
REPO_ROOT_FILE=repo_root.txt
REPO_ROOT=`head -1 $(REPO_ROOT_FILE)`

ifeq ($(REPO_ROOT),)
REPO_ROOT := "/mnt/staging_repo"
endif

all: touch-all-build-flags build

install-fedora-deps:
	cat fedora-build-deps |head -2 |xargs -l2 dnf install -y

build-rpms: clean-build-flags touch-centos-flags touch-oracle-flags touch-amzn-2-flags touch-fedora-flags touch-almalinux-flags touch-rockylinux-flags build

centos: build-centos

build-centos: clean-build-flags touch-centos-flags build 

build-centos-7: clean-build-flags touch-centos-7-flags build 

build-centos-8: clean-build-flags touch-centos-8-flags build 

build-centos-9: clean-build-flags touch-centos-9-flags build 

centos-7: build-centos-7

centos-8: build-centos-8

centos-9: build-centos-9

centos7: build-centos-7

centos8: build-centos-8

centos9: build-centos-9


build-almalinux: clean-build-flags touch-almalinux-8-flags touch-almalinux-9-flags build

almalinux8: build-almalinux-8

almalinux9: build-almalinux-9

build-almalinux-8: clean-build-flags touch-almalinux-8-flags build

build-almalinux-9: clean-build-flags touch-almalinux-9-flags build



build-rockylinux: clean-build-flags touch-rockylinux-8-flags build

build-rockylinux-8: clean-build-flags touch-rockylinux-8-flags build



build-fedora-33: clean-build-flags touch-fedora-33-flags build 

build-fedora-35: clean-build-flags touch-fedora-35-flags build 

build-fedora: fedora


fedora: clean-build-flags touch-fedora-flags build

fedora-33: build-fedora-33

fedora-35: build-fedora-35




build-oracle: clean-build-flags touch-oracle-flags build 

build-oracle-7: clean-build-flags touch-oracle-7-flags build 

build-oracle-8: clean-build-flags touch-oracle-8-flags build 

oracle-7: build-oracle-7

oracle-8: build-oracle-8

oracle7: build-oracle-7

oracle8: build-oracle-8

ubuntu: build-ubuntu
 
build-ubuntu: clean-build-flags touch-ubuntu-flags build 

build-ubuntu-16.04: clean-build-flags touch-ubuntu-16.04-flags build 

build-ubuntu-18.04: clean-build-flags touch-ubuntu-18.04-flags build 

build-ubuntu-20.04: clean-build-flags touch-ubuntu-20.04-flags build 

build-ubuntu-22.04: clean-build-flags touch-ubuntu-22.04-flags build 


debian: build-debian

build-debian: clean-build-flags touch-debian-flags build 

build-debian-9: clean-build-flags touch-debian-9-flags build 

build-debian-10: clean-build-flags touch-debian-10-flags build 

build-debian-11: clean-build-flags touch-debian-11-flags build 

debian-9: build-debian-9

debian-10: build-debian-10

debian-11: build-debian-11



build-amzn: clean-build-flags touch-amzn-flags build 

build-amzn-1: clean-build-flags touch-amzn-1-flags build 

build-amzn-2: clean-build-flags touch-amzn-2-flags build 

amzn-1: build-amzn-1

amzn-2: build-amzn-2


touch-centos-flags: touch-centos-7-flags touch-centos-8-flags 
#touch-centos-9-flags

touch-centos-7-flags:
	touch ./squid-centos-7/build

touch-centos-8-flags:
	touch ./squid-centos-8/build

touch-centos-9-flags:
	touch ./squid-centos-9/build

touch-fedora-flags: touch-fedora-33-flags touch-fedora-35-flags

touch-fedora-33-flags:
	touch ./squid-fedora-33/build

touch-fedora-35-flags:
	touch ./squid-fedora-35/build



touch-almalinux-flags: touch-almalinux-8-flags #touch-almalinux-9-flags 

touch-almalinux-8-flags:
	touch ./squid-almalinux-8/build

touch-almalinux-9-flags:
	touch ./squid-almalinux-9/build


touch-rockylinux-flags: touch-rockylinux-8-flags

touch-rockylinux-8-flags:
	touch ./squid-rockylinux-8/build


touch-amzn-flags: touch-amzn-1-flags touch-amzn-2-flags

touch-amzn-1-flags:
	touch ./squid-amzn-1/build

touch-amzn-2-flags:
	touch ./squid-amzn-2/build


touch-oracle-flags: touch-oracle-7-flags touch-oracle-8-flags


touch-oracle-7-flags:
	touch ./squid-oracle-7/build

touch-oracle-8-flags:
	touch ./squid-oracle-8/build


touch-debian-flags: touch-debian-9-flags touch-debian-10-flags touch-debian-11-flags

touch-debian-9-flags:
	touch ./squid-debian9/build

touch-debian-10-flags:
	touch ./squid-debian10/build

touch-debian-11-flags:
	touch ./squid-debian11/build


touch-ubuntu-flags: touch-ubuntu-16.04-flags touch-ubuntu-18.04-flags touch-ubuntu-20.04-flags touch-ubuntu-22.04-flags

touch-ubuntu-16.04-flags:
	touch ./squid-ubuntu1604/build

touch-ubuntu-18.04-flags:
	touch ./squid-ubuntu1804/build

touch-ubuntu-20.04-flags:
	touch ./squid-ubuntu2004/build

touch-ubuntu-22.04-flags:
	touch ./squid-ubuntu2204/build

touch-all-build-flags: touch-fedora-flags touch-centos-flags touch-amzn-flags touch-oracle-flags touch-debian-flags touch-ubuntu-flags 
	echo 1

build:
	bash build-all.sh

clean:	clean-ccache clean-packages

clean-ccache:
	yes| bash clean-packages.sh ccache

clean-packages:
	yes| bash clean-packages.sh packages

clean-build-flags:
	bash clean-packages.sh build

clean-all-containers: clean-debian-container clean-oracle-containers clean-amzn-containers clean-ubuntu-containers clean-fedora-containers clean-centos-containers

clean-centos-containers: clean-centos-7-container clean-centos-8-container clean-centos-9-container

clean-centos-7-container:
	podman rmi squidbuild:centos7 -f;true

clean-centos-8-container:
	podman rmi squidbuild:centos8 -f;true

clean-centos-9-container:
	podman rmi squidbuild:centos9 -f;true

clean-fedora-containers: clean-fedora-33-container clean-fedora-35-container

clean-fedora-33-container:
	podman rmi squidbuild:fedora33 -f;true

clean-fedora-35-container:
	podman rmi squidbuild:fedora35 -f;true


clean-ubuntu-containers: clean-ubuntu-16.04-container clean-ubuntu-18.04-container clean-ubuntu-20.04-container  clean-ubuntu-22.04-container

clean-ubuntu-16.04-container:
	podman rmi squidbuild:ubuntu1604 -f;true

clean-ubuntu-18.04-container:
	podman rmi squidbuild:ubuntu1804 -f;true

clean-ubuntu-20.04-container:
	podman rmi squidbuild:ubuntu2004 -f;true

clean-ubuntu-22.04-container:
	podman rmi squidbuild:ubuntu2204 -f;true

clean-amzn-containers: clean-amzn-1-container clean-amzn-2-container

clean-amzn-1-container:
	podman rmi squidbuild:amzn1 -f;true

clean-amzn-2-container:
	podman rmi squidbuild:amzn2 -f;true


clean-oracle-containers: clean-oracle-7-container clean-oracle-8-container

clean-oracle-7-container:
	podman rmi squidbuild:ol7 -f;true

clean-oracle-8-container:
	podman rmi squidbuild:ol8 -f;true


clean-debian-container: clean-debian-9-container clean-debian-10-container clean-debian-11-container

clean-debian-11-container:
	podman rmi squidbuild:debian11 -f;true

clean-debian-10-container:
	podman rmi squidbuild:debian10 -f;true

clean-debian-9-container:
	podman rmi squidbuild:debian9 -f;true


fetch-podman-images: fetch-oracle-images fetch-centos-images fetch-amzn-images fetch-debian-images fetch-ubuntu-images


fetch-oracle-images: fetch-oracle-7-image fetch-oracle-8-image

fetch-oracle-7-image:
	podman pull oraclelinux:7
fetch-oracle-8-image:
	podman pull oraclelinux:8


fetch-centos-images:  fetch-centos-7-image fetch-centos-8-image fetch-centos-9-image

fetch-centos-7-image:
	podman pull centos:7

fetch-centos-8-image:
	podman pull centos:stream8

fetch-centos-9-image:
	podman pull centos:stream9


fetch-debian-images: fetch-debian-9-image fetch-debian-10-image fetch-debian-11-image

fetch-debian-9-image:
	podman pull debian:stretch

fetch-debian-10-image:
	podman pull debian:buster

fetch-debian-11-image:
	podman pull debian:bullseye


fetch-ubuntu-images: fetch-ubuntu-16.04-image fetch-ubuntu-18.04-image fetch-ubuntu-20.04-image fetch-ubuntu-22.04-image

fetch-ubuntu-20.04-image:
	podman pull ubuntu:20.04

fetch-ubuntu-22.04-image:
	podman pull ubuntu:22.04

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


deploy-centos-packages: deploy-centos-7-packages  deploy-centos-8-packages
# deploy-centos-9-packages

deploy-centos-7-packages:
	mkdir -p $(REPO_ROOT)/centos/7/x86_64
	mkdir -p $(REPO_ROOT)/centos/7/SRPMS
	cp -v squid-centos-7/srv/packages/*.x86_64.rpm $(REPO_ROOT)/centos/7/x86_64/
	cp -v squid-centos-7/srv/packages/*.src.rpm $(REPO_ROOT)/centos/7/SRPMS/

deploy-centos-8-packages:
	mkdir -p $(REPO_ROOT)/centos/8/x86_64
	mkdir -p $(REPO_ROOT)/centos/8/SRPMS
	cp -v squid-centos-8/srv/packages/*.x86_64.rpm $(REPO_ROOT)/centos/8/x86_64/
	cp -v squid-centos-8/srv/packages/*.src.rpm $(REPO_ROOT)/centos/8/SRPMS/

deploy-centos-9-packages:
	mkdir -p $(REPO_ROOT)/centos/9/x86_64
	mkdir -p $(REPO_ROOT)/centos/9/SRPMS
	cp -v squid-centos-9/srv/packages/*.x86_64.rpm $(REPO_ROOT)/centos/9/x86_64/
	cp -v squid-centos-9/srv/packages/*.src.rpm $(REPO_ROOT)/centos/9/SRPMS/


deploy-centos-beta-packages: deploy-centos-7-beta-packages  deploy-centos-8-beta-packages deploy-centos-9-beta-packages

deploy-centos-7-beta-packages:
	mkdir -p $(REPO_ROOT)/centos/7/beta/x86_64
	mkdir -p $(REPO_ROOT)/centos/7/beta/SRPMS
	cp -v squid-centos-7/srv/packages/*.x86_64.rpm $(REPO_ROOT)/centos/7/beta/x86_64/
	cp -v squid-centos-7/srv/packages/*.src.rpm $(REPO_ROOT)/centos/7/beta/SRPMS/

deploy-centos-8-beta-packages:
	mkdir -p $(REPO_ROOT)/centos/8/beta/x86_64
	mkdir -p $(REPO_ROOT)/centos/8/beta/SRPMS
	cp -v squid-centos-8/srv/packages/*.x86_64.rpm $(REPO_ROOT)/centos/8/beta/x86_64/
	cp -v squid-centos-8/srv/packages/*.src.rpm $(REPO_ROOT)/centos/8/beta/SRPMS/

deploy-centos-9-beta-packages:
	mkdir -p $(REPO_ROOT)/centos/9/beta/x86_64
	mkdir -p $(REPO_ROOT)/centos/9/beta/SRPMS
	cp -v squid-centos-9/srv/packages/*.x86_64.rpm $(REPO_ROOT)/centos/9/beta/x86_64/
	cp -v squid-centos-9/srv/packages/*.src.rpm $(REPO_ROOT)/centos/9/beta/SRPMS/

deploy-almalinux-packages: deploy-almalinux-8-packages #deploy-almalinux-9-packages

deploy-almalinux-8-packages:
	mkdir -p $(REPO_ROOT)/alma/8/x86_64
	mkdir -p $(REPO_ROOT)/alma/8/SRPMS
	cp -v squid-almalinux-8/srv/packages/*.x86_64.rpm $(REPO_ROOT)/alma/8/x86_64/
	cp -v squid-almalinux-8/srv/packages/*.src.rpm $(REPO_ROOT)/alma/8/SRPMS/

deploy-almalinux-9-packages:
	mkdir -p $(REPO_ROOT)/alma/9/x86_64
	mkdir -p $(REPO_ROOT)/alma/9/SRPMS
	cp -v squid-almalinux-9/srv/packages/*.x86_64.rpm $(REPO_ROOT)/alma/9/x86_64/
	cp -v squid-almalinux-9/srv/packages/*.src.rpm $(REPO_ROOT)/alma/9/SRPMS/


deploy-rocky-packages: deploy-rockylinux-8-packages

deploy-rockylinux-8-packages:
	mkdir -p $(REPO_ROOT)/rocky/8/x86_64
	mkdir -p $(REPO_ROOT)/rocky/8/SRPMS
	cp -v squid-rockylinux-8/srv/packages/*.x86_64.rpm $(REPO_ROOT)/rocky/8/x86_64/
	cp -v squid-rockylinux-8/srv/packages/*.src.rpm $(REPO_ROOT)/rocky/8/SRPMS/


deploy-oracle-packages: deploy-oracle-7-packages  deploy-oracle-8-packages

deploy-oracle-7-packages:
	mkdir -p $(REPO_ROOT)/oracle/7/x86_64
	mkdir -p $(REPO_ROOT)/oracle/7/SRPMS
	cp -v squid-oracle-7/srv/packages/*.x86_64.rpm $(REPO_ROOT)/oracle/7/x86_64/
	cp -v squid-oracle-7/srv/packages/*.src.rpm $(REPO_ROOT)/oracle/7/SRPMS/

deploy-oracle-8-packages:
	mkdir -p $(REPO_ROOT)/oracle/8/x86_64
	mkdir -p $(REPO_ROOT)/oracle/8/SRPMS
	cp -v squid-oracle-8/srv/packages/*.x86_64.rpm $(REPO_ROOT)/oracle/8/x86_64/
	cp -v squid-oracle-8/srv/packages/*.src.rpm $(REPO_ROOT)/oracle/8/SRPMS/

deploy-oracle-beta-packages: deploy-oracle-7-beta-packages  deploy-oracle-8-beta-packages

deploy-oracle-7-beta-packages:
	mkdir -p $(REPO_ROOT)/oracle/7/x86_64
	mkdir -p $(REPO_ROOT)/oracle/7/SRPMS
	cp -v squid-oracle-7/srv/packages/*.x86_64.rpm $(REPO_ROOT)/oracle/7/x86_64/
	cp -v squid-oracle-7/srv/packages/*.src.rpm $(REPO_ROOT)/oracle/7/SRPMS/

deploy-oracle-8-beta-packages:
	mkdir -p $(REPO_ROOT)/oracle/8/beta/x86_64
	mkdir -p $(REPO_ROOT)/oracle/8/beta/SRPMS
	cp -v squid-oracle-8/srv/packages/*.x86_64.rpm $(REPO_ROOT)/oracle/8/beta/x86_64/
	cp -v squid-oracle-8/srv/packages/*.src.rpm $(REPO_ROOT)/oracle/8/beta/SRPMS/


deploy-amzn-packages: deploy-amzn-1-packages  deploy-amzn-2-packages

deploy-amzn-1-packages:
	mkdir -p $(REPO_ROOT)/amzn/1/x86_64
	mkdir -p $(REPO_ROOT)/amzn/1/SRPMS
	cp -v squid-amzn-1/srv/packages/*.x86_64.rpm $(REPO_ROOT)/amzn/1/x86_64/
	cp -v squid-amzn-1/srv/packages/*.src.rpm $(REPO_ROOT)/amzn/1/SRPMS/

deploy-amzn-2-packages:
	mkdir -p $(REPO_ROOT)/amzn/2/x86_64
	mkdir -p $(REPO_ROOT)/amzn/2/SRPMS
	cp -v squid-amzn-2/srv/packages/*.x86_64.rpm $(REPO_ROOT)/amzn/2/x86_64/
	cp -v squid-amzn-2/srv/packages/*.src.rpm $(REPO_ROOT)/amzn/2/SRPMS/

deploy-beta-packages: deploy-centos-beta-packages deploy-oracle-beta-packages deploy-amzn-beta-packages  deploy-fedora-beta-packages


deploy-amzn-beta-packages: deploy-amzn-2-beta-packages

deploy-amzn-1-beta-packages:
	mkdir -p $(REPO_ROOT)/amzn/1/beta/x86_64
	mkdir -p $(REPO_ROOT)/amzn/1/beta/SRPMS
	cp -v squid-amzn-1/srv/packages/*.x86_64.rpm $(REPO_ROOT)/amzn/1/beta/x86_64/
	cp -v squid-amzn-1/srv/packages/*.src.rpm $(REPO_ROOT)/amzn/1/beta/SRPMS/

deploy-amzn-2-beta-packages:
	mkdir -p $(REPO_ROOT)/amzn/2/beta/x86_64
	mkdir -p $(REPO_ROOT)/amzn/2/beta/SRPMS
	cp -v squid-amzn-2/srv/packages/*.x86_64.rpm $(REPO_ROOT)/amzn/2/beta/x86_64/
	cp -v squid-amzn-2/srv/packages/*.src.rpm $(REPO_ROOT)/amzn/2/beta/SRPMS/

deploy-fedora-packages: deploy-fedora-33-packages deploy-fedora-35-packages

deploy-fedora-33-packages:
	mkdir -p $(REPO_ROOT)/fedora/33/x86_64
	mkdir -p $(REPO_ROOT)/fedora/33/SRPMS
	cp -v squid-fedora-33/srv/packages/*.x86_64.rpm $(REPO_ROOT)/fedora/33/x86_64/
	cp -v squid-fedora-33/srv/packages/*.src.rpm $(REPO_ROOT)/fedora/33/SRPMS/

deploy-fedora-35-packages:
	mkdir -p $(REPO_ROOT)/fedora/35/x86_64
	mkdir -p $(REPO_ROOT)/fedora/35/SRPMS
	cp -v squid-fedora-35/srv/packages/*.x86_64.rpm $(REPO_ROOT)/fedora/35/x86_64/
	cp -v squid-fedora-35/srv/packages/*.src.rpm $(REPO_ROOT)/fedora/35/SRPMS/

deploy-fedora-beta-packages: deploy-fedora-33-beta-packages deploy-fedora-35-beta-packages

deploy-fedora-33-beta-packages:
	mkdir -p $(REPO_ROOT)/fedora/33/beta/x86_64
	mkdir -p $(REPO_ROOT)/fedora/33/beta/SRPMS
	cp -v squid-fedora-33/srv/packages/*.x86_64.rpm $(REPO_ROOT)/fedora/33/beta/x86_64/
	cp -v squid-fedora-33/srv/packages/*.src.rpm $(REPO_ROOT)/fedora/33/beta/SRPMS/

deploy-fedora-35-beta-packages:
	mkdir -p $(REPO_ROOT)/fedora/35/beta/x86_64
	mkdir -p $(REPO_ROOT)/fedora/35/beta/SRPMS
	cp -v squid-fedora-35/srv/packages/*.x86_64.rpm $(REPO_ROOT)/fedora/35/beta/x86_64/
	cp -v squid-fedora-35/srv/packages/*.src.rpm $(REPO_ROOT)/fedora/35/beta/SRPMS/

create-repo-centos: create-repo-centos7 create-repo-centos8

create-repo-centos7:
	cd $(REPO_ROOT)/centos/7/SRPMS && createrepo ./
	cd $(REPO_ROOT)/centos/7/x86_64 && createrepo ./
	touch $(REPO_ROOT)/centos/7

create-repo-centos8:
	cd $(REPO_ROOT)/centos/8/SRPMS && createrepo ./
	cd $(REPO_ROOT)/centos/8/x86_64 && createrepo ./
	touch $(REPO_ROOT)/centos/8


create-repo-almalinux: create-repo-alma

create-repo-alma: create-repo-alma8 create-repo-alma9

create-repo-alma8:
	cd $(REPO_ROOT)/alma/8/SRPMS && createrepo ./
	cd $(REPO_ROOT)/alma/8/x86_64 && createrepo ./
	touch $(REPO_ROOT)/alma/8

create-repo-alma9:
	cd $(REPO_ROOT)/alma/9/SRPMS && createrepo ./
	cd $(REPO_ROOT)/alma/9/x86_64 && createrepo ./
	touch $(REPO_ROOT)/alma/9

create-repo-rockylinux: create-repo-rocky

create-repo-rocky: create-repo-rocky8

create-repo-rocky8:
	cd $(REPO_ROOT)/rocky/8/SRPMS && createrepo ./
	cd $(REPO_ROOT)/rocky/8/x86_64 && createrepo ./
	touch $(REPO_ROOT)/rocky/8


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

create-repo-oracle: create-repo-oracle7 create-repo-oracle8

create-repo-oracle7:
	cd $(REPO_ROOT)/oracle/7/SRPMS && createrepo ./
	cd $(REPO_ROOT)/oracle/7/x86_64 && createrepo ./
	touch $(REPO_ROOT)/oracle/7

create-repo-oracle8:
	cd $(REPO_ROOT)/oracle/8/SRPMS && createrepo ./
	cd $(REPO_ROOT)/oracle/8/x86_64 && createrepo ./
	touch $(REPO_ROOT)/oracle/8

create-beta-repo-oracle: create-beta-repo-oracle7 create-beta-repo-oracle8

create-beta-repo-oracle7:
	cd $(REPO_ROOT)/oracle/7/beta/SRPMS && createrepo ./
	cd $(REPO_ROOT)/oracle/7/beta/x86_64 && createrepo ./
	touch $(REPO_ROOT)/oracle/7/beta

create-beta-repo-oracle8:
	cd $(REPO_ROOT)/oracle/8/beta/SRPMS && createrepo ./
	cd $(REPO_ROOT)/oracle/8/beta/x86_64 && createrepo ./
	touch $(REPO_ROOT)/oracle/8/beta

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

create-repo-fedora: create-fedora-33-packages create-fedora-35-packages

create-fedora-33-packages:
	cd $(REPO_ROOT)/fedora/33/x86_64 && createrepo ./
	cd $(REPO_ROOT)/fedora/33/SRPMS && createrepo ./
	touch $(REPO_ROOT)/fedora/33

create-fedora-35-packages:
	cd $(REPO_ROOT)/fedora/35/x86_64 && createrepo ./
	cd $(REPO_ROOT)/fedora/35/SRPMS && createrepo ./
	touch $(REPO_ROOT)/fedora/35

create-beta-repo-fedora:create-fedora-33-beta-packages create-fedora-35-beta-packages

create-fedora-33-beta-packages:
	cd $(REPO_ROOT)/fedora/33/beta/x86_64 && createrepo ./
	cd $(REPO_ROOT)/fedora/33/beta/SRPMS && createrepo ./
	touch $(REPO_ROOT)/fedora/33/beta

create-fedora-35-beta-packages:
	cd $(REPO_ROOT)/fedora/35/beta/x86_64 && createrepo ./
	cd $(REPO_ROOT)/fedora/35/beta/SRPMS && createrepo ./
	touch $(REPO_ROOT)/fedora/35/beta

deploy-debian-packages: deploy-debian-10-packages deploy-debian-9-packages


deploy-debian-buster-packages: deploy-debian-10-packages

deploy-buster-packages: deploy-debian-10-packages

deploy-debian-10-packages:
	mkdir -p $(REPO_ROOT)/debian/10/x86_64
	cp -v squid-debian10/srv/packages/*.tar $(REPO_ROOT)/debian/10/x86_64/

deploy-debian-bullseye-packages: deploy-debian-11-packages

deploy-bullseye-packages: deploy-debian-11-packages

deploy-debian-11-packages:
	mkdir -p $(REPO_ROOT)/debian/11/x86_64
	cp -v squid-debian11/srv/packages/*.tar $(REPO_ROOT)/debian/11/x86_64/


deploy-debian-jessie-packages: deploy-debian-9-packages

deploy-jessie-packages: deploy-debian-9-packages

deploy-debian-9-packages:
	mkdir -p $(REPO_ROOT)/debian/9/x86_64
	cp -v squid-debian9/srv/packages/*.tar $(REPO_ROOT)/debian/9/x86_64/



deploy-ubuntu-packages: deploy-ubuntu-1604-packages deploy-ubuntu-1804-packages deploy-ubuntu-2004-packages


deploy-1604-packages: deploy-ubuntu-1604-packages

deploy-ubuntu-1604-packages:
	mkdir -p $(REPO_ROOT)/ubuntu/16.04/x86_64
	cp -v squid-ubuntu1604/srv/packages/*.tar $(REPO_ROOT)/ubuntu/16.04/x86_64/

deploy-1804-packages: deploy-ubuntu-1804-packages

deploy-ubuntu-1804-packages:
	mkdir -p $(REPO_ROOT)/ubuntu/18.04/x86_64
	cp -v squid-ubuntu1804/srv/packages/*.tar $(REPO_ROOT)/ubuntu/18.04/x86_64/


deploy-2004-packages: deploy-ubuntu-2004-packages

deploy-ubuntu-2004-packages:
	mkdir -p $(REPO_ROOT)/ubuntu/20.04/x86_64
	cp -v squid-ubuntu2004/srv/packages/*.tar $(REPO_ROOT)/ubuntu/20.04/x86_64/

deploy-2204-packages: deploy-ubuntu-2204-packages

deploy-ubuntu-2204-packages:
	mkdir -p $(REPO_ROOT)/ubuntu/22.04/x86_64
	cp -v squid-ubuntu2204/srv/packages/*.tar $(REPO_ROOT)/ubuntu/22.04/x86_64/

clean-rpms-packages:
	rm -vf squid-centos-7/srv/packages/*.rpm 
	rm -vf squid-centos-8/srv/packages/*.rpm 
	rm -vf squid-centos-9/srv/packages/*.rpm 
	rm -vf squid-oracle-7/srv/packages/*.rpm 
	rm -vf squid-oracle-8/srv/packages/*.rpm 
	rm -vf squid-amzn-1/srv/packages/*.rpm
	rm -vf squid-amzn-2/srv/packages/*.rpm
	rm -vf squid-fedora-33/srv/packages/*.rpm
	rm -vf squid-fedora-35/srv/packages/*.rpm
