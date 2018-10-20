`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2017 08:50:42 PM
// Design Name: 
// Module Name: alu
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


module alu #(
parameter DATA_WIDTH = 64,
parameter OPCODE_LENGTH = 4
)(
input logic [ DATA_WIDTH -1:0] SrcA ,
input logic [ DATA_WIDTH -1:0] SrcB ,
input logic [ OPCODE_LENGTH -1:0] ALUCC ,
output logic [ DATA_WIDTH -1:0] ALUResult
);

assign ALUResult = (ALUCC == 4'b0000)? SrcA & SrcB:
                   (ALUCC == 4'b0001)? SrcA | SrcB:
                   (ALUCC == 4'b0010)? SrcA + SrcB:
                   (ALUCC == 4'b0110)? SrcA + ~SrcB + 1:
                                                   64'bz;

endmodule
