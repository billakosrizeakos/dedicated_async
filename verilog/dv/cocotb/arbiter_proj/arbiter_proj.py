# SPDX-FileCopyrightText: 2023 Efabless Corporation

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# SPDX-License-Identifier: Apache-2.0

from caravel_cocotb.caravel_interfaces import * # import python APIs
import cocotb

@cocotb.test()
async def test_start(dut):
    clock = cocotb.clock.Clock(dut.clock, 25, units="ns")
    cocotb.fork(clock.start())
    
    dut.RSTB <= 0
    dut.vccd1 <= 0
    dut.vssd1 <= 0

    await cocotb.triggers.ClockCycles(dut.clock, 10)
    dut.vccd1 <= 1

    await cocotb.triggers.ClockCycles(dut.clock, 100)
    dut.RSTB <= 1

    await cocotb.triggers.RisingEdge(dut.check_pin)


@cocotb.test() # cocotb test marker
@report_test # wrapper for configure test reporting files
async def arbiter_proj(dut):
   caravelEnv = await test_configure(dut) #configure, start up and reset caravel
   #await caravelEnv.release_csb()
   await caravelEnv.wait_mgmt_gpio(1)

   # initialize bus
   pin_start = 8
   pin_stop  = 13
   setup_bus(dut, list(range(pin_start,pin_stop+1)), 1)

   # write 0x0 to data bus
   caravelEnv.drive_gpio_in((10, 8), 0x0)
   await cocotb.triggers.Timer(10, units="ns")
   gpios_value_str = caravelEnv.monitor_gpio(13, 11).binstr
   cocotb.log.info (f"GPIO: Initialized to: {caravelEnv.monitor_gpio(37, 0).binstr}")


   # write data to data bus
   # gc | r1 | r0
   data = '011'
   caravelEnv.drive_gpio_in((10, 8), int(data, 2))
   await cocotb.triggers.Timer(10, units="ns")
   cocotb.log.info (f"GPIO: Given input sequence gc|r1|r0: {data}")
   
   counter = 0
   expected_gpio_value = '100'
   cocotb.log.info (f"Right before resampling GPIO")
   gpios_value_str = caravelEnv.monitor_gpio(13, 11).binstr
   cocotb.log.info (f"Right before entering the while loop")

   while True:
      cocotb.log.info ("While Loop: Top")
      if (gpios_value_str == expected_gpio_value):
         cocotb.log.info ("While Loop: Satisfied condition")
         cocotb.log.info (f"[TEST] Pass! GPIO value is : {gpios_value_str} after {counter}ns.")
         break
      else:
         cocotb.log.info ("While Loop: Unsatisfied condition")
         await cocotb.triggers.Timer(1, units="ns")
         gpios_value_str = caravelEnv.monitor_gpio(13, 11).binstr
         counter = counter + 1
         cocotb.log.info (f"GPIO: {caravelEnv.monitor_gpio(37, 0).binstr}")
         if counter == 10:
            cocotb.log.info ("While Loop: Timeout")
            cocotb.log.error (f"[TEST] Fail! GPIO value is : {gpios_value_str} expected {expected_gpio_value} after {counter}ns.")
            break


def setup_bus(dut, bus_pins, enable_mode):
   for idx in bus_pins:
      pin_name = 'dut.gpio' + str(idx) + '_en.value'
      exec(f"{pin_name} = {enable_mode}")
      cocotb.log.info(f"{pin_name} = {enable_mode}")
