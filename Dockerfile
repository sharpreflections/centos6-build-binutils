FROM sharpreflections/centos6-build-base AS base
LABEL maintainer="dennis.brendel@sharpreflections.com"

ARG version=2.27-44.base.el7

WORKDIR /build/

FROM base as build-binutils
ARG version=2.27-44.base.el7
RUN yum -y install bc bison cvs dejagnu expect flex gettext glibc-static libgomp m4 sharutils tcl texinfo zlib-devel zlib-static && \
    curl --remote-name https://vault.centos.org/7.9.2009/os/Source/SPackages/binutils-$version.src.rpm && \
    rpm -i binutils-$version.src.rpm && \
    rm -f binutils-$version.src.rpm &&  \
    cd /root/rpmbuild/ && \
    sed -i '/%license/d' SPECS/binutils.spec && \
    sed -i 's/libstdc++-static/libstdc++/' SPECS/binutils.spec && \
    rpmbuild -bb SPECS/binutils.spec && \
    yum -y history undo last && \
    rm -rf SPECS SOURCES BUILD BUILDROOT


FROM base
ARG version=2.27-44.base.el7
COPY --from=build-binutils /root/rpmbuild/RPMS/x86_64/binutils-$version.rpm /tmp/
RUN yum -y install /tmp/binutils-2.25.1-9.el6.x86_64.rpm && \
    yum clean all && \
    rm /tmp/binutils-$version.rpm

