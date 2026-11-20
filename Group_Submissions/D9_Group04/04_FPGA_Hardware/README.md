# 04 – FPGA Hardware

| Item | Details |
|---|---|
| Board | RealDigital Boolean board |
| FPGA | Xilinx Spartan-7 xc7s50csga324-1 |
| Tool | Vivado 2018.3 |
| Board clock | 100 MHz on pin F14 |
| FSM clock | 100 MHz / 2^20 ≈ 95 Hz (`Div_Count[19]`) |
| Top module | `Game_Score_Top` (`Game_Score_Top.v`) |
| Core module | `Game_Score_Categorizer` (`../03_Verilog_Implementation/RTL/`) |
| Constraints | `Boolean_Game_Score.xdc` |

## Board I/O mapping
| Board item | Pin | Signal |
|---|---|---|
| SW0–SW3 | V2, U2, U1, T2 | Score[0]–Score[3] |
| BTN0 | J2 | START |
| BTN1 | J5 | ACK |
| BTN2 | H2 | RESET |
| LD0 | G1 | LOW (0–4) |
| LD1 | G2 | MEDIUM (5–8) |
| LD2 | F1 | HIGH (9–12) |
| LD3 | F2 | EXCELLENT (13–15) |
| RGB0 | V6 (R), V4 (G), U6 (B) | Category colour: Green, Yellow (R+G), Red, Blue |

## Why a slow clock
The FSM runs on a ~95 Hz clock taken from a 20-bit counter. A button press lasts about 100–300 ms, which is many slow clock periods, and the 10.5 ms period is longer than typical switch bounce, so the buttons are read cleanly without a separate debouncer. Since START is ignored once the FSM leaves IDLE, holding the button longer has no effect.

## Build in Vivado 2018.3
Option 1, script: open Vivado, Tcl Console, `cd` to this folder, then `source build_vivado.tcl`. It creates the project, runs synthesis, implementation and bitstream, writes `reports/utilization.txt`, `reports/timing_summary.txt`, `reports/power.txt` and copies `Game_Score_Top.bit` here.

Option 2, GUI:
1. Create Project → RTL Project → part `xc7s50csga324-1`.
2. Add sources `Game_Score_Categorizer.v` and `Game_Score_Top.v`; set `Game_Score_Top` as top.
3. Add constraints `Boolean_Game_Score.xdc`.
4. Add simulation source `tb_Game_Score_Categorizer.v`.
5. Run Synthesis → Run Implementation → Generate Bitstream.
6. Open Hardware Manager → Open Target → Auto Connect → Program Device.
7. Save Report Utilization (LUTs, FFs, CARRY4) screenshots here for the slides.

## Hardware test procedure
| Step | Action | Expected |
|---|---|---|
| H1 | Press BTN2 (RESET) | All category LEDs and RGB off |
| H2 | SW3–SW0 = 0011 (3), press BTN0 | LD0 on, RGB green |
| H3 | Change switches | No change |
| H4 | Press BTN1 (ACK) | All off, state 000 |
| H5 | 0110 (6), BTN0 | LD1 on, RGB yellow |
| H6 | 1010 (10), BTN0 after ACK | LD2 on, RGB red |
| H7 | 1110 (14), BTN0 after ACK | LD3 on, RGB blue |
| H8 | Boundaries 4, 5, 8, 9, 12, 13 | Correct category each time |
| H9 | RESET while a result is shown | All off |

Record a photo or short video of each case in this folder as hardware evidence.
