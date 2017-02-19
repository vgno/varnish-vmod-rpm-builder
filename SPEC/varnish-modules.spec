Summary: Collection of Varnish Cache modules (vmods) by Varnish Software
Name: varnish-modules
Version: 4.1.20161215
Release: 1%{?dist}
License: BSD
Group: System Environment/Daemons
Source0: varnish-modules.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
Requires: varnish >= 4.1.4
BuildRequires: make
BuildRequires: python-docutils
BuildRequires: varnish >= 4.1.4
BuildRequires: varnish-devel >= 4.1.4

%description
Collection of Varnish Cache modules (vmods) by Varnish Software

%prep
%setup -n varnish-modules

%build
./bootstrap
./configure --prefix=/usr/ --docdir='${datarootdir}/doc/%{name}'
make

%install
make install DESTDIR=%{buildroot}
mkdir -p %{buildroot}/usr/share/doc/%{name}/

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%{_libdir}/varnish/vmods/
%doc /usr/share/doc/%{name}/*
%{_mandir}/man?/*

%changelog
* Thu Dec 15 2016 Ole Fredrik Skudsvik <ole.fredrik.skudsvik@vg.no>
* Initial spec.
