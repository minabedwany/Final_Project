`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2017 08:52:38 PM
// Design Name: 
// Module Name: datapath
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


module datapath #(
parameter PC_W = 9, // Program Counter
parameter INS_W = 32, // Instruction Width
parameter RF_ADDRESS = 5, // Register File Address
parameter DATA_W = 64, // Data WriteData
parameter DM_ADDRESS = 9, // Data Memory Address
parameter ALU_CC_W = 4 // ALU Control Code Width
)(
input logic clk , reset , // global clock
// reset , sets the PC to zero
RegWrite , MemtoReg , //R- file writing enable // Memory or ALU MUX
ALUsrc , MemWrite , //R- file or Immediate MUX // Memroy Writing Enable
MemRead , // Memroy Reading Enable
input logic [ ALU_CC_W -1:0] ALU_CC, // ALU Control Code ( input of the ALU )
output logic [DATA_W -1:0] ALU_Result,
output logic [INS_W-1:0] instruction_memory
);

logic [8:0] PC_in;
logic [8:0] PC_out;
logic [8:0] temp;

logic [31:0] inst_out;

logic [63:0] final_out;
logic [63:0] Read_data1;
logic [63:0] Read_data2;

logic [63:0] Imm_out;

logic [63:0] mux1_out;

logic [63:0] ALU_out;

logic [63:0] Read_data;

always @(posedge clk, posedge reset) begin
    if (reset) 
        temp = 0;
    else
        temp = PC_in;
end

assign PC_in = PC_out + 4;
assign PC_out = temp;


instructionmemory inst(PC_out, inst_out);

mux2 mux(ALU_out, Read_data, MemtoReg, final_out);

regfile register(clk, reset, RegWrite, inst_out[19:15], inst_out[24:20], inst_out[11:7], final_out, Read_data1, Read_data2);

imm_Gen imm(inst_out, Imm_out);

mux2 mux1(Read_data2,Imm_out,ALUsrc,mux1_out);

alu alu1(Read_data1,mux1_out,ALU_CC,ALU_out);

datamemory data(MemRead, MemWrite, ALU_out, Read_data2, Read_data);



assign ALU_Result = ALU_out;
assign instruction_memory = inst_out;
endmodule
