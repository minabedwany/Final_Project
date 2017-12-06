`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2017 08:51:39 PM
// Design Name: 
// Module Name: datamemory
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


module datamemory #(
parameter DM_ADDRESS = 9,
parameter DATA_W = 64)
(
input logic clk , // Clock Signal
input logic MemRead , // comes from control unit
input logic MemWrite , // Comes from control unit
input logic [ DM_ADDRESS -1:0] a, // Read / Write address - 9 LSB bits of the ALU output
input logic [ DATA_W -1:0] wd , // Write Data
output logic [ DATA_W -1:0] rd // Read Data
);

logic [63:0] temp;

logic [ DATA_W -1:0] mem [(2** DM_ADDRESS ) -1:0];

always_ff @(posedge clk) begin
    if (MemWrite == 1'b1) begin
        mem[a] <= wd;
    end
    else if (MemRead == 1'b1) begin
        temp <= mem[a];
    end
end

assign rd = temp;

endmodule