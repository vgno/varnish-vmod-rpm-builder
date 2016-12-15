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

RUN git clone https://github.com/varnish/libvmod-var.git && cd libvmod-var && git checkout master
RUN git clone https://github.com/varnish/libvmod-cookie.git && cd libvmod-cookie && git checkout master
RUN git clone https://github.com/varnish/libvmod-curl.git && cd libvmod-curl && git checkout master
RUN git clone https://github.com/varnish/libvmod-xkey.git && cd libvmod-xkey && git checkout master
RUN git clone https://github.com/varnish/libvmod-rtstatus.git && cd libvmod-rtstatus && git checkout 4.1
RUN git clone https://github.com/varnish/libvmod-digest.git && cd libvmod-digest && git checkout master
RUN git clone https://github.com/varnish/libvmod-vsthrottle.git && cd libvmod-vsthrottle && git checkout master
RUN git clone https://github.com/varnish/libvmod-saintmode.git && cd libvmod-saintmode && git checkout master
RUN git clone https://github.com/varnish/libvmod-header.git
RUN git clone https://github.com/fgsch/libvmod-geoip2.git && cd libvmod-geoip2 && git checkout master
RUN git clone https://github.com/varnish/libvmod-geoip.git && cd libvmod-geoip && git checkout master
RUN git clone https://github.com/varnish/libvmod-shield.git && cd libvmod-shield && git checkout 4.1
RUN git clone https://github.com/ksperis/libvmod-statsd.git && cd libvmod-statsd && git checkout 4.1
RUN for i in libvmod*; do tar czvf $i.tar.gz $i;done

COPY SPEC/* /root/rpmbuild/SPECS/
WORKDIR /root/rpmbuild/SPECS/
RUN for i in vmod*.spec; do rpmbuild -ba $i;done

WORKDIR /root/rpmbuild/RPMS/x86_64
CMD /bin/bash
