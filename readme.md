# util_pwm_dshot_mux

`util_pwm_dshot_mux` is a small RTL wrapper for sharing one FPGA I/O with two internal designs:

- `design_pwm`: input only
- `design_dshot`: bidirectional with `in`, `out`, and `oeb`

The intended external connection is:

- FPGA `IOBUFT` pad to pin A of an `SN74LVC1T45`
- FPGA `OBUF` output to the level shifter `DIR` pin

## Files

- [`rtl/util_pwm_dshot_mux.sv`](./rtl/util_pwm_dshot_mux.sv)
- [`package_ip.tcl`](./package_ip.tcl)
- [`package_ip.sh`](./package_ip.sh)

## Interface

Inputs:

- `clk`
- `rst`
- `select_dshot`
- `dshot_out`
- `dshot_oeb`

Outputs:

- `pwm_in`
- `dshot_in`
- `pad_dir`

Bidirectional:

- `pad_a`

## Operating Modes

### PWM Selected

When `select_dshot=0`:

- `pad_a` is configured as input only
- `pad_dir` is set for `B -> A` translation through the level shifter
- `pwm_in` receives the sampled pad value

### DShot Selected

When `select_dshot=1`, `dshot_oeb` controls whether the FPGA should drive or receive.

Transmit entry sequence:

1. Set `DIR` for `A -> B`
2. Wait one clock
3. Enable the `IOBUFT` output driver

Receive return sequence:

1. Disable the `IOBUFT` output driver
2. Wait one clock
3. Set `DIR` for `B -> A`

This protects the external level shifter during direction changes.

## Parameters

- `DSHOT_OEB_ACTIVE_LOW`: set to `1` when `dshot_oeb` is active low
- `DIR_A_TO_B`: logic level applied to `pad_dir` for `A -> B`
- `DIR_B_TO_A`: logic level applied to `pad_dir` for `B -> A`

## Notes

- The inactive internal input is driven low.
- The module uses Xilinx primitives `IOBUFT` and `OBUF`.
- Reset returns the block to PWM receive mode.

## Vivado IP Packaging

To regenerate the local IP repository entry:

```sh
./package_ip.sh
```

This creates:

- `ip_repo/util_pwm_dshot_mux_1.0/component.xml`
- copied HDL and XGUI collateral under `ip_repo/util_pwm_dshot_mux_1.0/`
