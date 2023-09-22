FROM cgr.dev/chainguard/wolfi-base

ARG SCC_VERSION

RUN apk update -q \
    && apk add -q ca-certificates curl openjdk-8 procps \
    && rm -rf /var/cache/apk/*

ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH=$JAVA_HOME/bin:$PATH

WORKDIR /opt/sap/scc

RUN curl -fsSL -H "Cookie: eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt" \
    https://tools.hana.ondemand.com/additional/sapcc-${SCC_VERSION}-linux-x64.tar.gz | tar -xz

EXPOSE 8443
VOLUME ["/opt/sap/scc/config", "/opt/sap/scc/config_master", "/opt/sap/scc/scc_config", "/opt/sap/scc/log"]

ENTRYPOINT ["/bin/sh", "go.sh"]