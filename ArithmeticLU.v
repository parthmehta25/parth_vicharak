`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.08.2024 15:47:17
// Design Name: 
// Module Name: ArithmeticLU
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


module ArithmeticLU(
  input [18:0] r1,
  input [18:0] r2,
  input [4:0] Opcode,
  output reg [18:0] r3,
  output Zero,
  output Carry,
  output Overflow
);
 always @(*) 
   begin 
     case(Opcode)
        5'b00001: r3 = r1+r2;
        5'b00010: r3 = r1-r2;
        5'b00011: r3 = r1*r2;
        5'b00100: r3 = r1/r2;
        5'b00101: r3 = r1+1;
        5'b00110: r3 = r1-1;
        5'b00111: r3 = r1&r2;
        5'b01000: r3 = r1|r2;
        5'b01001: r3 = r1^r2;
        5'b01010: r3 = ~r1;
        // custom instruction for FFt, Encryption , Decryption
        5'b01011: r3 = fft(r1,r2);
        5'b01100: r3 = encrypt(r1,r2);
        5'b01101: r3 = decrypt(r1,r2);
        default: r3 = 19'b0;
     endcase
  end
  
  //Example implementation for FFt, Encryption , Decryption 
  function [18:0] fft(input[18:0] logic, input [18:0] address);
    begin
      fft = logic;// Dummy logic 
    end
  endfunction
  
  function[18:0] encrypt(input[18:0] logic , input[18:0] address);
    begin 
      encrypt = logic; // Dummy Logic
    end
  endfunction
  
  function[18:0]decrypt(input[18:0] logic , input[18:0] address);
    begin 
      decrypt = logic; // Dummy Logic
    end 
  endfunction
  
  //Flags logic
  assign Zero = (r3==19'b0);
  assign Carry = r3[18];
  assign Overflow = (r1[18] == r2[18]) && (r3[18]!=r1[18]);
  

                  

    
endmodule
