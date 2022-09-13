module singlecycle(
    input resetl,
    input [63:0] startpc,
    output reg [63:0] currentpc,
    output [63:0] dmemout,
    input CLK
);

    // Next PC connections
    wire [63:0] nextpc;       // The next PC, to be updated on clock cycle

    // Instruction Memory connections
    wire [31:0] instruction;  // The current instruction

    // Parts of instruction
    wire [4:0] rd;            // The destination register
    wire [4:0] rm;            // Operand 1
    wire [4:0] rn;            // Operand 2
    wire [10:0] opcode;

    // Control wires
    wire reg2loc;
    wire alusrc;
    wire mem2reg;
    wire regwrite;
    wire memread;
    wire memwrite;
    wire branch;
    wire uncond_branch;
    wire [3:0] aluctrl;
    wire [1:0] signop;

    // Register file connections
    wire [63:0] regoutA;     // Output A
    wire [63:0] regoutB;     // Output B

    // ALU connections
    wire [63:0] aluout;
    wire zero;
    
    //Data Memory Wires
    wire [63:0] dmemout;
    
    // Sign Extender connections
    wire [63:0] extimm;
    wire [25:0] Imm25;

    // PC update logic
    always @(negedge CLK)
    begin
        if (resetl)
            currentpc <= nextpc;
        else
            currentpc <= startpc;
    end

    // Parts of instruction
    assign rd = instruction[4:0];
    assign rm = instruction[9:5];
    assign rn = reg2loc ? instruction[4:0] : instruction[20:16];
    assign opcode = instruction[31:21];
    assign Imm25 = instruction[25:0];
    
    // MUX outputs
    wire [63:0] alu_mux;
    wire [63:0] write_mux;
    
    InstructionMemory imem(
        .Data(instruction),
        .Address(currentpc)
    );
    
    NextPCLogic NextPC(
        .NextPC(nextpc), 
        .CurrentPC(currentpc), 
        .SignExtImm64(extimm), 
        .Branch(branch), 
        .ALUZero(zero), 
        .Uncondbranch(uncond_branch)
    );

    control control(
        .reg2loc(reg2loc),
        .alusrc(alusrc),
        .mem2reg(mem2reg),
        .regwrite(regwrite),
        .memread(memread),
        .memwrite(memwrite),
        .branch(branch),
        .uncond_branch(uncond_branch),
        .aluop(aluctrl),
        .signop(signop),
        .opcode(opcode)
    );
    
    RegisterFile RegFile(
        .BusA(regoutA),
        .BusB(regoutB), 
        .BusW(write_mux),
        .RA(rm), 
        .RB(rn), 
        .RW(rd), 
        .RegWr(regwrite), 
        .Clk(CLK)
    );

    SignExtender SignExt(
        .BusImm(extimm), 
        .Imm25(Imm25), 
        .Ctrl(signop)
    );
    
    assign alu_mux = alusrc ? extimm : regoutB;

    ALU ALU(
        .BusW(aluout), 
        .Zero(zero),
        .BusA(regoutA), 
        .BusB(alu_mux),
        .ALUCtrl(aluctrl)
    );

    DataMemory datamem(
        .ReadData(dmemout),
        .Address(aluout), 
        .WriteData(regoutB), 
        .MemoryRead(memread),
        .MemoryWrite(memwrite), 
        .Clock(CLK)
    );

    assign write_mux = mem2reg ? dmemout : aluout;

endmodule

