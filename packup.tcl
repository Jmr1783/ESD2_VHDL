# ##############################################################################
# Dr. Kaputa
# Vivado Scripting Utopia
# SPDX-License-Identifier: BSD-3-Clause [https://spdx.org/licenses/]
# ##############################################################################

#set projectName
set projectName blinkAXI

# 0: setup project, 1: setup and compile project
set compileProject 0

  # copy over .bit file to system.bit
  file copy -force project/$projectName.runs/impl_1/design_1_wrapper.bit system.bit

  # create system.bit.bin file for linux flashing
  exec bootgen -image bootimage.bif -arch zynq -process_bitstream bin
