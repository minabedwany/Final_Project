package  my_112l_pkg;
 
	typedef struct packed{
		logic [31:0]  pc;
        logic [31:0] instr;
		logic regwrite, memtoreg, alusrc, memwrite, memread, branch;
		logic [3:0] alu_cc;
    } if_id_reg;
	
	typedef struct packed{
		logic regwrite, memtoreg, alusrc, memwrite, memread, branch;
		logic [1:0] aluop;
		logic [31:0] pc, rd1, rd2, imm_gen;
        logic [6:0] opcode, funct7;
		logic [2:0] funct3;
		logic [4:0] rs1, rs2, wr;
		logic [3:0] alu_cc;
    } id_ex_reg;
	
	typedef struct packed{
		logic zero, regwrite, memtoreg, memwrite, memread, branch;
		logic [31:0] pcadd4, pcaddbranch, pcaddui, pcaddjal, pcaddjalr, aluresult, rd2;
		logic [4:0] wr;
    } ex_mem_reg;
	
	typedef struct packed{
		logic memtoreg, regwrite;
		logic [31:0] rd;
		logic [31:0] aluresult;
		logic [4:0] wr;
    } mem_wb_reg;
 
endpackage
