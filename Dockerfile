FROM centos:7
MAINTAINER Audun Ytterdal <audun.ytterdal@vg.no>

RUN yum -y install yum-plugin-priorities && yum -q makecache
COPY yum-varnish4-community.repo /etc/yum.repos.d/varnish.repo
RUN yum -q makecache && \
    curl -O https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    rpm -Uvh epel-release-latest-7.noarch.rpm
RUN yum install -y rpm-build jemalloc-devel libedit-devel ncurses-devel pcre-devel python-docutils python-sphinx wget git automake autoconf libtool mock make logrotate initscripts systemd-sysv libcurl-devel vim geoip-devel mhash-devel libmaxminddb-devel

WORKDIR /root
RUN wget https://repo.varnish-cache.org/redhat/varnish-4.1/el7/src/varnish/varnish-4.1.4-1.el7.src.rpm
RUN rpm -Uvh varnish-4.1.4-1.el7.src.rpm
RUN rpmbuild -ba /root/rpmbuild/SPECS/varnish.spec
RUN rpm -Uvh /root/rpmbuild/RPMS/x86_64/varnish-4.1.4-1.el7.centos.x86_64.rpm /root/rpmbuild/RPMS/x86_64/varnish-devel-4.1.4-1.el7.centos.x86_64.rpm
WORKDIR /root/rpmbuild/SOURCES

RUN git clone -b master https://github.com/varnish/varnish-modules.git
RUN git clone -b master https://github.com/varnish/libvmod-curl.git
RUN git clone -b master https://github.com/varnish/libvmod-digest.git
RUN git clone -b 4.1 https://github.com/varnish/libvmod-rtstatus.git
RUN git clone -b 4.1 https://github.com/varnish/libvmod-shield.git
RUN git clone -b 4.1 https://github.com/ksperis/libvmod-statsd.git
RUN git clone -b master https://github.com/fgsch/libvmod-geoip2.git

RUN for f in *mod*; do tar czvf $f.tar.gz $f; done

COPY SPEC/* /root/rpmbuild/SPECS/
WORKDIR /root/rpmbuild/SPECS/
RUN for f in *.spec; do rpmbuild -ba $f; done

WORKDIR /root/rpmbuild/RPMS/x86_64
CMD /bin/bash
