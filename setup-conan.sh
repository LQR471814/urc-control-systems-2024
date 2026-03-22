conan config install https://github.com/libhal/conan-config2.git
conan hal setup

conan config install -sf conan/profiles/v1 -tf profiles https://github.com/libhal/arm-gnu-toolchain.git
conan config install -sf conan/profiles/v1 -tf profiles https://github.com/libhal/libhal-arm-mcu.git
conan config install -sf conan/profiles/v2 -tf profiles https://github.com/libhal/libhal-lpc40.git
conan config install -sf conan/profiles/v2 -tf profiles https://github.com/libhal/libhal-stm32f1.git
conan config install -sf conan/profiles/v1 -tf profiles https://github.com/libhal/libhal-micromod.git

