FROM ubuntu:latest

ENV PATH="/root/.local/bin/:${PATH}"

RUN apt-get update
RUN apt-get install curl -y
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN uv tool install conan

RUN apt-get install git -y
RUN apt-get install cmake -y

RUN --mount=type=cache,target=/root/.conan2 \
	conan remote add libhal-trunk https://libhal.jfrog.io/artifactory/api/conan/trunk-conan
RUN --mount=type=cache,target=/root/.conan2 \
	conan config install -sf profiles/baremetal/v2 https://github.com/libhal/conan-config.git
RUN --mount=type=cache,target=/root/.conan2 \
	conan profile detect --force
RUN --mount=type=cache,target=/root/.conan2 \
	conan config install -sf profiles/x86_64/linux/ -tf profiles https://github.com/libhal/conan-config.git

RUN --mount=type=cache,target=/root/.conan2 \
	conan config install -sf conan/profiles/v1 -tf profiles https://github.com/libhal/arm-gnu-toolchain.git
RUN --mount=type=cache,target=/root/.conan2 \
	conan config install -sf conan/profiles/v1 -tf profiles https://github.com/libhal/libhal-arm-mcu.git

RUN --mount=type=cache,target=/root/.conan2 \
	conan config install -sf conan/profiles/v2 -tf profiles https://github.com/libhal/libhal-lpc40.git
RUN --mount=type=cache,target=/root/.conan2 \
	conan config install -sf conan/profiles/v2 -tf profiles https://github.com/libhal/libhal-stm32f1.git
RUN --mount=type=cache,target=/root/.conan2 \
	conan config install -sf conan/profiles/v1 -tf profiles https://github.com/libhal/libhal-micromod.git

WORKDIR /root/urc-control-systems-2024
RUN git clone https://github.com/LQR471814/urc-control-systems-2024 .
RUN git checkout build_issues

WORKDIR /root/urc-control-systems-2024/drive
RUN --mount=type=cache,target=/root/.conan2 \
	conan build . -pr mod-stm32f1-v5 -pr arm-gcc-14.2 -b missing --lockfile-partial || true

CMD bash

