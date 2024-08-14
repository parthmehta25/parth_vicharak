`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.08.2024 16:35:45
// Design Name: 
// Module Name: MemoryInterface
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


module MemoryInterface(
  input clk,
  input [18:0] address,
  input [18:0] write_data,
  input memory_write,
  output[18:0] read_data
  
  );
  reg[18:0] memory[0:524287]; //2^19 memory location available
  
  assign read_data=memory[address];
  
  always @(posedge clk)
    begin 
      if(memory_write)
        memory[address]<=write_data;
      end
           
      
endmodule
