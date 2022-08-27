//*****************************************************************************
// File Name            : RSA_Func_test.v
// Project             : RSA Project
// Designer             : yasuhiro 
// History              : 2022/8/20
//_____________________________________________________________________________
// Description;
//                      test mod(A^B,C)
//*****************************************************************************
`timescale 1ns/1ps

`define Bit     8   //8bit multiplier
`define delay   10

module RSA_test;

reg [`Bit*3-1:0] mem [0:9];
reg [`Bit-1:0] Expect;

reg clk, start;
reg [`Bit-1:0] A,B,C;
wire [`Bit-1:0] Yn;
wire busy;

integer i;

RSA RSA(clk, start, busy, A, B, C, Yn);

always #50  clk = ~clk;

initial begin
  $dumpfile("dump.vcd");
  $dumpvars;
  #10000 
  $finish;
end

function [`Bit-1:0] rsa;
    input [`Bit-1:0] A,B,C;
    integer j;
    reg [`Bit-1:0] Temp1, Temp2;
    reg [`Bit*2-1:0] Temp3;
begin
    Temp1 = A;
    Temp2 = 1;
    for (j=0; j<10; j=j+1) begin
        if(B[0]) begin
           Temp3 = Temp1 * Temp2;
           Temp2 = Temp3 % C; 
        end
        Temp3 = Temp1 * Temp1;
        Temp1 = Temp3 % C;
        B = {1'b0, B[`Bit-1:1]};
    end
    rsa = Temp2;
end  
endfunction

initial begin
  mem[0] = {`Bit'h0f,`Bit'b00000101,`Bit'h0f};
  mem[1] = {`Bit'h0e,`Bit'b00000101,`Bit'h0f};
  mem[2] = {`Bit'h0d,`Bit'b00000101,`Bit'h0f};
  mem[3] = {`Bit'h0c,`Bit'b00000101,`Bit'h0f};
  mem[4] = {`Bit'h0b,`Bit'b00000101,`Bit'haa};
  mem[5] = {`Bit'h0a,`Bit'b00000101,`Bit'haa};
  mem[6] = {`Bit'h99,`Bit'b00000101,`Bit'haa};
  mem[7] = {`Bit'h88,`Bit'b00000101,`Bit'haa};
  mem[8] = {`Bit'h77,`Bit'b00000101,`Bit'haa};
  mem[9] = {`Bit'h66,`Bit'b00000101,`Bit'haa};
    clk=1;

    for(i=0;i<10;i=i+1)begin
        start = 0;
        {A,B,C} = mem[i];
        Expect = rsa(A,B,C);
        @(posedge clk)  #`delay;
        start = 1;
        @(posedge clk)  #`delay;

    while (busy==1) @(posedge clk);

    if(Expect==Yn) begin
        $display("Match Yn=%h Expect=%h",Yn,Expect);
    end else begin
        $display("Error Yn=%h Expect=%h",Yn,Expect);
    end
        
    end
$finish;
end

endmodule