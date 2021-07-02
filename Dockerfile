FROM sharpreflections/centos6-build-base AS base
LABEL maintainer="dennis.brendel@sharpreflections.com"

WORKDIR /build/

FROM base as build-binutils
ARG version=2.27-44.base
RUN yum -y install bc bison cvs dejagnu expect flex gettext glibc-static libgomp m4 sharutils tcl texinfo zlib-devel zlib-static && \
    curl --remote-name https://vault.centos.org/7.9.2009/os/Source/SPackages/binutils-$version.el7.src.rpm && \
    rpm -i binutils-$version.el7.src.rpm && \
    rm -f binutils-$version.el7.src.rpm &&  \
    cd /root/rpmbuild/ && \
    sed -i '/%license/d' SPECS/binutils.spec && \
    sed -i 's/libstdc++-static/libstdc++/' SPECS/binutils.spec && \
    rpmbuild -bb SPECS/binutils.spec && \
    yum -y history undo last && \
    rm -rf SPECS SOURCES BUILD BUILDROOT


FROM base
ARG version=2.27-44.base
COPY --from=build-binutils /root/rpmbuild/RPMS/x86_64/binutils-$version.el6.x86_64.rpm /tmp/
RUN yum -y install /tmp/binutils-$version.el6.x86_64.rpm && \
    yum clean all && \
    rm /tmp/binutils-$version.el6.x86_64.rpm

