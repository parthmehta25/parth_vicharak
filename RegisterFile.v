`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.08.2024 16:09:29
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
 input clk,
 input reset,
 input [2:0] r1,r2,r3,
 input [18:0] write_data,
 input register_write,
 output [18:0] read_data1,
 output [18:0] read_data2
 );
 reg [18:0] registers[0:7];    //we used 8 general purpose registers
 
 assign read_data1 = registers[r1];
 assign read_data2 = registers[r2];
 
 integer i;
 always @(posedge clk or posedge reset)
   begin 
     if(reset)
       for(i=0; i<8 ; i=i+1)
         registers[i] <= 19'b0;   //reset all register to 0
       else if(register_write)
         registers[r3] <= write_data;
     end
           

    
endmodule
