
all: touch-all-build-flags build


build-centos: clean-build-flags touch-centos-flags build 

build-centos-7: clean-build-flags touch-centos-7-flags build 

build-centos-8: clean-build-flags touch-centos-8-flags build 

centos-7: build-centos-7

centos-8: build-centos-8


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


touch-centos-flags: touch-centos7-flags touch-centos-8-flags

touch-centos-7-flags:
	touch ./squid-centos-7/build

touch-centos-8-flags:
	touch ./squid-centos-8/build


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
	touch ./squid-debian-9/build

touch-debian-10-flags:
	touch ./squid-debian-10/build


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
