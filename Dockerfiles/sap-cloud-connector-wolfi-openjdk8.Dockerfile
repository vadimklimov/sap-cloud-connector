# syntax=docker/dockerfile:1

# Build image
FROM cgr.dev/chainguard/wolfi-base AS build

ARG SCC_VERSION
ARG EULA_COOKIE=eula_3_2_agreed=tools.hana.ondemand.com/developer-license-3_2.txt

RUN apk update --quiet --no-cache \
    && apk add --quiet --no-cache curl

WORKDIR /var/downloads/scc

RUN curl -fsSL -H "Cookie: ${EULA_COOKIE}" \
    https://tools.hana.ondemand.com/additional/sapcc-${SCC_VERSION}-linux-x64.tar.gz | tar -xz \
    && mkdir log


# Deployment image
FROM cgr.dev/chainguard/wolfi-base

RUN apk update --quiet --no-cache \
    && apk add --quiet --no-cache openjdk-8 procps \
    && apk del --quiet --purge apk-tools wolfi-base wolfi-keys

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

USER nonroot
WORKDIR /opt/sap/scc
COPY --from=build --chown=nonroot:nonroot /var/downloads/scc .

EXPOSE 8443
VOLUME ["/opt/sap/scc/config", "/opt/sap/scc/config_master", "/opt/sap/scc/scc_config", "/opt/sap/scc/log"]

ENTRYPOINT ["/bin/ash", "go.sh"]