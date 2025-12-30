FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    meson \
    ninja-build \
    python3-full \
    libnuma-dev \
    pkg-config \
    libelf-dev \
    wget \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*


RUN python3 -m venv /opt/dpdk-venv
ENV PATH="/opt/dpdk-venv/bin:$PATH"
RUN pip install --no-cache-dir pyelftools meson ninja

ARG MAIN_DIRECTORY=DPDK
WORKDIR /${MAIN_DIRECTORY}
RUN mkdir -p /${MAIN_DIRECTORY}/logs


ARG DPDK_VERSION=24.03
RUN wget https://fast.dpdk.org/rel/dpdk-${DPDK_VERSION}.tar.xz

RUN tar -xf dpdk-${DPDK_VERSION}.tar.xz
COPY src/main.c dpdk-${DPDK_VERSION}/examples/rxtx_callbacks/
RUN cd dpdk-${DPDK_VERSION} && \
    meson setup -Dexamples=rxtx_callbacks build && \
    ninja -C build &&\
    cd ..

COPY scripts/* /${MAIN_DIRECTORY}/scripts/
RUN chmod +x /${MAIN_DIRECTORY}/scripts/run_example_dpdk.sh
