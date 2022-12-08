// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "pwm.h"
#include "dev_access.h"

void set_pwm(pwm_t pwm, uint16_t counter, uint16_t pulse_width) {
  uint32_t output = (((uint32_t) counter) << 16) | pulse_width;
  pwm_t tmp_pwm = pwm;
  DEV_WRITE(pwm, output);
}
