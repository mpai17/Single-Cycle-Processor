module ALU(BusA, BusB, ALUCtrl, Zero, BusW);
	input [63:0] BusA, BusB;
	input [3:0] ALUCtrl;
	output Zero;
	output reg [63:0] BusW;
	
always@(*)
begin
	if(ALUCtrl == 0)
	begin
	BusW <= #20 BusA & BusB;
	end
	if(ALUCtrl == 1)
	begin
	BusW <= #20 BusA | BusB;
	end
	if(ALUCtrl == 2)
	begin
	BusW <= #20 BusA + BusB;
	end
	if(ALUCtrl == 6)
	begin
	BusW <= #20 BusA - BusB;
	end
	if(ALUCtrl == 7)
	begin
	BusW <= #20 BusB;
	end
	//$display("BusA:%h", BusA);
end

assign #1 Zero = BusW ? 0 : 1;

endmodule
