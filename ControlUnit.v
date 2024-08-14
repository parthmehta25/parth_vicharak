`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.08.2024 16:18:53
// Design Name: 
// Module Name: ControlUnit
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


module ControlUnit(
  input [4:0] Opcode,
  output reg register_write,
  output reg memory_write,
  output reg alu_source,
  output reg memory_to_register,
  output reg Pc_source,
  output reg branch,
  output reg jump,
  output reg call,
  output reg ret
 );
 always @(*)
   begin 
     {register_write, memory_write , alu_source , memory_to_register, Pc_source , branch , jump , call , ret} = 9'b000000000;
     
     case(Opcode)
       5'b00001,5'b00010,5'b00011,5'b00100,5'b00101,5'b00110,5'b00111,5'b01000,5'b01001,5'b01010:
         register_write = 1;
         5'b10000:
           begin 
            register_write=1;
            alu_source = 1;
            memory_to_register = 1;
          end
        5'b10001:
          begin 
           memory_write=1;
           alu_source=1;
          end
        5'b01011:branch = 1;  //branch if equal
        5'b01100: branch= 1; //branch if bot equal
        5'b01101: jump=1;    //jumping operation
        5'b01110: call=1; //call
        5'b01111: ret=1; //return
        5'b10010,5'b10011,5'b10100: register_write=1;   //fft,encryption,decryption
        default:  ;
     endcase
   end
         
endmodule
