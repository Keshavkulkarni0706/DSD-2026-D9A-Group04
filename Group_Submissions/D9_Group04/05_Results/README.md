# 05 – Results

## Test cases and expected vs observed
| Test ID | Inputs / conditions | Expected output | Logisim (netlist check) | Verilog simulation | FPGA hardware |
|---|---|---|---|---|---|
| T01 | RESET = 1 | IDLE (000), all LEDs off | Pass | Pending | Pending |
| T02 | START = 0 in IDLE | Stay IDLE | Pass | Pending | Pending |
| T03 | ACK = 1 in IDLE | Stay IDLE | Pass | Pending | Pending |
| T04a | Score 0–4, START | LOW (001), Green | Pass (5/5) | Pending | Pending |
| T04b | Score 5–8, START | MEDIUM (010), Yellow | Pass (4/4) | Pending | Pending |
| T04c | Score 9–12, START | HIGH (011), Red | Pass (4/4) | Pending | Pending |
| T04d | Score 13–15, START | EXCELLENT (100), Blue | Pass (3/3) | Pending | Pending |
| T04e | Change switches / press START while result shown | Result unchanged | Pass | Pending | Pending |
| T04f | ACK in any category state | IDLE | Pass | Pending | Pending |
| T05 | START held for several clocks | One transition, then hold | – | Pending | Pending |
| T06 | START and ACK together | IDLE: START acts; category: ACK acts | – | Pending | Pending |
| T07 | RESET in each category state | IDLE | Pass | Pending | Pending |
| T08 | Boundary scores 4, 5, 8, 9, 12, 13 | Correct category | Pass | Pending | Pending |
| T09 | Unused codes 101, 110, 111 | IDLE on next clock | Pass | Pending | – |

**Verilog:** pending, to be run in Vivado 2018.3 (`../03_Verilog_Implementation/Simulation_Results/`).
**Logisim:** circuit netlist simulated for all 16 scores, 16/16 pass (`../02_FSM_Logisim/logisim_netlist_check.txt`). Screenshots from Logisim Evolution 5.0.0 to be added.
**Hardware:** to be filled in after programming the Boolean board (`../04_FPGA_Hardware/`).

## Correctness analysis
- Every score 0–15 maps to exactly one category; the boundaries (4/5, 8/9, 12/13) were tested explicitly.
- Outputs are glitch-free with respect to input changes because they come only from the state register (Moore).
- The input register freezes the score when the FSM leaves IDLE, so the displayed category always matches the score that was sampled at START.

## Known limitations
- Only one score is classified at a time; the user must press ACK before the next score.
- On hardware, buttons are read on a ~95 Hz clock; a press shorter than about 10 ms might be missed (not possible by hand in practice).
- No error state is needed because every 4-bit value is a valid score.

## Conclusion
The four-category Moore FSM (H1) meets all requirements in Logisim. Verilog simulation and hardware results will be added after they are run in the lab.
