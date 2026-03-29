# Agent Notes

## Repository Purpose

This repository currently contains a single RTL block, `util_pwm_dshot_mux`, in [`rtl/util_pwm_dshot_mux.sv`](./rtl/util_pwm_dshot_mux.sv).

The block is intended for AMD/Xilinx devices, with the current target use case being Spartan UltraScale+.

## Design Summary

- `pad_a` is driven through an `IOBUFT` and connects to pin A of an external `SN74LVC1T45`.
- `pad_dir` is driven through an `OBUF` and connects to the level shifter `DIR` pin.
- `select_dshot=0` selects the PWM receive-only path.
- `select_dshot=1` selects the bidirectional DShot path.

The DShot path inserts one clock of turn-around time:

- Before driving out through the level shifter, `DIR` is switched to `A -> B` for one clock before enabling the FPGA output buffer.
- Before returning to receive mode, the FPGA output buffer is disabled for one clock before `DIR` is switched back to `B -> A`.

## Parameters

- `DSHOT_OEB_ACTIVE_LOW`
- `DIR_A_TO_B`
- `DIR_B_TO_A`

Defaults match the intended level-shifter usage, but check board polarity before integration.

## Verification

The module was syntax-checked with:

```sh
iverilog -g2012 -t null -s util_pwm_dshot_mux <primitive_stubs> rtl/util_pwm_dshot_mux.sv
```

Local stubs were used for `IOBUFT` and `OBUF` because Xilinx simulation libraries are not part of this repository.

## Current Layout

- `rtl/`: synthesizable source

No testbench or Vivado IP packaging collateral exists yet in this repository.
