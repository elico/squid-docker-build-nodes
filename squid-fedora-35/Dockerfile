FROM fedora:35

RUN dnf install -y dnf-plugins-core \
   &&  dnf update -y \
   &&  dnf install -y gcc gcc-c++ libtool libtool-ltdl make cmake ccache \
		git pkgconfig sudo automake autoconf yum-utils rpm-build \
   &&  dnf install -y libxml2 expat-devel openssl-devel libcap \
		libtool-ltdl-devel git autoconf \
		automake libtool gcc-c++ bzip2 ed \
		make openldap-devel pam-devel libxml2-devel \
		libcap-devel screen vim nettle-devel redhat-lsb-core \
		libtdb-devel libtdb redhat-rpm-config rpm-build rpm-devel \
		libnetfilter_conntrack-devel \
   &&  dnf install -y perl-libwww-perl ruby ruby-devel \
   &&  dnf clean all

RUN dnf update -y \
   &&  dnf install -y systemd-units openldap-devel pam-devel \
		openssl-devel krb5-devel expat-devel \
		libxml2-devel libcap-devel libtool libtool-ltdl-devel \
		redhat-rpm-config libdb-devel \
		gnutls-devel rpmdevtools wget \
   &&  dnf clean all

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

USER builder

ENV FLAVOR=rpmbuild OS=centos DIST=fc35

CMD ["/srv/pkg"]

