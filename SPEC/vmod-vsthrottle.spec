Summary: vsthrottle support for Varnish VCL
Name: vmod-vsthrottle
Version: 4.1.20150129
Release: 1%{?dist}
License: BSD
Group: System Environment/Daemons
Source0: libvmod-vsthrottle.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
Requires: varnish >= 4.0.2
BuildRequires: make
BuildRequires: python-docutils
BuildRequires: varnish >= 4.0.2
BuildRequires: varnish-libs-devel >= 4.0.2

%description
vsthrottle support for Varnish VCL

%prep
%setup -n libvmod-vsthrottle

%build
./autogen.sh
./configure --prefix=/usr/ --docdir='${datarootdir}/doc/%{name}'
make
#make check

%install
make install DESTDIR=%{buildroot}
mkdir -p %{buildroot}/usr/share/doc/%{name}/
cp README.rst %{buildroot}/usr/share/doc/%{name}/
cp LICENSE %{buildroot}/usr/share/doc/%{name}/

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%{_libdir}/varnis*/vmods/
%doc /usr/share/doc/%{name}/*
%{_mandir}/man?/*

%changelog
* Fri Jan 29 2016 Audun Ytterdal <audun.ytterdal@vg.no> 
- Varnish 4.1 support.
