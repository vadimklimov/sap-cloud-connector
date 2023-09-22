# SAP Cloud Connector

Dockerfiles of SAP Cloud Connector Docker images.

## How to build Docker images

### Build arguments

| Argument    | Description                 |
| ----------- | --------------------------- |
| SCC_VERSION | SAP Cloud Connector version |
| JVM_VERSION | SAP JVM version             |

- When building an image that is based on the **Rocky Linux** base image, both build arguments `SCC_VERSION` and `JVM_VERSION` are required.
- When building an image that is based on the **SapMachine** or **Wolfi** base image, only the build argument `SCC_VERSION` is required.

SAP Cloud Connector and SAP JVM versions can be found at [SAP Development Tools - Cloud](https://tools.hana.ondemand.com/#cloud).

### Note about the target architecture

Images shall be built for a **Linux x86-64** (**amd64**) architecture.

By default, `docker build` uses the architecture of the host system where the Docker daemon is running (where `docker build` is run).

If the architecture of the host system is different from **amd64** (for example, when running build on a Mac computer with an Apple Silicon processor, or other machines running on the **arm64** architecture), make use of the multi-platform image build feature by using the `--platform` flag and specify the required target platform when invoking a build: `--platform linux/amd64`.

### Note about the distroless image

> [!WARNING]
> A SAP Cloud Connector Docker image that is based on the Wolfi image, uses software that is not supported by SAP Cloud Connector.

- Wolfi (a distroless base image)
- OpenJDK

The driving force and purpose for composing a Dockerfile of SAP Cloud Connector Docker image that is based on a distroless image, is to explore and probe the technical opportunities for optimization and minimization of an image size. It is an experimental image - use it at your own discretion and risk.

### Examples

```
docker build \
    -f sap-cloud-connector-rocky9-sapjvm.Dockerfile \
    -t sap-cloud-connector:2.16.0-rocky9-sapjvm8 \
    --build-arg SCC_VERSION=2.16.0 \
    --build-arg JVM_VERSION=8.1.095 \
    --platform linux/amd64 \
    .
```

```
docker build \
    -f sap-cloud-connector-wolfi-openjdk8.Dockerfile \
    -t sap-cloud-connector:2.16.0-wolfi-openjdk8 \
    --build-arg SCC_VERSION=2.16.0 \
    --platform linux/amd64 \
    .
```

```
docker build \
    -f sap-cloud-connector-sapmachine17.Dockerfile \
    -t sap-cloud-connector:2.16.0-sapmachine17 \
    --build-arg SCC_VERSION=2.16.0 \
    --platform linux/amd64 \
    .
```

## Usage

1. Create and start a container with SAP Cloud Connector.

Example:

```
docker run -d \
    --name sap-cloud-connector \
    -p 8443:8443 \
    -v scc_config:/opt/sap/scc/config \
    -v scc_config_master:/opt/sap/scc/config_master \
    -v scc_scc_config:/opt/sap/scc/scc_config \
    -v scc_logs:/opt/sap/scc/log \
    --platform linux/amd64 \
    sap-cloud-connector:2.16.0-wolfi-openjdk8
```

2. After the container is started and is healthy, SAP Cloud Connector admin UI can be accessed at [https://localhost:8443](https://localhost:8443).
