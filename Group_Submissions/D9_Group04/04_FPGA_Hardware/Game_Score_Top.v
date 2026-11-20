`timescale 1ns/1ps
module Game_Score_Top (clk, sw, btn, led, RGB0, RGB1);
  input clk;
  input [15:0] sw;
  input [3:0] btn;
  output [15:0] led;
  output [2:0] RGB0;
  output [2:0] RGB1;

  parameter DIV_BIT = 19;

  reg [DIV_BIT:0] Div_Count;
  wire Slow_Clock;
  wire LED_LOW, LED_MEDIUM, LED_HIGH, LED_EXCELLENT;

  initial Div_Count = 0;

  always
    @ (posedge clk)
      Div_Count <= Div_Count + 1;

  assign Slow_Clock = Div_Count[DIV_BIT];

  Game_Score_Categorizer FSM (.Score(sw[3:0]), .START(btn[0]), .ACK(btn[1]),
                              .Clock(Slow_Clock), .Reset(btn[2]),
                              .LED_LOW(LED_LOW), .LED_MEDIUM(LED_MEDIUM),
                              .LED_HIGH(LED_HIGH), .LED_EXCELLENT(LED_EXCELLENT));

  assign led[0] = LED_LOW;
  assign led[1] = LED_MEDIUM;
  assign led[2] = LED_HIGH;
  assign led[3] = LED_EXCELLENT;
  assign led[15:4] = 12'b000000000000;

  assign RGB0[0] = LED_MEDIUM | LED_HIGH;
  assign RGB0[1] = LED_LOW | LED_MEDIUM;
  assign RGB0[2] = LED_EXCELLENT;
  assign RGB1 = 3'b000;
endmodule
