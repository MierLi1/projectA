//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 2/1/2025
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.vh"    // Replace this with the 640x480 values for actual implementation

module vgadisplaydriver #(
    parameter Nchars = 64,       
    parameter smem_size = 1200,
    parameter bmem_init = "bitmapmem.mem" 
)(
    input wire clk,
    input wire [$clog2(smem_size)-1:0] smem_addr,
    input wire [$clog2(Nchars)-1:0] charcode,
    output wire [3:0] red, green, blue,
    output wire hsync, vsync
);

    wire [`xbits-1:0] x;
    wire [`ybits-1:0] y;
    wire activevideo;
    wire [11:0] bmem_color;
    wire [$clog2(16)-1:0] x_offset, y_offset;
    wire [$clog2(256*Nchars)-1:0] bmem_addr;
   
    vgatimer myvgatimer(.*);  
    

    assign smem_addr = ((y >> 4) << 5) + ((y>>4)<<3) + (x >> 4); 
    assign x_offset = x[3:0];
    assign y_offset = y[3:0];


    
    assign bmem_addr = {charcode, y_offset, x_offset}; 


    rom_module #(
        .Nloc(Nchars * 256), 
        .Dbits(12),          
        .initfile(bmem_init)
    ) bitmapmem (
        .addr(bmem_addr),
        .dout(bmem_color)
    );


    assign red   = activevideo ? bmem_color[11:8] : 4'b0;
    assign green = activevideo ? bmem_color[7:4]  : 4'b0;
    assign blue  = activevideo ? bmem_color[3:0]  : 4'b0;

endmodule
