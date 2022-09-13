module SignExtender(BusImm, Imm25, Ctrl);
  output reg [63:0] BusImm; 
  input [25:0] Imm25; 
  input [1:0] Ctrl;

always@(*)
begin  
//$display("BusImm:%h", Imm25);
if(Ctrl == 2'b01) // D Instruction
	begin 
	BusImm = {{55{Imm25[20]}}, Imm25[20:12]}; 
	end
else if(Ctrl == 2'b00) // I Instruction
	begin 
	BusImm = {{52{Imm25[21]}}, Imm25[21:10]}; 
	end
else if(Ctrl == 2'b11) // CB Instruction
	begin 
	BusImm = {{45{Imm25[23]}}, Imm25[23:5]}; 
	end
else if(Ctrl == 2'b10) // B Instruction
	begin 
	BusImm = {{38{Imm25[25]}}, Imm25}; 
	end
end
endmodule
