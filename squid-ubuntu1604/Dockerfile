FROM ubuntu:16.04

RUN apt-get update \
   &&  apt-get upgrade -y \
   &&  apt-get install -y git wget build-essential sudo \
   &&  apt-get clean

RUN apt-get update \
   &&  apt-get upgrade -y \
   &&  apt-get install -y build-essential sharutils libzip-dev \
   &&  apt-get install -y autotools-dev libldap2-dev libpam0g-dev \
		libdb-dev libsasl2-dev libcppunit-dev libkrb5-dev \
		libcap-dev libexpat1-dev libxml2-dev libltdl-dev \
		comerr-dev pkg-config libnetfilter-conntrack-dev \
		nettle-dev libssl-dev lsb-release \
   &&  apt-get install -y ccache wget libgnutls-dev libwww-perl \
   &&  apt-get clean

RUN useradd builder -u 1000 -m -G users,sudo \
   &&  echo "builder ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers \
   &&  chown -R builder /home/builder

#USER builder

ENV FLAVOR=deb OS=ubuntu DIST=xenial

CMD ["/srv/pkg"]
