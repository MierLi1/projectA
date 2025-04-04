//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 2/5/2025
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module keyboard_test(
	input wire clk,
	input wire ps2_data,
	input wire ps2_clk,
	output wire [7:0] segments,
   	output wire [7:0] digitselect
   );

	wire [31:0] keyb_char;
 
	keyboard keyb(clk, ps2_clk, ps2_data, keyb_char);          // receive keyb_char from keyboard
   
	display8digit disp(keyb_char, clk, segments, digitselect); // display keyb_char on the 8-digit display

endmodule
