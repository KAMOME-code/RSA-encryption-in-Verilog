//*****************************************************************************
// File Name            : Modulo.v
// Project              : RSA Project
// Designer             : atsuhiko yasuhiro 
// History              : 2022/8/26
//_____________________________________________________________________________
// Description;
//                      M = {Hreg, Lreg} mod C
//*****************************************************************************
`timescale 1ns/1ps

`define Init    0   //state
`define Sub     1   //state
`define Shift   2   //state
`define Bit     8   //#Bit modulo
`define Bit1    9   //Bit+1
`define Bit2    16  //Bit*2
`define BitN    3   //#Bit is BitN bit
`define BitN1   4   //BitN+1

module Modulo(clk, start, busy, C, Hreg, Lreg, M);

input clk, start;
input [`Bit-1:0] C;
input [`Bit:0] Hreg;
input [`Bit-1:0] Lreg;
output busy;
output [`Bit-1:0] M;

reg busy;
reg [`Bit:0] Hreg2;
reg [`Bit-1:0] Lreg2;
reg [1:0] state;
reg [`BitN:0] count;
wire [`Bit-1:0] M;
wire [`Bit:0] diff;

assign M = Hreg2[`Bit-1:0];  
assign diff = Hreg2 - C;

always @(posedge clk or negedge start) begin
if(!start) begin    //Ready
    busy <= 0;
    count <= `BitN1'd`Bit1;
    state <= 2'd`Init;
end else begin
    if(count != 0) begin
        if(state == `Init) begin    //Initialization state
            Hreg2 <= Hreg;
            Lreg2 <= Lreg;
            busy <= 1;
            state <= `Sub;
        end else if(state == `Sub) begin    //Substract state
            Hreg2 <= (diff[`Bit]? Hreg2 : diff[`Bit-1:0]);                      
          	count <= count - 1;
            state <= `Shift;
        end else if(state == `Shift) begin  //Shift state
            {Hreg2, Lreg2} <= {Hreg2[`Bit-1:0], Lreg2[`Bit-1:0], 1'b0};
            state <= `Sub;
        end else begin
            busy <= 0;  //illigal state
        end
    end else begin
    busy <= 0;  //Finish
    end
end
end

endmodule
