FROM amazonlinux:1

RUN yum clean all \
   &&  yum update --exclude=filesystem -y \
   &&  yum install -y gcc gcc-c++ libtool libtool-ltdl make \
		cmake git pkgconfig sudo automake autoconf yum-utils rpm-build \
   &&  yum install -y libxml2 expat-devel openssl-devel libcap \
		ccache libtool-ltdl-devel cppunit cppunit-devel \
		bzr git autoconf automake libtool gcc-c++ perl-Pod-MinimumVersion \
		bzip2 ed make openldap-devel pam-devel db4-devel libxml2-devel \
		libcap-devel screen vim nettle-devel redhat-lsb-core \
		autoconf-archive libtdb-devel libtdb redhat-rpm-config rpm-build rpm-devel \
   &&  yum install -y perl-libwww-perl ruby ruby-devel \
   &&  yum clean all

RUN yum update --exclude=filesystem -y \
   &&  yum install -y systemd-units openldap-devel pam-devel \
		openssl-devel krb5-devel db4-devel expat-devel \
		libxml2-devel libcap-devel libtool libtool-ltdl-devel \
		redhat-rpm-config libdb-devel libnetfilter_conntrack-devel \
		gnutls-devel rpmdevtools wget \
   &&  yum clean all

## Ccache

RUN wget https://github.com/ccache/ccache/releases/download/v3.7.6/ccache-3.7.6.tar.gz -P /tmp/ && \
	tar xvf /tmp/ccache-3.7.6.tar.gz -C /tmp/ && \
	cd /tmp/ccache-3.7.6 && ./configure && \
	make && \
	make install && mkdir -p /usr/lib/ccache && \
	cd /usr/lib/ccache/ && \
	ln -s /usr/local/bin/ccache /usr/lib/ccache/gcc && \
	ln -s /usr/local/bin/ccache /usr/lib/ccache/g++ && \
	ln -s /usr/local/bin/ccache /usr/lib/ccache/cc && \
	ln -s /usr/local/bin/ccache /usr/lib/ccache/c++ && \
	rm /tmp/ccahe* -rf

RUN useradd builder -u 1000 -m -G users,wheel \
   &&  echo "builder ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers \
   &&  echo "# macros" > /home/builder/.rpmmacros \
   &&  echo "%_topdir /home/builder/rpm" >> /home/builder/.rpmmacros \
   &&  echo "%_sourcedir %{_topdir}/SOURCES" >> /home/builder/.rpmmacros \
   &&  echo "%_builddir %{_topdir}/BUILD" >> /home/builder/.rpmmacros \
   &&  echo "%_specdir %{_topdir}/SPECS" >> /home/builder/.rpmmacros \
   &&  echo "%_rpmdir %{_topdir}/RPMS" >> /home/builder/.rpmmacros \
   &&  echo "%_srcrpmdir %{_topdir}/SRPMS" >> /home/builder/.rpmmacros \
   &&  mkdir /home/builder/rpm \
   &&  chown -R builder /home/builder

#USER builder
USER root

ENV FLAVOR=rpmbuild OS=amzn DIST=amzn1

CMD ["/srv/pkg"]
