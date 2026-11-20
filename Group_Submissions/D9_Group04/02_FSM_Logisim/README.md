# 02 – FSM and Logisim

| File | Content |
|---|---|
| `FSM_Design.md` | Moore model, state encoding, transition table, state table, next-state and output equations |
| `state_diagram.png` | State diagram |
| `Game_Score_Categorizer.circ` | Logisim Evolution 5.0.0 circuit: input register + range decoder + Moore FSM + LEDs |

## Circuit sections (left to right)
1. **Inputs:** S3–S0, START, ACK, RESET, CLK.
2. **Inverters:** complements of the state bits, ACK, RESET and IDLE.
3. **Input register:** 4 D flip-flops. Each D = IDLE·Si + IDLE'·Ri, so the register follows the switches only in IDLE and holds the value in every other state.
4. **Range decoder (comparators):** a splitter joins R3–R0 into the 4-bit bus `SCORE`. Three 4-bit unsigned Comparators (Arithmetic library) compare it with constants 4, 8 and 12, giving GT4, GT8 and E (= GT12). Then L = NOT GT4, M = GT4 · NOT GT8, H = GT8 · NOT E.
5. **Next-state logic:** D2, D1, D0 with synchronous RESET (ANDed with RESET').
6. **State register:** 3 D flip-flops Q2 Q1 Q0.
7. **Output logic (Moore):** three AND gates decode LOW, MEDIUM and HIGH from Q2 Q1 Q0; EXCELLENT uses the `EXC` decode from the next-state block.
8. **LEDs:** LOW (green), MEDIUM (yellow), HIGH (red), EXCELLENT (blue).

Signals between sections are joined with labelled tunnels (same name = same wire).

## How to test in Logisim
Note: in Logisim one Ctrl+T is half a clock cycle (clock high, then low), so a full clock edge needs Ctrl+T twice.

Easiest method: Simulate → Auto-Tick Enabled (Ctrl+K), tick frequency about 4 Hz. Then:
1. Select the Poke tool (hand) and set the score on S3–S0.
2. Click START to 1 and back to 0. The category LED turns on.
3. Change the switches: the LED must not change.
4. Click ACK to 1 and back to 0. All LEDs go off (IDLE).
5. Click RESET to 1 and back to 0 in any state: returns to IDLE.

Manual method (Auto-Tick off):
1. START = 0, ACK = 0, set S3–S0, press Ctrl+T twice so the register takes the score.
2. START = 1, Ctrl+T twice, START = 0. The category LED turns on.
3. ACK = 1, Ctrl+T twice, ACK = 0. Back to IDLE.

If START is raised on the same clock edge on which the register first loads the score, the FSM still sees the previous register value. Always give the register one clock in IDLE after changing the switches (Auto-Tick does this automatically).

Repeat for all 16 scores and record screenshots for 0, 4, 5, 8, 9, 12, 13, 15 in this folder as evidence.

## Expected results
| Score | State Q2Q1Q0 | LED |
|---|---|---|
| 0–4 | 001 | Green (LOW) |
| 5–8 | 010 | Yellow (MEDIUM) |
| 9–12 | 011 | Red (HIGH) |
| 13–15 | 100 | Blue (EXCELLENT) |

The netlist in the `.circ` file was checked by script for all 16 scores (START, hold, ACK, RESET, unused-state recovery): 16/16 pass. See `logisim_netlist_check.txt`.
