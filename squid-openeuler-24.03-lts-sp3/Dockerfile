FROM openeuler/openeuler:24.03-lts-sp3

RUN sed -i -e 's@^metalink=@#metlink=@g' \
	-e 's@https://repo.openeuler.org@https://mirror.accum.se/mirror/openeuler.org/@g' \
	-e 's@gpgkey=http://@gpgkey=https://@g' \
		/etc/yum.repos.d/openEuler.repo && \
	dnf update -y && \
	dnf clean all

RUN dnf install -y vim && \
	dnf install -y openldap-devel pam-devel openssl-devel krb5-devel libtdb-devel expat-devel \
		libxml2-devel libcap-devel libecap-devel gcc-c++ libtool libtool-ltdl-devel \
		perl-generators pkgconfig chrpath systemd-devel && \
	dnf clean all

RUN dnf install -y gnutls-devel rpmdevtools wget ccache && \
	dnf clean all

RUN dnf install -y sudo && \
	dnf clean all

RUN dnf install -y libdb-devel libnetfilter_conntrack-devel openEuler-rpm-config && \
	dnf clean all

RUN dnf install -y gcc make && \
	dnf install -y groff groff-doc && \
	dnf install -y mandoc && \
	dnf install -y rpm-build && \
	dnf clean all

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

ENV FLAVOR=rpmbuild OS=openEuler DIST=oe2403sp3

CMD ["/srv/pkg"]
