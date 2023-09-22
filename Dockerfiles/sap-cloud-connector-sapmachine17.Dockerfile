FROM sapmachine:17

ARG SCC_VERSION

RUN apt update -q \
    && apt install -q -y --no-install-recommends ca-certificates wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/sap/scc

RUN wget -q --header "Cookie: eula_3_1_agreed=tools.hana.ondemand.com/developer-license-3_1.txt" \
    https://tools.hana.ondemand.com/additional/sapcc-${SCC_VERSION}-linux-x64.tar.gz -O - | tar -xz

EXPOSE 8443
VOLUME ["/opt/sap/scc/config", "/opt/sap/scc/config_master", "/opt/sap/scc/scc_config", "/opt/sap/scc/log"]

ENTRYPOINT ["./go.sh"]