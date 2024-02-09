FROM ubuntu:23.04

RUN apt-get update \
   &&  apt-get upgrade -y \
   &&  apt-get install -y git wget build-essential sudo \
   &&  apt-get clean


ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Israel


RUN apt-get update \
   &&  apt-get upgrade -y \
   &&  apt-get install -y build-essential sharutils libzip-dev \
   &&  apt-get install -y autotools-dev libldap2-dev libpam0g-dev \
		libdb-dev libsasl2-dev libcppunit-dev libkrb5-dev \
		libcap-dev libexpat1-dev libxml2-dev libltdl-dev \
		comerr-dev pkg-config libnetfilter-conntrack-dev \
		nettle-dev libssl-dev lsb-release \
   &&  apt-get install -y ccache wget libgnutls28-dev libwww-perl \
   &&  apt-get clean

RUN useradd builder -m -G users,sudo \
   &&  echo "builder ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers \
   &&  chown -R builder /home/builder

#USER builder

ENV FLAVOR=deb OS=ubuntu DIST=lunar

CMD ["/srv/pkg"]
