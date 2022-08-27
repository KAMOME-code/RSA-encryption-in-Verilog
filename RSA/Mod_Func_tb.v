//*****************************************************************************
// File Name            : Mod_Func_test.v
// Project             : RSA Project
// Designer             : yasuhiro 
// History              : 2022/8/20
//_____________________________________________________________________________
// Description;
//                      test mod(M,C)
//*****************************************************************************
`timescale 1ns/1ps

`define Bit     8   //8bit multiplier
`define delay   10

module Moulo_test;

reg [`Bit*3-1:0] mem [0:9];
reg [`Bit-1:0] Expect;

reg clk, start;
reg [`Bit:0] Hreg;
reg [`Bit-1:0] Lreg;
reg [`Bit-1:0] C;
wire busy;
wire [`Bit-1:0] M;

integer i;

Modulo mod(clk, start, busy, C, Hreg, Lreg, M);

always #50  clk = ~clk;

initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  #10000 
  $finish;
end

initial begin
  mem[0] = {16'h1,`Bit'h1};
  mem[1] = {16'h1111,`Bit'haa};
  mem[2] = {16'haaaa,`Bit'hff};
  mem[3] = {16'hffff,`Bit'hff}; 
    clk=1;  //activate clk
    for(i=0;i<10;i=i+1)begin
        start = 0;
        {{Hreg, Lreg},C} = mem[i];
        Expect = {Hreg, Lreg} % C;
        @(posedge clk)  #`delay;
        start = 1;
        @(posedge clk)  #`delay;

    while (busy==1) @(posedge clk);

    if(Expect==M) begin
        $display("Match M=%h Expect=%h",M,Expect);
    end else begin
        $display("Error M=%h Expect=%h",M,Expect);
    end
        
    end
$finish;
end

endmodule