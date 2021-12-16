%define release_number %(echo $RELEASE_NUMBER)
%define version_number %(echo $SOURCES_VERSION)
%define sources_url %(echo $SOURCES_URL)

Name:     squid
Version:  %{version_number}
Release:  %{release_number}%{?dist}

Summary:  The Squid proxy caching server
Epoch:    7
Packager: Eliezer Croitoru <eliezer@ngtech.co.il>
Vendor:   NgTech Ltd
License:  GPLv2+ and (LGPLv2+ and MIT and BSD and Public Domain)
Group:    System Environment/Daemons
URL:      http://www.squid-cache.org
Source0:  %{sources_url}
Source1:  %{sources_url}.asc
Source2:  squid.init
Source3:  squid.logrotate
Source4:  squid.sysconfig
Source5:  squid.pam
Source6:  squid.nm
Source7:  squid.service
Source8:  squidshut.sh

Patch0:   pinger_off_v4.patch
Patch1:   suspendbyoptionsonly.patch
Patch2:   default_visible_hostname.patch

Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
Requires: bash >= 2.0
Requires(pre): shadow-utils
Requires(post): /sbin/chkconfig
Requires(preun): /sbin/chkconfig
Requires(post): systemd
Requires(preun): systemd
Requires(postun): systemd
# squid_ldap_auth and other LDAP helpers require OpenLDAP
BuildRequires: openldap-devel
# squid_pam_auth requires PAM development libs
BuildRequires: pam-devel
# SSL support requires OpenSSL
BuildRequires: openssl-devel
# squid_kerb_aut requires Kerberos development libs
BuildRequires: krb5-devel
# ESI support requires Expat & libxml2
BuildRequires: expat-devel libxml2-devel
# TPROXY requires libcap, and also increases security somewhat
BuildRequires: libcap-devel
# eCAP support
#BuildRequires: libecap-devel
# 
BuildRequires: libtool libtool-ltdl-devel
# For test suite
#BuildRequires: cppunit-devel
# DB helper requires
BuildRequires: perl-podlators libdb-devel
## For Tproxy support the kernel linux development package is required
BuildRequires: kernel-uek-devel
# Required for netfilter support
BuildRequires: libnetfilter_conntrack-devel

%description
Squid is a high-performance proxy caching server for Web clients,
supporting FTP, gopher, and HTTP data objects. Unlike traditional
caching software, Squid handles all requests in a single,
non-blocking, I/O-driven process. Squid keeps meta data and especially
hot objects cached in RAM, caches DNS lookups, supports non-blocking
DNS lookups, and implements negative caching of failed requests.

Squid consists of a main server program squid, a Domain Name System
lookup program (dnsserver), a program for retrieving FTP data
(ftpget), and some management and client tools.

%package sysvinit
Group: System Environment/Daemons
Summary: SysV initscript for squid caching proxy
Requires: %{name} = %{epoch}:%{version}-%{release}
Requires(preun): /sbin/service
Requires(postun): /sbin/service

%description sysvinit
The squid-sysvinit contains SysV initscritps support.

%package helpers
Group: System Environment/Daemons
Summary: Squid helpers
Requires: %{name} = %{epoch}:%{version}-%{release}

%description helpers
The squid-helpers contains the external helpers.

## This package was used for debugging
#%package unsupported-helpers
#Group: System Environment/Daemons
#Summary: Squid unsupported helpers
#Requires: %{name} = %{epoch}:%{version}-%{release}

#%description unsupported-helpers
#The squid-helpers contains the external helpers which have special dependencies.

%prep
%setup -q
%patch0
%patch1
%patch2

%build
## the next if was causing selinux issues that was mentioned in the redhat bugzilla
#%ifarch sparcv9 sparc64 s390 s390x
#   CXXFLAGS="$RPM_OPT_FLAGS -fPIE" \
#   CFLAGS="$RPM_OPT_FLAGS -fPIE" \
#%else
#   CXXFLAGS="$RPM_OPT_FLAGS -fpie" \
#   CFLAGS="$RPM_OPT_FLAGS -fpie" \
#%endif
#LDFLAGS="$RPM_LD_FLAGS -pie -Wl,-z,relro -Wl,-z,now"

export CXXFLAGS="$RPM_OPT_FLAGS -fPIC"
export PERL=/usr/bin/perl

mkdir -p src/icmp/tests
mkdir -p tools/squidclient/tests
mkdir -p tools/tests

%configure \
   --disable-strict-error-checking \
   --exec_prefix=/usr \
   --libexecdir=%{_libdir}/squid \
   --localstatedir=/var \
   --datadir=%{_datadir}/squid \
   --sysconfdir=%{_sysconfdir}/squid \
   --with-logdir=%{_localstatedir}/log/squid \
   --with-pidfile=%{_localstatedir}/run/squid.pid \
   --disable-dependency-tracking \
   --enable-eui \
   --enable-follow-x-forwarded-for \
   --enable-auth \
   --enable-auth-basic="DB,LDAP,NCSA,NIS,PAM,POP3,RADIUS,SASL,SMB,getpwnam,fake" \
   --enable-auth-ntlm="fake" \
   --enable-auth-digest="file,LDAP,eDirectory" \
   --enable-auth-negotiate="kerberos,wrapper" \
<<<<<<< HEAD
   --enable-external-acl-helpers="kerberos_ldap_group,LDAP_group,delayer,file_userip,SQL_session,unix_group,session" \
=======
   --enable-external-acl-helpers="wbinfo_group,kerberos_ldap_group,LDAP_group,delayer,file_userip,SQL_session,unix_group,session" \
>>>>>>> 96db7dd... 4.17
   --enable-cache-digests \
   --enable-cachemgr-hostname=localhost \
   --enable-delay-pools \
   --enable-epoll \
   --enable-icap-client \
   --enable-ident-lookups \
   %ifnarch ppc64 ia64 x86_64 s390x aarch64
   --with-large-files \
   %endif
   --enable-linux-netfilter \
   --enable-removal-policies="heap,lru" \
   --enable-snmp \
   --enable-ssl \
   --enable-ssl-crtd \
   --enable-storeio="aufs,diskd,ufs,rock" \
   --enable-wccpv2 \
   --enable-esi \
   --with-aio \
   --with-default-user="squid" \
   --with-filedescriptors=16384 \
   --with-dl \
   --with-openssl \
   --enable-icmp \
   --disable-arch-native \
   --with-pthreads \
   --without-nettle

# Was disabled since the build requirments doesn't exit on OEL
#   --enable-ecap \

make \
	DEFAULT_SWAP_DIR='/var/spool/squid' \
	%{?_smp_mflags}

%check
#make check
echo "suppose to check but will not!!!!"
	
%install
rm -rf $RPM_BUILD_ROOT
make \
	DESTDIR=$RPM_BUILD_ROOT \
	install

mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/rc.d/init.d
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/logrotate.d
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/sysconfig
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/pam.d
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/NetworkManager/dispatcher.d
mkdir -p $RPM_BUILD_ROOT%{_unitdir}
mkdir -p $RPM_BUILD_ROOT%{_libexecdir}/squid
install -m 755 %{SOURCE2} $RPM_BUILD_ROOT%{_sysconfdir}/rc.d/init.d/squid
install -m 644 %{SOURCE3} $RPM_BUILD_ROOT%{_sysconfdir}/logrotate.d/squid
install -m 644 %{SOURCE4} $RPM_BUILD_ROOT%{_sysconfdir}/sysconfig/squid
install -m 644 %{SOURCE5} $RPM_BUILD_ROOT%{_sysconfdir}/pam.d/squid
install -m 644 %{SOURCE7} $RPM_BUILD_ROOT%{_unitdir}
install -m 644 %{SOURCE6} $RPM_BUILD_ROOT%{_sysconfdir}/NetworkManager/dispatcher.d/20-squid
install -m 755 %{SOURCE8} $RPM_BUILD_ROOT%{_sbindir}/squidshut.sh
mkdir -p $RPM_BUILD_ROOT/var/log/squid
mkdir -p $RPM_BUILD_ROOT/var/spool/squid
chmod 644 contrib/url-normalizer.pl contrib/user-agents.pl
iconv -f ISO88591 -t UTF8 ChangeLog -o ChangeLog.tmp
mv -f ChangeLog.tmp ChangeLog

# Move the MIB definition to the proper place (and name)
mkdir -p $RPM_BUILD_ROOT/usr/share/snmp/mibs
mv $RPM_BUILD_ROOT/usr/share/squid/mib.txt $RPM_BUILD_ROOT/usr/share/snmp/mibs/SQUID-MIB.txt

# squid.conf.documented is documentation. We ship that in doc/
rm -f $RPM_BUILD_ROOT%{_sysconfdir}/squid/squid.conf.documented

# remove unpackaged files from the buildroot
rm -f $RPM_BUILD_ROOT%{_bindir}/{RunAccel,RunCache}
#rm -f $RPM_BUILD_ROOT/squid.httpd.tmp

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
#%doc COPYING COPYRIGHT README ChangeLog QUICKSTART src/squid.conf.documented
%doc COPYING README ChangeLog QUICKSTART src/squid.conf.documented
%doc contrib/url-normalizer.pl contrib/user-agents.pl

%{_unitdir}/squid.service
%attr(755,root,root) %dir %{_libexecdir}/squid
#%attr(755,root,root) %{_libexecdir}/squid/cache_swap.sh
%attr(755,root,root) %dir %{_sysconfdir}/squid
%attr(755,root,root) %dir %{_libdir}/squid
%attr(750,squid,squid) %dir /var/log/squid
%attr(750,squid,squid) %dir /var/spool/squid
%attr(755,root,root) %{_sbindir}/squidshut.sh

#%config(noreplace) %attr(644,root,root) %{_sysconfdir}/httpd/conf.d/squid.conf
%config(noreplace) %attr(640,root,squid) %{_sysconfdir}/squid/squid.conf
%config(noreplace) %attr(644,root,squid) %{_sysconfdir}/squid/cachemgr.conf
%config(noreplace) %{_sysconfdir}/squid/mime.conf
%config(noreplace) %{_sysconfdir}/squid/errorpage.css
%config(noreplace) %{_sysconfdir}/sysconfig/squid
#%config(noreplace) %{_sysconfdir}/squid/msntauth.conf
# These are not noreplace because they are just sample config files
#%config %{_sysconfdir}/squid/msntauth.conf.default
%config %{_sysconfdir}/squid/squid.conf.default
%config %{_sysconfdir}/squid/mime.conf.default
%config %{_sysconfdir}/squid/errorpage.css.default
%config %{_sysconfdir}/squid/cachemgr.conf.default
%config(noreplace) %{_sysconfdir}/pam.d/squid
%config(noreplace) %{_sysconfdir}/logrotate.d/squid

%dir %{_datadir}/squid
%attr(-,root,root) %{_datadir}/squid/errors
%attr(755,root,root) %{_sysconfdir}/NetworkManager/dispatcher.d/20-squid
%{_datadir}/squid/icons
%{_sbindir}/squid
%{_bindir}/squidclient
%{_bindir}/purge
%{_mandir}/man8/*
%{_mandir}/man1/*
%{_libdir}/squid/diskd
%{_libdir}/squid/log_file_daemon
%{_libdir}/squid/unlinkd
%attr(4755,root,root) %{_libdir}/squid/pinger
#%{_libdir}/squid/*
%{_datadir}/snmp/mibs/SQUID-MIB.txt

%files sysvinit
%attr(755,root,root) %{_sysconfdir}/rc.d/init.d/squid

%files helpers
%{_libdir}/squid/basic_db_auth
%{_libdir}/squid/basic_getpwnam_auth
%{_libdir}/squid/basic_ldap_auth
%{_libdir}/squid/basic_ncsa_auth
%{_libdir}/squid/basic_nis_auth
%{_libdir}/squid/basic_pam_auth
%{_libdir}/squid/basic_pop3_auth
%{_libdir}/squid/basic_radius_auth
%{_libdir}/squid/basic_sasl_auth
%{_libdir}/squid/basic_smb_auth
%{_libdir}/squid/basic_smb_auth.sh
%{_libdir}/squid/basic_fake_auth
%{_libdir}/squid/cachemgr.cgi

%{_libdir}/squid/cert_tool

%{_libdir}/squid/digest_file_auth
%{_libdir}/squid/digest_ldap_auth
%{_libdir}/squid/digest_edirectory_auth
%{_libdir}/squid/ext_kerberos_ldap_group_acl
#%{_libdir}/squid/ext_wbinfo_group_acl

#%{_libdir}/squid/helper-mux.pl

%{_libdir}/squid/log_db_daemon
%{_libdir}/squid/negotiate_kerberos_auth
%{_libdir}/squid/negotiate_kerberos_auth_test
%{_libdir}/squid/negotiate_wrapper_auth
%{_libdir}/squid/ntlm_fake_auth
#%{_libdir}/squid/ntlm_smb_lm_auth
#%{_libdir}/squid/ssl_crtd
%{_libdir}/squid/storeid_file_rewrite

%{_libdir}/squid/url_fake_rewrite
%{_libdir}/squid/url_fake_rewrite.sh

%{_libdir}/squid/ext_delayer_acl
%{_libdir}/squid/ext_file_userip_acl
%{_libdir}/squid/ext_ldap_group_acl
%{_libdir}/squid/ext_sql_session_acl
%{_libdir}/squid/ext_unix_group_acl
%{_libdir}/squid/ext_session_acl
#%{_libdir}/squid/ext_time_quota_acl

%{_libdir}/squid/helper-mux
%{_libdir}/squid/security_fake_certverify
%{_libdir}/squid/security_file_certgen
%{_libdir}/squid/url_lfs_rewrite

# This pacakge was used for debugging
#%files unsupported-helpers
#%{_libdir}/squid/cert_valid.pl

#    File not found: /home/rpm/rpmbuild/BUILDROOT/squid-4.0.5-1.el7.x86_64/usr/lib64/squid/helper-mux.pl
#    File not found: /home/rpm/rpmbuild/BUILDROOT/squid-4.0.5-1.el7.x86_64/usr/lib64/squid/ssl_crtd
#    File not found: /home/rpm/rpmbuild/BUILDROOT/squid-4.0.5-1.el7.x86_64/usr/lib64/squid/cert_valid.pl


%pre
if ! getent group squid >/dev/null 2>&1; then
  /usr/sbin/groupadd -g 23 squid
fi

if ! getent passwd squid >/dev/null 2>&1 ; then
  /usr/sbin/useradd -g 23 -u 23 -d /var/spool/squid -r -s /sbin/nologin squid >/dev/null 2>&1 || exit 1 
fi

for i in /var/log/squid /var/spool/squid ; do
        if [ -d $i ] ; then
                for adir in `find $i -maxdepth 0 \! -user squid`; do
                        chown -R squid:squid $adir
                done
        fi
done

exit 0

%post
%systemd_post squid.service

%preun
%systemd_preun squid.service

%postun
%systemd_postun_with_restart squid.service

%triggerun --  %{name} < 7:3.2.0.9-1
        /sbin/chkconfig --del squid >/dev/null 2>&1 || :
        /bin/systemctl try-restart squid.service >/dev/null 2>&1 || :

%triggerpostun -n %{name}-sysvinit -- %{name} < 7:3.2.0.9-1
        /sbin/chkconfig --add squid >/dev/null 2>&1 || :


%postun helpers

%triggerin -- samba-common
if ! getent group wbpriv >/dev/null 2>&1 ; then
  /usr/sbin/groupadd -g 88 wbpriv >/dev/null 2>&1 || :
fi
/usr/sbin/usermod -a -G wbpriv squid >/dev/null 2>&1 || \
    chgrp squid /var/cache/samba/winbindd_privileged >/dev/null 2>&1 || :

%changelog
* Tue Jun 05 2018 Eliezer Croitoru <eliezer@ngtech.co.il>
- Starting to build 4.0.24-2 Beta package.

* Tue Feb 16 2016 Eliezer Croitoru <eliezer@ngtech.co.il>
- Starting to build 4.0.5-1 Beta package.

* Sun Jan 31 2016 Eliezer Croitoru <eliezer@ngtech.co.il>
- Starting to build 3.5.13-1 Stable package.
