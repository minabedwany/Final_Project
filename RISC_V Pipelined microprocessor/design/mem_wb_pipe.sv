`timescale 1ns / 1ps

import my_112l_pkg::*;

module mem_wb_pipe(input clk, input rst, input mem_wb_reg   d,  output mem_wb_reg  q);
    always @(posedge clk) begin
        if(rst)begin
			q <= '0;
        end 
		else q <= d;
    end
endmodule