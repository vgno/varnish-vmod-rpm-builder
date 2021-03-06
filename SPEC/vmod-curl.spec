Summary: CURL support for Varnish VCL
Name: vmod-curl
Version: 4.1.20161215
Release: 1%{?dist}
License: BSD
Group: System Environment/Daemons
Source0: libvmod-curl.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
Requires: varnish >= 4.1.4
BuildRequires: make
BuildRequires: python-docutils
BuildRequires: varnish >= 4.1.4
BuildRequires: varnish-devel >= 4.1.4
BuildRequires: curl-devel > 7.19.0

%description
CURL support for Varnish VCL

%prep
%setup -n libvmod-curl

%build
./autogen.sh
./configure --prefix=/usr/ --docdir='${datarootdir}/doc/%{name}'
make

%install
make install DESTDIR=%{buildroot}
mkdir -p %{buildroot}/usr/share/doc/%{name}/
cp README.rst %{buildroot}/usr/share/doc/%{name}/
cp LICENSE %{buildroot}/usr/share/doc/%{name}/

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%{_libdir}/varnish/vmods/
%doc /usr/share/doc/%{name}/*
%{_mandir}/man?/*

%changelog
* Fri Jan 29 2016 Audun Ytterdal <audun.ytterdal@vg.no> 
- Varnish 4.1 support.
