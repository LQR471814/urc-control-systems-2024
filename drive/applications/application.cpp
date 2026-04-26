#include <libhal-util/serial.hpp>
#include <libhal-util/steady_clock.hpp>
#include <libhal/error.hpp>
#include <libhal/units.hpp>
#include <resource_list.hpp>

namespace sjsu::drive {

void application()
{
  auto console = resources::console();
  auto clock = resources::clock();

  while (true) {
    hal::print(*console, "Hello world!\n");
    hal::delay(*clock, 250ms);
  }
}
}  // namespace sjsu::drive
