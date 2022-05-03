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
# See CREDITS for breakdown of non GPLv2+ code
License:  GPLv2+ and (LGPLv2+ and MIT and BSD and Public Domain)
Group:    System Environment/Daemons
URL:      http://www.squid-cache.org
Source0:  %{sources_url}
Source1:  %{sources_url}.asc
Source2:  squid.service
Source3:  squid.logrotate
Source4:  squid.sysconfig
Source5:  squid.pam
Source6:  squid.nm
Source7:  squidshut.sh
Patch0:   pinger_off_v4.patch
Patch1:   suspendbyoptionsonly.patch
Patch2:	  050-disable-intercept-host-header-forgery.patch
Patch3:   050-disable-intercept-host-header-forgery-5.4_1.patch
Patch4:   050-disable-intercept-host-header-forgery-5.4_2.patch
Patch5:   050-disable-intercept-host-header-forgery-5.4_3.patch
Patch6:   v6-host-strictct-verify-1-of-3.patch
Patch7:   v6-host-strictct-verify-2-of-3.patch
Patch8:   v6-host-strictct-verify-3-of-3.patch
Patch9:   v6-aclreg.cc-fix.patch

Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
Requires: bash >= 2.0
Requires(pre): shadow-utils
Requires(preun): systemd
Requires(postun): systemd
Requires: systemd-units
Requires: libtool-ltdl
#Requires: libecap
BuildRequires: systemd-units
# squid_ldap_auth and other LDAP helpers require OpenLDAP
BuildRequires: openldap-devel
# squid_pam_auth requires PAM development libs
BuildRequires: pam-devel
# SSL support requires OpenSSL
BuildRequires: openssl-devel
# squid_kerb_aut requires Kerberos development libs
BuildRequires: krb5-devel
# squid_session_auth requires DB4
##BuildRequires: db4-devel
# ESI support requires Expat & libxml2
BuildRequires: expat-devel libxml2-devel
# TPROXY requires libcap, and also increases security somewhat
BuildRequires: libcap-devel
# eCAP and some other need libltdl
BuildRequires: libtool libtool-ltdl-devel
# eCAP 1.0.0
#BuildRequires: libecap-devel libecap
# Required to allow debug package auto creation
BuildRequires: redhat-rpm-config
# Required by couple external acl helpers
BuildRequires: libdb-devel
# Required for specific features
##BuildRequires: libnetfilter_conntrack-devel
# Adding for future build use
BuildRequires: gnutls-devel

# Required to validate auto requires AutoReqProv: no
## aaaAutoReqProv: no

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

%prep
%setup -q
%patch0
#%patch1

%if "%{version_number}" < "5.0"

%patch2


%endif

%if "%{version_number}" > "5.0" && "%{version_number}" < "6.0"

%patch3
%patch4
%patch5


%endif

%if "%{version_number}" > "6.0" && "%{version_number}" < "7.0"

%patch9

%patch6
%patch7
%patch8

%endif

%package helpers
Group: System Environment/Daemons
Summary: Squid helpers
Requires: %{name} = %{epoch}:%{version}-%{release}

%description helpers
The squid-helpers contains the external helpers.

%build
#was added due to new squid features that will be added soon
export CXXFLAGS="$RPM_OPT_FLAGS -fPIC"
export PERL=/usr/bin/perl

mkdir -p src/icmp/tests
mkdir -p tools/squidclient/tests
mkdir -p tools/tests

%configure \
  --exec_prefix=/usr \
  --libexecdir=%{_libdir}/squid \
  --localstatedir=/var \
  --datadir=%{_datadir}/squid \
  --sysconfdir=%{_sysconfdir}/squid \
  --with-logdir=%{_localstatedir}/log/squid \
  --with-pidfile=%{_localstatedir}/run/squid.pid \
  --disable-dependency-tracking \
  --enable-follow-x-forwarded-for \
  --enable-auth \
  --enable-auth-basic="DB,LDAP,NCSA,PAM,POP3,RADIUS,SASL,SMB,getpwnam,fake" \
  --enable-auth-ntlm="fake" \
  --enable-auth-digest="file,LDAP,eDirectory" \
  --enable-auth-negotiate="kerberos,wrapper" \
  --enable-external-acl-helpers="wbinfo_group,kerberos_ldap_group,LDAP_group,delayer,file_userip,SQL_session,unix_group,session,time_quota" \
  --enable-cache-digests \
  --enable-cachemgr-hostname=localhost \
  --enable-delay-pools \
  --enable-epoll \
  --enable-icap-client \
  --enable-ident-lookups \
  %ifnarch ppc64 ia64 x86_64 s390x
  --with-large-files \
  %endif
  --enable-linux-netfilter \
  --enable-removal-policies="heap,lru" \
  --enable-snmp \
  --enable-storeio="aufs,diskd,ufs,rock" \
  --enable-wccpv2 \
  --enable-esi \
  --enable-security-cert-generators  \
  --enable-security-cert-validators \
  --enable-icmp \
  --with-aio \
  --with-default-user="squid" \
  --with-filedescriptors=16384 \
  --with-dl \
  --with-openssl \
  --enable-ssl-crtd \
  --with-pthreads \
  --with-included-ltdl \
  --disable-arch-native \
  --without-nettle

#  --enable-ecap \

make \
	DEFAULT_SWAP_DIR='/var/spool/squid' \
	%{?_smp_mflags}

#%install
%if %{?fedora}00%{?rhel} < 6
sed -i 's|password-auth|system-auth|' %{SOURCE5}
%endif
rm -rf $RPM_BUILD_ROOT
make \
	DESTDIR=$RPM_BUILD_ROOT \
	install
mkdir -p ${RPM_BUILD_ROOT}%{_unitdir}
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/rc.d/init.d
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/logrotate.d
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/sysconfig
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/pam.d
mkdir -p $RPM_BUILD_ROOT/usr/libexec/squid
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/NetworkManager/dispatcher.d
install -m 644 %{SOURCE3} $RPM_BUILD_ROOT%{_sysconfdir}/logrotate.d/squid
install -m 644 %{SOURCE4} $RPM_BUILD_ROOT%{_sysconfdir}/sysconfig/squid
install -m 644 %{SOURCE5} $RPM_BUILD_ROOT%{_sysconfdir}/pam.d/squid
install -m 644 %{SOURCE6} $RPM_BUILD_ROOT%{_sysconfdir}/NetworkManager/dispatcher.d/20-squid
install -m 644 %{SOURCE2} $RPM_BUILD_ROOT%{_unitdir}/squid.service
install -m 755 %{SOURCE7} $RPM_BUILD_ROOT%{_sbindir}/squidshut.sh

mkdir -p $RPM_BUILD_ROOT/var/log/squid
mkdir -p $RPM_BUILD_ROOT/var/spool/squid
#chmod 644 contrib/url-normalizer.pl contrib/rredir.* contrib/user-agents.pl
iconv -f ISO88591 -t UTF8 ChangeLog -o ChangeLog.tmp
mv -f ChangeLog.tmp ChangeLog

# Move the MIB definition to the proper place (and name)
mkdir -p $RPM_BUILD_ROOT/usr/share/snmp/mibs
mv $RPM_BUILD_ROOT/usr/share/squid/mib.txt $RPM_BUILD_ROOT/usr/share/snmp/mibs/SQUID-MIB.txt

# squid.conf.documented is documentation. We ship that in doc/
rm -f $RPM_BUILD_ROOT%{_sysconfdir}/squid/squid.conf.documented

# remove unpackaged files from the buildroot
rm -f $RPM_BUILD_ROOT%{_bindir}/{RunAccel,RunCache}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc COPYING README CREDITS ChangeLog QUICKSTART src/squid.conf.documented

%attr(755,root,root) %dir %{_sysconfdir}/squid
%attr(755,root,root) %dir %{_libdir}/squid
%attr(750,squid,squid) %dir /var/log/squid
%attr(750,squid,squid) %dir /var/spool/squid

%config(noreplace) %attr(640,root,squid) %{_sysconfdir}/squid/squid.conf
%config(noreplace) %attr(644,root,squid) %{_sysconfdir}/squid/cachemgr.conf
%config(noreplace) %{_sysconfdir}/squid/mime.conf
%config(noreplace) %{_sysconfdir}/squid/errorpage.css
%config(noreplace) %{_sysconfdir}/sysconfig/squid
# These are not noreplace because they are just sample config files
%config %{_sysconfdir}/squid/squid.conf.default
%config %{_sysconfdir}/squid/mime.conf.default
%config %{_sysconfdir}/squid/errorpage.css.default
%config %{_sysconfdir}/squid/cachemgr.conf.default
%config(noreplace) %{_sysconfdir}/pam.d/squid
%config(noreplace) %{_sysconfdir}/logrotate.d/squid

%dir %{_datadir}/squid
%attr(-,root,root) %{_datadir}/squid/errors
%attr(755,root,root) %{_sysconfdir}/NetworkManager/dispatcher.d/20-squid
%attr(755,root,root) %{_sbindir}/squidshut.sh
%{_datadir}/squid/icons
%{_sbindir}/squid
%{_bindir}/squidclient
%{_bindir}/purge

%{_mandir}/man1/squidclient.1.gz
%{_mandir}/man8/squid.8.gz
%{_mandir}/man1/purge.1.gz

%{_libdir}/squid/diskd
%{_libdir}/squid/log_file_daemon
%{_libdir}/squid/unlinkd
%attr(4755,root,root) %{_libdir}/squid/pinger

%{_datadir}/snmp/mibs/SQUID-MIB.txt
%{_unitdir}/squid.service

%files helpers
%{_libdir}/squid/basic_db_auth
%{_libdir}/squid/basic_getpwnam_auth
%{_libdir}/squid/basic_ldap_auth
%{_libdir}/squid/basic_ncsa_auth
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
%{_libdir}/squid/ext_wbinfo_group_acl
%{_libdir}/squid/helper-mux
%{_libdir}/squid/url_lfs_rewrite
%{_libdir}/squid/log_db_daemon
%{_libdir}/squid/negotiate_kerberos_auth
%{_libdir}/squid/negotiate_kerberos_auth_test
%{_libdir}/squid/negotiate_wrapper_auth
%{_libdir}/squid/ntlm_fake_auth
%{_libdir}/squid/storeid_file_rewrite
%{_libdir}/squid/url_fake_rewrite
%{_libdir}/squid/url_fake_rewrite.sh
%{_libdir}/squid/ext_delayer_acl
%{_libdir}/squid/ext_file_userip_acl
%{_libdir}/squid/ext_ldap_group_acl
%{_libdir}/squid/ext_session_acl
%{_libdir}/squid/ext_sql_session_acl
%{_libdir}/squid/ext_time_quota_acl
%{_libdir}/squid/ext_unix_group_acl

%{_libdir}/squid/helper-mux
%{_libdir}/squid/security_fake_certverify
%{_libdir}/squid/security_file_certgen
%{_libdir}/squid/url_lfs_rewrite

%{_mandir}/man8/basic_db_auth.8.gz
%{_mandir}/man8/basic_getpwnam_auth.8.gz
%{_mandir}/man8/basic_ldap_auth.8.gz
%{_mandir}/man8/basic_ncsa_auth.8.gz
%{_mandir}/man8/basic_pam_auth.8.gz
%{_mandir}/man8/basic_pop3_auth.8.gz
%{_mandir}/man8/basic_radius_auth.8.gz
%{_mandir}/man8/basic_sasl_auth.8.gz
%{_mandir}/man8/cachemgr.cgi.8.gz
%{_mandir}/man8/digest_file_auth.8.gz
%{_mandir}/man8/ext_delayer_acl.8.gz
%{_mandir}/man8/ext_file_userip_acl.8.gz
%{_mandir}/man8/ext_ldap_group_acl.8.gz
%{_mandir}/man8/ext_session_acl.8.gz
%{_mandir}/man8/ext_sql_session_acl.8.gz
%{_mandir}/man8/ext_time_quota_acl.8.gz
%{_mandir}/man8/ext_unix_group_acl.8.gz
%{_mandir}/man8/ext_wbinfo_group_acl.8.gz
%{_mandir}/man8/helper-mux.8.gz
%{_mandir}/man8/log_db_daemon.8.gz
%{_mandir}/man8/negotiate_kerberos_auth.8.gz
%{_mandir}/man8/security_fake_certverify.8.gz
%{_mandir}/man8/security_file_certgen.8.gz
%{_mandir}/man8/storeid_file_rewrite.8.gz
%{_mandir}/man8/url_lfs_rewrite.8.gz

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
echo "squid.conf.documented is at /usr/share/squid-%{version}/squid.conf.documented"
%systemd_post squid.service

%preun
%systemd_preun squid.service

%postun
%systemd_postun_with_restart squid.service

%postun helpers
%triggerin -- samba-common
if ! getent group wbpriv >/dev/null 2>&1 ; then
  /usr/sbin/groupadd -g 88 wbpriv >/dev/null 2>&1 || :
fi
/usr/sbin/usermod -a -G wbpriv squid >/dev/null 2>&1 || \
    chgrp squid /var/lib/samba/winbindd_privileged >/dev/null 2>&1 || :
    chmod 750 /var/lib/samba/winbindd_privileged  >/dev/null 2>&1 || :

%changelog
* Sun Sep 06 2020 Eliezer Croitoru <ngtech1ltd@gmail.com>
- Release 4.13 Stable.
