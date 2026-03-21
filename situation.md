- `conan build` is reporting flash size overflow in basically all
  the demos in `drive/`.
- This should not be happening, as demos can be built normally by
  all other members.
- The microcontroller we are using, `stm32f103c8` only has 64 kB
  of flash memory.
- `puncover` shows that the actual code (including my serial
  commands lib) in the output binary only occupies around ~10 kB.
    - `picolibc` takes up around 8 kB
    - `libhal` stuff takes up around 11 kB in total
    - Some unknown (seemingly memory allocator functions) takes up
      around 15 kB
    - Code takes up around 10 kB
