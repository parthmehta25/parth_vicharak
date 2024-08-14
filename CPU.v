`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.08.2024 17:19:00
// Design Name: 
// Module Name: CPU
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


module CPU(
  input clk,
  input reset,
  input [18:0] instruction,
  output reg [18:0] r3,
  output [14:0] Pc
    );
    reg [14:0] Pc_register;
    
    //pipeline register for 5 stage pipeline architecture
    reg [18:0] If_Id_instruction;
    reg [14:0] If_Id_Pc;
    
    reg [18:0] Id_Ex_register_out1, Id_Ex_register_out2;
    reg [18:0] Id_Ex_instruction;
    reg [4:0] Id_Ex_Opcode;
    
    reg [18:0] Ex_Memory_alu_out;
    reg [14:0] Ex_Memory_Pc;
    
    reg [4:0] Ex_Memory_Opcode;
    
 wire [18:0] Memory_Wb_r3;

    reg [4:0] Memory_Wb_Opcode;
    
    wire [18:0] register_out1, register_out2, ArithmeticLU_out;
    wire register_write, memory_write, alu_source, memory_to_register, Pc_source, branch, jump, call, ret;
    
    //fetch stage
    always @(posedge clk or posedge reset)
      begin
        if(reset)
          Pc_register <= 15'b0;
        else
          Pc_register <= Pc_register + 1; //incrementing program counter for next instruction
      end
      
    assign Pc = Pc_register;
      
    always @(posedge clk) 
      begin
        If_Id_instruction <= instruction;   //fetching instruction
        If_Id_Pc <= Pc_register;            //Passing the current program counter
      end
        
    //Decoding stage
    RegisterFile register_file(
       .clk(clk),
       .reset(reset),   
       .r1(If_Id_instruction[14:12]),
       .r2(If_Id_instruction[11:9]),
       .r3(If_Id_instruction[8:6]),
       .write_data(Memory_Wb_r3),
       .register_write(register_write),
       .read_data1(register_out1),
       .read_data2(register_out2)
       );
       
    ControlUnit control(
       .Opcode(If_Id_instruction[18:14]),
       .register_write(register_write),
       .memory_write(memory_write),
       .alu_source(alu_source),
       .memory_to_register(memory_to_register),
       .Pc_source(Pc_source),
       .branch(branch),
       .jump(jump),
       .call(call),
       .ret(ret)
       );
       
    always @(posedge clk)
      begin 
        Id_Ex_register_out1 <= register_out1;
        Id_Ex_register_out2 <= register_out2;
        Id_Ex_instruction <= If_Id_instruction;
        Id_Ex_Opcode <= If_Id_instruction[18:14];
      end
         
    //Execution stage
    ArithmeticLU alu(
      .r1(Id_Ex_register_out1),
      .r2(Id_Ex_register_out2),
      .Opcode(Id_Ex_Opcode),
      .r3(ArithmeticLU_out)
      );
         
    always @(posedge clk)
      begin
        Ex_Memory_alu_out <= ArithmeticLU_out;
        Ex_Memory_Pc <= Id_Ex_instruction[14:0];
        Ex_Memory_Opcode <= Id_Ex_Opcode;
      end
        
    //Memory stage 
    MemoryInterface interface(
      .clk(clk),
      .address(Ex_Memory_alu_out),
      .write_data(Id_Ex_register_out2),
      .memory_write(memory_write),
      .read_data(Memory_Wb_r3)
      );
      
    always @(posedge clk)
      begin 
        Memory_Wb_Opcode <= Ex_Memory_Opcode;
      end
        
    //writeback stage 
    always @(posedge clk)
      begin
        if (memory_to_register)
          r3 <= Memory_Wb_r3;
        else
          r3 <= Ex_Memory_alu_out;   
      end
      
    //Program counter logic
    always @(posedge clk or posedge reset)
      begin 
        if(reset)
          Pc_register <= 15'b0;
        else if(ret)
          Pc_register <= Ex_Memory_Pc - 1;  //return to subroutine
        else if(call)
          Pc_register <= ArithmeticLU_out[14:0];  //calling Subroutine
        else if(branch)
          if(register_out1 == register_out2)   //branch condition if equal
            Pc_register <= ArithmeticLU_out[14:0];  
        else if(jump)
          Pc_register <= ArithmeticLU_out[14:0];   //jumping to address
        else
          Pc_register <= Pc_register + 1;  //Next instruction pointing
      end 
     
endmodule
