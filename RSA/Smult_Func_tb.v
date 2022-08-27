//*****************************************************************************
// File Name            : Smult_Func_tb.v
// Project             : RSA Project
// Designer             : yasuhiro 
// History              : 2022/8/20
//_____________________________________________________________________________
// Description;
//                      test M = A*B
//*****************************************************************************
`timescale 1ns/1ps

`define Bit     8   //8bit multiplier
`define delay   10

module Smulti_test;

reg [`Bit*2:0] mem [0:9];
reg [`Bit*2-1:0] Expect;

reg clk, start;
reg [`Bit-1:0] A,B;
wire busy;
wire [`Bit:0] Hreg;
wire [`Bit-1:0] Lreg;

integer i;

S_multi mult(clk, start, busy, A, B, Hreg, Lreg);

initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  #10000 
  $finish;
end

always #50  clk = ~clk;

initial begin
    mem[0] = {`Bit'h1,`Bit'h1};
    mem[1] = {`Bit'h1,`Bit'h0};
    mem[2] = {`Bit'h0,`Bit'h1};
    mem[3] = {`Bit'h11,`Bit'h2};  
    clk=1;  // initialize clk

    for(i=0;i<10;i=i+1)begin
        start = 0;
        {A,B} = mem[i];
        Expect = A * B;
        @(posedge clk)  #`delay;
        start = 1;
        @(posedge clk)  #`delay;
    while (busy==1) @(posedge clk);

    if(Expect=={Hreg[`Bit-1:0],Lreg}) begin
        $display("Match M=%h Expect=%h",{Hreg[`Bit-1:0],Lreg},Expect);
    end else begin
        $display("Error M=%h Expect=%h",{Hreg[`Bit-1:0],Lreg},Expect);
    end
        
    end
$finish;
end

endmodule