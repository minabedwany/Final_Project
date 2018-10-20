`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2017 08:54:12 PM
// Design Name: 
// Module Name: ALUController
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


module ALUController (
// Inputs
input [1:0] ALUop , //7- bit opcode field from the instruction
input [6:0] Funct7 , // bits 25 to 31 of the instruction
input [2:0] Funct3 , // bits 12 to 14 of the instruction
// Output
output [3:0] Operation // operation selection for ALU
);

logic [3:0] temp;

always_comb begin
    if (ALUop == 2'b00) begin
        temp <= 4'b0010;
    end
    else if (ALUop[0] == 1) begin
        temp <= 4'b0110;
    end
    else if (ALUop[1] == 1 && Funct7 == 7'b0000000 && Funct3 == 3'b000) begin
        temp <= 4'b0010;
    end
    else if (ALUop[1] == 1 && Funct7 == 7'b0100000 && Funct3 == 3'b000) begin
        temp <= 4'b0110;
    end
    else if (ALUop[1] == 1 && Funct7 == 7'b0000000 && Funct3 == 3'b111) begin
        temp <= 4'b0000;
    end
    else if (ALUop[1] == 1 && Funct7 == 7'b0000000 && Funct3 == 3'b110) begin
        temp <= 4'b0001;
    end
    
end
assign Operation = temp;
endmodule
