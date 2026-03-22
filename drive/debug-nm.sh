# TARGET="./build/micromod/mod-stm32f1-v5/Release/serial_command_demo.elf"

TOOL="/root/.conan2/p/b/arm-g77a9523e4873e/p/bin/bin/arm-none-eabi-objdump"

find build -name '*.obj' -print -exec "$TOOL" -S --size-sort -C {} \;

STARTUP="./build/micromod/mod-stm32f1-v5/Release/libstartup_code.a"

"$TOOL" -S --size-sort -C "$STARTUP"
