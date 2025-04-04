`timescale 1ns / 1ps

module memIO #(
    parameter wordsize = 32,
    parameter dmem_size = 1024,
    parameter dmem_init = "",
    parameter Nchars = 256,
    parameter smem_size = 4096,
    parameter smem_init = ""
)(
    input wire clk,                  // Clock input
    input wire cpu_wr,                // Write enable
    input wire [wordsize-1:0] cpu_addr,        // CPU address
    input wire [wordsize-1:0] cpu_writedata,   // Data from CPU
    output wire [wordsize-1:0] cpu_readdata,   // Data to CPU

    input wire [$clog2(smem_size)-1:0] vga_addr,        // VGA address input
    output wire [$clog2(Nchars)-1:0] vga_readdata,    // VGA output data (charcode)

    input wire [wordsize-1:0] keyb_char,        // Keyboard character input
    input wire [wordsize-1:0] accel_val,        // Accelerometer value input
    output wire [wordsize-1:0] period,           // Period input (e.g., for timing-related I/O)
    output wire [15:0] lights           // LED output
);

    wire lights_wr, sound_wr, smem_wr, dmem_wr;
    wire [wordsize-1:0] smem_readdata, dmem_readdata;
    
   memory_mapper #(.wordsize(wordsize)
   ) map(.cpu_wr, .cpu_addr, .cpu_readdata, .lights_wr, .sound_wr, .accel_val, .keyb_char, .smem_wr, .smem_readdata, .dmem_wr, .dmem_readdata);
   
   logic [15:0] LED_reg = 16'h0000;
   logic [wordsize-1:0] sound_reg = {wordsize{1'b0}};
   
   always_ff @(posedge clk) begin
       if(lights_wr) begin
         LED_reg <= cpu_writedata[15:0];
       end
       if(sound_wr) begin
         sound_reg <= cpu_writedata;
       end
   end
   
   assign lights = LED_reg;
   assign period = sound_reg;
   wire [$clog2(Nchars)-1:0] cpu_char;
   assign smem_readdata = {{(wordsize-$clog2(Nchars)){1'b0}}, cpu_char};
   
   ram2port_module #(.Nloc(smem_size), .Dbits($clog2(Nchars)), .initfile(smem_init)) screen_mem(.clock(clk), .wr(smem_wr), 
   .addr1(cpu_addr[wordsize-1:2]), .addr2(vga_addr), .din(cpu_writedata), .dout1(cpu_char), .dout2(vga_readdata));
   
   ram_module #(.Nloc(dmem_size), .Dbits(wordsize), .initfile(dmem_init)) data_mem(.clock(clk), .wr(dmem_wr), 
   .addr(cpu_addr[wordsize-1:2]), .din(cpu_writedata), .dout(dmem_readdata));
   

endmodule

