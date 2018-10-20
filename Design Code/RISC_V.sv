`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2017 08:54:57 PM
// Design Name: 
// Module Name: RISC_V
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


module RISC_V #(
parameter DATA_W = 64)
( input logic clk , reset , // clock and reset signals
output logic [DATA_W -1:0] ALU_Result // The ALU_Result
);

logic RegWrite1, MemtoReg1, ALUsrc1, MemWrite1, MemRead1;
logic [3:0] ALU_CC1;
logic [DATA_W-1:0] ALU_out1;
logic [1:0]ALU_op1;
logic [31:0] instruction_memory1;


//always @(posedge clk) begin

Controller control(instruction_memory1[6:0], ALUsrc1, MemtoReg1, RegWrite1, MemRead1, MemWrite1, ALU_op1);
ALUController ALU(ALU_op1, instruction_memory1[31:25], instruction_memory1[14:12], ALU_CC1);
datapath data(clk, reset, RegWrite1, MemtoReg1, ALUsrc1, MemWrite1, MemRead1, ALU_CC1, ALU_out1, instruction_memory1);
//end
assign ALU_Result = ALU_out1;

endmodule
