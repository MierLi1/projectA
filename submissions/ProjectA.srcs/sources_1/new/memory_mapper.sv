`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2025 04:57:10 PM
// Design Name: 
// Module Name: memory_mapper
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


`timescale 1ns / 1ps

module memory_mapper #(
    parameter wordsize = 32
)(
    input wire [wordsize-1:0] cpu_addr,
    input wire cpu_wr,
    output wire [wordsize-1:0] cpu_readdata,

    output wire dmem_wr,
    input wire [wordsize-1:0] dmem_readdata,
    
    output wire smem_wr,
    input wire [wordsize-1:0] smem_readdata,
    
    output wire sound_wr,
    output wire lights_wr,
    input wire [wordsize-1:0] keyb_char,
    input wire [wordsize-1:0] accel_val
);


    assign dmem_wr   = (cpu_wr & (cpu_addr[17:16] == 2'b01));
    assign smem_wr   = (cpu_wr & (cpu_addr[17:16] == 2'b10));
    assign lights_wr = (cpu_wr & (cpu_addr[17:16] == 2'b11) && (cpu_addr[3:2] == 2'b11));
    assign sound_wr  = (cpu_wr & (cpu_addr[17:16] == 2'b11) && (cpu_addr[3:2] == 2'b10));

    assign cpu_readdata = (cpu_addr[17:16] == 2'b01) ? dmem_readdata :
                          (cpu_addr[17:16] == 2'b10) ? smem_readdata :
                          ((cpu_addr[17:16] == 2'b11) && (cpu_addr[3:2] == 2'b01)) ? accel_val :
                          ((cpu_addr[17:16] == 2'b11) && (cpu_addr[3:2] == 2'b00)) ? keyb_char :
                          {wordsize{1'bx}};


endmodule

