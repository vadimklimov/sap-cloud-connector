# syntax=docker/dockerfile:1

# Build image
FROM cgr.dev/chainguard/wolfi-base AS build

ARG SCC_VERSION

RUN apk update --quiet --no-cache \
    && apk add --quiet --no-cache curl

WORKDIR /var/downloads/scc

RUN curl -fsSL -H "Cookie: eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt" \
    https://tools.hana.ondemand.com/additional/sapcc-${SCC_VERSION}-linux-x64.tar.gz | tar -xz


# Deployment image
FROM cgr.dev/chainguard/wolfi-base

RUN apk update --quiet --no-cache \
    && apk add --quiet --no-cache openjdk-8 procps

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

WORKDIR /opt/sap/scc
COPY --from=build /var/downloads/scc .

EXPOSE 8443
VOLUME ["/opt/sap/scc/config", "/opt/sap/scc/config_master", "/opt/sap/scc/scc_config", "/opt/sap/scc/log"]

ENTRYPOINT ["/bin/sh", "go.sh"]