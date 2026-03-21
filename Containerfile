FROM ubuntu:22.04

# install conan & core build deps
RUN apt update --fix-missing && apt upgrade -y
RUN apt install gcc g++ valgrind neofetch git wget python3-pip clang-format software-properties-common locales htop -y

RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh 21
RUN apt install libc++-21-dev libc++abi-21-dev -y

RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt install -y build-essential g++-12
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN add-apt-repository "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-21 main"
RUN apt-get install clang-tidy-21 -y
RUN python3 -m pip install "conan>=2.2.2" cmake

# setup conan
RUN conan config install https://github.com/libhal/conan-config2.git
RUN conan hal setup
RUN conan config install -sf conan/profiles/v1 -tf profiles https://github.com/libhal/arm-gnu-toolchain.git
RUN conan config install -sf conan/profiles/v1 -tf profiles https://github.com/libhal/libhal-arm-mcu.git
RUN conan config install -sf conan/profiles/v2 -tf profiles https://github.com/libhal/libhal-lpc40.git
RUN conan config install -sf conan/profiles/v2 -tf profiles https://github.com/libhal/libhal-stm32f1.git
RUN conan config install -sf conan/profiles/v1 -tf profiles https://github.com/libhal/libhal-micromod.git

# override libhal-arm-mcu
RUN git clone https://github.com/libhal/libhal-arm-mcu.git /code/libhal-arm-mcu
WORKDIR /code/libhal-arm-mcu
RUN git checkout fix-rom-and-ram-size-for
RUN conan create . -pr stm32f103c8 -pr arm-gcc-14.2 --version=1.21.1 -b=missing

# build
RUN git clone https://github.com/LQR471814/urc-control-systems-2024.git /code/urc-control-systems-2024/
WORKDIR /code/urc-control-systems-2024/drive
RUN git checkout new-arm-mcu
RUN conan install . -pr mod-stm32f1-v5 -pr arm-gcc-14.2 -b missing --lockfile-partial
RUN printf "[conf]\ntools.build:cxxflags+=['-Wno-error=stringop-overflow']\ntools.build:cflags+=['-Wno-error=stringop-overflow']" > /code/urc-control-systems-2024/drive/local
RUN sh -c "conan build . -pr ./local -pr mod-stm32f1-v5 -pr arm-gcc-14.2 --lockfile-partial; conan list"

CMD ["/bin/bash"]
