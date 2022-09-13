module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
  input [63:0] BusW;
  input [4:0] RA, RB, RW;
  input RegWr;
  input Clk;
  output [63:0] BusA, BusB;
  reg [63:0] R [31:0];
  
  assign #2 BusA = R[RA];
  assign #2 BusB = R[RB];
  
  initial begin
    R[31] = 64'b0;
  end
  
  always @ (negedge Clk) 
  begin
    if(RegWr)
      R[RW] <= #3 BusW;
    
    R[31] = #3 64'b0;
      //$display("Register [%d]:%h", RB, BusB);
      //$display("Written:%h", RegWr);
  end
  
endmodule
