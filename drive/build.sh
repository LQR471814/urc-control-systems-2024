conan build . \
	-pr mod-stm32f1-v5 \
	-pr arm-gcc-14.2 \
	-pr local \
	-b missing --lockfile-partial -v

