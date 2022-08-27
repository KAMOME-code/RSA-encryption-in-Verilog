//*****************************************************************************
// File Name            : RSA.v
// Project              : RSA Project
// Designer             : atsuhiko yasuhiro 
// History              : 2022/8/26
//_____________________________________________________________________________
// Description;
//                      mod(A^B,C)
//*****************************************************************************
`include "design2.sv"
`include "design3.sv"

`timescale 1ns/1ps

`define Init                0   //state
`define XnORXnYn            1   //state
`define Xn_selectXn         2   //state
`define Xn_startMul         3   //state
`define Xn_waitMul          4   //state
`define Xn_waitFlagMul      5   //state
`define Xn_startMod         6   //state
`define Xn_waitMod          7   //state
`define Xn_waitFlagMod      8   //state
`define Xn_saveXn           9   //state
`define XnYn_selectXn       10   //state
`define XnYn_startMul1      11   //state
`define XnYn_waitMul        12  //state
`define XnYn_waitFlagMul    13  //state
`define XnYn_startMod1      14  //state
`define XnYn_startMul2      15  //state
`define XnYn_waitMulMod     16  //state
`define XnYn_waitFlagMulMod 17  //state
`define XnYn_saveXn         18  //state
`define XnYn_startMod2      19  //state
`define XnYn_waitMod        20  //state
`define XnYn_waitFlagMod    21  //state
`define XnYn_saveYn         22  //state
`define FinalORnot          23  //state
`define Shift               24  //state
`define Final               25  //state
`define Bit                 8   //8bit multiplier
`define Bit1                7   //8bit multiplier

module RSA(clk, start, busy, A, B, C, Yn);

input clk, start;
input [`Bit-1:0] A,B,C;
output [`Bit-1:0] Yn;
output busy;

reg busy;
reg [`Bit-1:0] Xn, Yn ,Breg,Creg;
reg [4:0]state;
reg mux, mul_start,  mod_start;
wire mul_busy,mod_busy;
wire [`Bit-1:0] mod_out, Lreg, mux_out;
wire [`Bit:0] Hreg;

S_multi     Mul(.clk(clk),.start(mul_start),.busy(mul_busy),.A(mux_out),.B(Xn),.Hreg(Hreg),.Lreg(Lreg));
Modulo      Mod(.clk(clk),.start(mod_start),.busy(mod_busy),.C(Creg),.Hreg(Hreg),.Lreg(Lreg),.M(mod_out));

assign      mux_out = mux? Xn:Yn;

always @(posedge clk or negedge start) begin
if(!start) begin    //Ready
    busy <= 0;
    mul_start <= 0;
    mod_start <= 0;
    state <= 5'd`Init;
end else begin
    if (state==`Init) begin    //initialization
        busy <= 1;
        Xn <= A;
        Yn <= `Bit1'h01;
        Breg <= B;
        Creg <= C;
        state <= `XnORXnYn;
    end else if (state==`XnORXnYn) begin
        state <= ((Breg[0]==0)? `Xn_selectXn : `XnYn_selectXn);
    end else if (state==`Xn_selectXn) begin
        mux <= 1;
        state <= `Xn_startMul;
    end else if (state==`Xn_startMul) begin
        mul_start <= 1;
        state <= `Xn_waitFlagMul;
    end else if (state==`Xn_waitFlagMul) begin
        state <= `Xn_waitMul;
    end else if (state==`Xn_waitMul) begin
        state <= ((mul_busy==1)? `Xn_waitMul:`Xn_startMod);
    end else if (state==`Xn_startMod) begin
        mul_start <= 0;
        mod_start <= 1;
        state <= `Xn_waitFlagMod;
    end else if (state==`Xn_waitFlagMod) begin
        state <= `Xn_waitMod;
    end else if (state==`Xn_waitMod) begin
        state <= ((mod_busy==1)? `Xn_waitMod:`Xn_saveXn);
    end else if (state==`Xn_saveXn) begin
        mod_start <= 0;
        Xn <= mod_out;
        state <= `Shift;
    end else if (state==`XnYn_selectXn) begin
        mux <= 1;
        state <= `XnYn_startMul1;
    end else if (state==`XnYn_startMul1) begin
        mul_start <= 1;
        state <= `XnYn_waitFlagMul;
    end else if (state==`XnYn_waitFlagMul) begin
        state <= `XnYn_waitMul;       
    end else if (state==`XnYn_waitMul) begin
        state <= ((mul_busy==1)? `XnYn_waitMul: `XnYn_startMod1);
    end else if (state==`XnYn_startMod1) begin
        mul_start <= 0;
        mod_start <= 1;
        mux <= 0;
        state <= `XnYn_startMul2;
    end else if (state==`XnYn_startMul2) begin
        mul_start <= 1;
        state <= `XnYn_waitFlagMulMod;
    end else if (state==`XnYn_waitFlagMulMod) begin
        state <= `XnYn_waitMulMod;
    end else if (state==`XnYn_waitMulMod) begin
        state <= (((mul_busy==1)||(mod_busy==1))? `XnYn_waitMulMod: `XnYn_saveXn);
    end else if (state==`XnYn_saveXn) begin
        mul_start <= 0;
        mod_start <= 0;
        Xn <= mod_out;
        state <= `XnYn_startMod2;
    end else if (state==`XnYn_startMod2) begin
        mod_start <= 1;
        state <= `XnYn_waitFlagMod;
    end else if (state==`XnYn_waitFlagMod) begin
        state <= `XnYn_waitMod;
    end else if (state==`XnYn_waitMod) begin
        state <= ((mod_busy==1)? `XnYn_waitMod: `XnYn_saveYn);       
    end else if (state==`XnYn_saveYn) begin   
        mod_start <= 0;
        Yn <= mod_out;
        state <= `Shift;        
    end else if (state==`Shift) begin
      Breg <= {1'b0, Breg[`Bit-1:1]};
        state <= `FinalORnot;
    end else if (state==`FinalORnot) begin     
      state <= ((Breg==0)? `Final:`XnORXnYn);
    end else if (state==`Final) begin
        busy <= 0;
    end else begin
        busy <= 0;      //illegal state
    end
end
end

endmodule
