FROM sharpreflections/centos6-build-base AS base
LABEL maintainer="dennis.brendel@sharpreflections.com"

ARG prefix=/opt

WORKDIR /build/

FROM base as build-binutils
RUN yum -y install bc bison cvs dejagnu expect flex gettext glibc-static libgomp m4 sharutils tcl texinfo zlib-devel zlib-static && \
    curl --remote-name https://kojipkgs.fedoraproject.org//packages/binutils/2.25.1/9.fc24/src/binutils-2.25.1-9.fc24.src.rpm && \
    rpm -i binutils-2.25.1-9.fc24.src.rpm && \
    rm -f binutils-2.25.1-9.fc24.src.rpm &&  \
    cd /root/rpmbuild/ && \
    sed -i 's/libstdc++-static/libstdc++/' SPECS/binutils.spec && \
    rpmbuild -bb SPECS/binutils.spec && \
    rm -rf SPECS SOURCES BUILD BUILDROOT


FROM base
COPY --from=build-binutils /root/rpmbuild/RPMS/x86_64/binutils-2.25.1-9.el6.x86_64.rpm /tmp/
RUN yum -y install /tmp/binutils-2.25.1-9.el6.x86_64.rpm && \
    yum clean all && \
    rm /tmp/binutils-2.25.1-9.el6.x86_64.rpm

