// Please see the screenshot of this file on the course website.
// Please type that in yourself, making sure that you fully
// understand the purpose of each line.
`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.vh"

module vgatimer(
    input wire clk,
    output wire hsync, vsync, activevideo,
    output wire [`xbits-1:0] x,
    output wire [`ybits-1:0] y
);

    logic [1:0] clk_count = 0;
    always_ff @(posedge clk)
        clk_count <= clk_count + 2'b 01;
        
    wire Every2ndTick = (clk_count[0] == 1'b1);
    wire Every4thTick = (clk_count[1:0] ==2'b11);
    
    xycounter #(`WholeLine, `WholeFrame) xy(clk, Every4thTick, x, y);
    
    assign hsync = (x>=`hSyncStart & x<=`hSyncEnd) ^ `hSyncPolarity;
    assign vsync = (y>=`vSyncStart & y<=`vSyncEnd) ^ `vSyncPolarity;
    assign activevideo = x< `hVisible & y < `vVisible;
    
endmodule
    
    