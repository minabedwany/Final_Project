`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2017 08:53:33 PM
// Design Name: 
// Module Name: Controller
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


module Controller (
// Input
input [6:0] opcode , //7-bit opcode field from the instruction
// Outputs
output ALUSrc ,// 0: 2nd ALU operand comes from the second register file output ( Read data 2)
// 1: 2nd ALU operand is the sign - extended , lower 16 bits of the instruction
output MemtoReg , // 0: The value fed to the register Write data input comes from the ALU
// 1: The value fed to the register Write data input comes from the data memory
output RegWrite , // Regfile [ addr ] is written with the value on the Write data input
output MemRead , // Mem [ addr ] is put on the Read data output
output MemWrite , // Write data input is written into Mem[ addr ]
output [1:0] ALUOp // determine functionality of the ALU unit
);

logic temp1;
logic temp2;
logic temp3;
logic temp4;
logic temp5;
logic [1:0] temp6;

always_comb begin
    if (opcode == 7'b0110011) begin
        temp1 = 0;
        temp2 = 0;
        temp3 = 1;
        temp4 = 0;
        temp5 = 0;
        temp6 = 2'b10;
     end 
     else if (opcode == 7'b0000011) begin
        temp1 = 1;
        temp2 = 1;
        temp3 = 1;
        temp4 = 1;
        temp5 = 0;
        temp6 = 2'b00;
     end 
     else if (opcode == 7'b0100011) begin
        temp1 = 1;
        temp3 = 0;
        temp4 = 0;
        temp5 = 1;
        temp6 = 2'b00;
     end
     else if (opcode == 7'b0010011) begin
        temp1 = 1;
        temp3 = 1;
        temp2 = 0;
        temp4 = 0;
        temp5 = 0;
        temp6 = 2'b00;
     end
end

assign ALUSrc = temp1;
assign MemtoReg = temp2;
assign RegWrite = temp3;
assign MemRead = temp4;
assign MemWrite = temp5;
assign ALUOp = temp6;

endmodule
