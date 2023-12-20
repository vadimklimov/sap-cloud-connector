# syntax=docker/dockerfile:1

# Build image
FROM rockylinux:9 AS build

ARG SCC_VERSION
ARG JVM_VERSION

SHELL ["/bin/bash", "-c"]

RUN dnf update -y \
    && dnf install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs bsdtar \
    && dnf clean all

WORKDIR /tmp/downloads

RUN mkdir jvm scc \
    && curl -fsSL --remote-name-all -H "Cookie: eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt" \
    https://tools.hana.ondemand.com/additional/{sapjvm-${JVM_VERSION}-linux-x64.zip,sapcc-${SCC_VERSION}-linux-x64.tar.gz} \
    && bsdtar -x -C jvm --strip-components 1 -f sapjvm-${JVM_VERSION}-linux-x64.zip && rm -f $_ \
    && bsdtar -x -C scc -f sapcc-${SCC_VERSION}-linux-x64.tar.gz && rm -f $_


# Deployment image
FROM rockylinux:9-minimal

RUN microdnf update -y \
    && microdnf install -y --setopt=install_weak_deps=0 --setopt=tsflags=nodocs lsof procps-ng \
    && microdnf clean all

COPY --from=build /tmp/downloads /opt/sap

ENV JAVA_HOME=/opt/sap/jvm
ENV PATH=$JAVA_HOME/bin:$PATH

EXPOSE 8443
VOLUME ["/opt/sap/scc/config", "/opt/sap/scc/config_master", "/opt/sap/scc/scc_config", "/opt/sap/scc/log"]

WORKDIR /opt/sap/scc
ENTRYPOINT ["./go.sh"]