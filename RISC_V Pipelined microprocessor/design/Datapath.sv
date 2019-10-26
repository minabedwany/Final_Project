`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Datapath
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

import my_112l_pkg::*;

module Datapath #(
    parameter PC_W = 32, // Program Counter
    parameter INS_W = 32, // Instruction Width
    parameter RF_ADDRESS = 5, // Register File Address
    parameter DATA_W = 32, // Data WriteData
    parameter DM_ADDRESS = 9, // Data Memory Address
    parameter ALU_CC_W = 4 // ALU Control Code Width
    )(
    input logic clk , reset , // global clock
                              // reset , sets the PC to zero
    RegWrite , MemtoReg ,     // Register file writing enable   // Memory or ALU MUX
    ALUsrc , MemWrite ,       // Register file or Immediate MUX // Memroy Writing Enable
    MemRead ,  Branch,        // Memroy Reading Enable   //Branch Enable
    input logic [ ALU_CC_W -1:0] ALU_CC, // ALU Control Code ( input of the ALU )
    output logic [6:0] opcode,
    output logic [6:0] Funct7,
    output logic [2:0] Funct3,
    output logic [DATA_W-1:0] WB_Data //ALU_Result
    );

logic [PC_W-1:0] PC, PCPlus4, PCtarget, PCui, muxresult, PCresult, PCjump, PCjumpr, PCoutput, PCfinal;
logic [INS_W-1:0] Instr;
logic [DATA_W-1:0] Result;
logic [DATA_W-1:0] Reg1, Reg2, tempReg2;
logic [DATA_W-1:0] ReadData;
logic [DATA_W-1:0] tempData;
logic [DATA_W-1:0] SrcB, ALUResult, ALUtemp;
logic [DATA_W-1:0] ExtImm;
logic Zero;
logic [1:0] ForwardA, ForwardB;
logic [31:0] alumux1out, alumux2out;
logic flush, if_id_write, pc_write;
logic [9:0] control;
logic [9:0] control_out;


//initialize pipeline buffers
if_id_reg if_id;
id_ex_reg id_ex;
ex_mem_reg ex_mem;
mem_wb_reg mem_wb;

if_id_reg if_id_temp;
id_ex_reg id_ex_temp;
ex_mem_reg ex_mem_temp;
mem_wb_reg mem_wb_temp;
	
	
//assign pipeline buffers
always_comb begin
	if_id_temp.pc <= PC;
	if_id_temp.instr <= Instr;
	if_id_temp.regwrite <= RegWrite;
	if_id_temp.memtoreg <= MemtoReg;
	if_id_temp.alusrc <= ALUsrc;
	if_id_temp.memwrite <= MemWrite;
	if_id_temp.memread <= MemRead;
	if_id_temp.branch <= Branch;
	if_id_temp.alu_cc <= ALU_CC;
	
	id_ex_temp.pc <= if_id.pc;
	id_ex_temp.rd1 <= Reg1;
	id_ex_temp.rd2 <= Reg2;
	id_ex_temp.imm_gen <= ExtImm;
	id_ex_temp.opcode <= if_id.instr[6:0];
	id_ex_temp.funct7 <= if_id.instr[31:25];
	id_ex_temp.funct3 <= if_id.instr[14:12];
	id_ex_temp.wr <= if_id.instr[11:7];
	id_ex_temp.regwrite <= control_out[9];
	id_ex_temp.memtoreg <= control_out[8];
	id_ex_temp.alusrc <= control_out[7];
	id_ex_temp.memwrite <= control_out[6];
	id_ex_temp.memread <= control_out[5];
	id_ex_temp.branch <= control_out[4];
	id_ex_temp.alu_cc <= control_out[3:0];
	id_ex_temp.rs1 <= if_id.instr[19:15];
	id_ex_temp.rs2 <= if_id.instr[24:20];
	
	ex_mem_temp.zero <= Zero;
	ex_mem_temp.regwrite <= id_ex.regwrite;
	ex_mem_temp.memtoreg <= id_ex.memtoreg;
	ex_mem_temp.memwrite <= id_ex.memwrite;
	ex_mem_temp.memread <= id_ex.memread;
	ex_mem_temp.branch <= id_ex.branch;
	ex_mem_temp.pcadd4 <= PCPlus4;
	ex_mem_temp.pcaddbranch <= PCtarget;
	ex_mem_temp.pcaddui <= PCui;
	ex_mem_temp.pcaddjal <= PCjump;
	ex_mem_temp.pcaddjalr <= PCjumpr;
	ex_mem_temp.aluresult <= ALUResult;
	ex_mem_temp.rd2 <= alumux2out;
	ex_mem_temp.wr <= id_ex.wr;
	
	mem_wb_temp.memtoreg <= ex_mem.memtoreg;
	mem_wb_temp.regwrite <= ex_mem.regwrite;
	mem_wb_temp.rd <= ReadData;
	mem_wb_temp.aluresult <= ex_mem.aluresult;
	mem_wb_temp.wr <= ex_mem.wr;
	
end

// next PC
    adder pcadd4 (PC, 32'b100, PCPlus4);
	adder pcaddtarget (id_ex.pc, (id_ex.imm_gen<<1), PCtarget);
	adder pcaddui (id_ex.pc, SrcB, PCui);
	adder pcaddjal (id_ex.pc, SrcB, PCjump);
	adder pccaddjalr (id_ex.pc, ALUtemp, PCjumpr);
	mux2 pcselector(PCPlus4, ex_mem.pcaddbranch,(ex_mem.branch&&ex_mem.zero), muxresult);
	mux2 pcselector2(muxresult, ex_mem.pcaddjal, (opcode==7'b1101111), PCoutput);
	mux2 pcselector3(PCoutput, ex_mem.pcaddjalr, (opcode==7'b1100111), PCfinal);
    flopr pcreg(clk, reset, pc_write, PCfinal, PC); 
//
	if_id_pipe IF_ID_PIPE(clk, reset, if_id_write, if_id_temp, if_id);
	id_ex_pipe ID_EX_PIPE(clk, reset, id_ex_temp, id_ex);
	ex_mem_pipe EX_MEM_PIPE(clk, reset, ex_mem_temp, ex_mem);
	mem_wb_pipe MEM_WB_PIPE(clk, reset, mem_wb_temp, mem_wb);
	
	
//Forwarding unit
always_comb begin
	if(ex_mem.regwrite == 1 && ex_mem.wr != 0 && ex_mem.wr == id_ex.rs1) begin
		//$display("AA");
		ForwardA = 2'b10;
		//$display("%b\n", ForwardA);
		end
	else if(ex_mem.regwrite == 1 && ex_mem.wr != 0 && ex_mem.wr == id_ex.rs2)
		ForwardB = 2'b10;
	else if(mem_wb.regwrite == 1 && mem_wb.wr != 0 && mem_wb.wr == id_ex.rs1)
		ForwardA = 2'b01;
	else if(mem_wb.regwrite == 1 && mem_wb.wr != 0 && mem_wb.wr == id_ex.rs2)
		ForwardB = 2'b01;
	else begin
		ForwardA = 2'b00;
		ForwardB = 2'b00;
	end
	
end


//Hazard Detection unit
always_comb begin
	if(id_ex.memread && (id_ex.wr == if_id.instr[19:15] || id_ex.wr == if_id.instr[24:20])) begin
		flush = 1'b1;
		if_id_write = 0;
		pc_write = 0;
	end
	else begin
		flush = 0;
		if_id_write = 1'b1;
		pc_write = 1'b1;
	end
	
	control = {if_id.regwrite, if_id.memtoreg, if_id.alusrc, if_id.memwrite, if_id.memread, if_id.branch, if_id.alu_cc};
end
//
	mux2 #(10) stallmux(control, 10'b0, flush, control_out);

 //Instruction memory
    instructionmemory instr_mem (PC[8:0], Instr);
    
    assign opcode = Instr[6:0];
    assign Funct7 = Instr[31:25];
    assign Funct3 = Instr[14:12];
      
// //Register File
    RegFile rf(clk, reset, mem_wb.regwrite, mem_wb.wr, if_id.instr[19:15], if_id.instr[24:20],
            Result, Reg1, tempReg2);
            
    mux2 #(32) resmux(mem_wb.aluresult, mem_wb.rd, mem_wb.memtoreg, Result);
           
//// sign extend
    imm_Gen Ext_Imm (if_id.instr,ExtImm);

//// ALU
	mux3 #(32) alumux1(id_ex.rd1, Result, ex_mem.aluresult, ForwardA, alumux1out);
	mux3 #(32) alumux2(id_ex.rd2, Result, ex_mem.aluresult, ForwardB, alumux2out);
    mux2 #(32) srcbmux(alumux2out, id_ex.imm_gen, id_ex.alusrc, SrcB);
    alu alu_module(alumux1out, SrcB, id_ex.alu_cc, ALUtemp);
    
    assign WB_Data = Result;
    
////// Data memory 
	datamemory data_mem (clk, ex_mem.memread, ex_mem.memwrite, ex_mem.aluresult[DM_ADDRESS-1:0], ex_mem.rd2, tempData);
	
	always_comb
	begin
		if(opcode == 7'b0000011 && Funct3 == 3'b000)  							//LB
				ReadData = {tempData[7]? 24'hffffff:24'h0 , tempData[7:0]};
		else if(opcode == 7'b0000011 && Funct3 == 3'b001)  						// LH
				ReadData = {tempData[15]? 16'hffff:16'h0 , tempData[15:0]};
		else if(opcode == 7'b0000011 && Funct3 == 3'b100)  						// LBU
				ReadData = {24'b0, tempData[7:0]};
		else if(opcode == 7'b0000011 && Funct3 == 3'b101)  						// LHU
				ReadData = {16'b0, tempData[15:0]};
		else if(opcode == 7'b0100011 && Funct3 == 3'b000)  						// SB
				Reg2 = {tempReg2[7]? 24'b1:24'b0 , tempReg2[7:0]};
		else if(opcode == 7'b0100011 && Funct3 == 3'b001)  						// SH
				Reg2 = {tempReg2[15]? 16'b1:16'b0 , tempReg2[15:0]};
		else if(opcode == 7'b1100011 && Funct3 == 3'b000)						//Beq
				Zero = (ALUtemp == 0 ? 1'b1:1'b0);
		else if(opcode == 7'b1100011 && Funct3 == 3'b001)						//Bne
				Zero = (ALUtemp != 0 ? 1'b1:1'b0);
		else if(opcode == 7'b1100011 && Funct3 == 3'b100)						//Blt
				Zero = ($signed(ALUtemp) < 0 ? 1'b1:1'b0);
		else if(opcode == 7'b1100011 && Funct3 == 3'b101)						//Bge
				Zero = ($signed(ALUtemp) >= 0 ? 1'b1:1'b0);
		else if(opcode == 7'b1100011 && Funct3 == 3'b110)						//Bltu
				Zero = ($signed(ALUtemp) < 0 ? 1'b1:1'b0);
		else if(opcode == 7'b1100011 && Funct3 == 3'b111)						//Bgeu
				Zero = ($signed(ALUtemp) >= 0 ? 1'b1:1'b0);
		else if((opcode == 7'b0110011 || opcode==7'b0010011)&& (Funct3 == 3'b010))		//slt & slti
				ALUResult = ($signed(ALUtemp) < 0 ? 32'b1:32'b0);
		else if((opcode == 7'b0110011 || opcode==7'b0010011) && (Funct3 == 3'b011))		//sltu & sltiu
				ALUResult = ($unsigned(ALUtemp) < 0 ? 32'b1:32'b0);
		else if(opcode == 7'b0110111)				//LUI
				ALUResult = SrcB;
		else if(opcode == 7'b0010111)				//AUIPC
				ALUResult = PCui;
		else if(opcode == 7'b1101111)				//JAL
				ALUResult = PCPlus4;
		else if(opcode == 7'b1100111)				//JALR
				ALUResult = PCPlus4;
		else
			begin
				ReadData = tempData;
				Reg2 = tempReg2;
				Zero = 0;
				ALUResult = ALUtemp;
			end
		
	end
	
     
endmodule