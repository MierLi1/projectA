`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/12/2025 09:01:17 AM
// Design Name: 
// Module Name: fulladder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fulladder(
    input wire A,
    input wire B,
    input wire Cin,
    output wire Sum,
    output wire Cout
    );
     
    assign Sum = (Cin ^ A) ^ B;
    assign Cout = Cin & (A ^ B) | (A & B);
    
endmodule
