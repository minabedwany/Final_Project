`timescale 1ns / 1ps

import my_112l_pkg::*;

module ex_mem_pipe(input clk, input rst, input ex_mem_reg   d,  output ex_mem_reg  q);
    always @(posedge clk) begin
        if(rst)begin
			q <= '0;
        end 
		else q <= d;
    end
endmodule