FROM ubuntu:22.04

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


# # Test by building demos
# RUN mkdir /test_libhal
# WORKDIR /test_libhal
# RUN git clone https://github.com/libhal/libhal-arm-mcu.git
# WORKDIR /test_libhal/libhal-arm-mcu
# RUN conan create . -pr:a hal/tc/gcc -pr hal/mcu/stm32f103c8 -b missing
# RUN conan build demos -pr:a hal/tc/gcc -pr hal/mcu/stm32f103c8 -b missing

RUN pip install puncover

WORKDIR /code

CMD ["/bin/bash"]
