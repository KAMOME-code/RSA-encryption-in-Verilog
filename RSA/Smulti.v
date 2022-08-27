//*****************************************************************************
// File Name            : Smulti.v
// Project              : RSA Project
// Designer             : atsuhiko yasuhiro 
// History              : 2022/8/26
//_____________________________________________________________________________
// Description;
//                      {Hreg, Lreg} <= A * B
//*****************************************************************************
`timescale 1ns/1ps

`define Init    0   //state
`define Add     1   //state
`define Shift   2   //state
`define Bit     8   //#Bit multiplier
`define Bit2    16  //Bit*2
`define BitN    3   //#Bit is BitN bit
`define BitN1   4   //BitN+1

module S_multi(clk, start, busy, A, B, Hreg, Lreg);

input clk, start;
input [`Bit-1:0] A,B;
output busy;
output [`Bit:0] Hreg;
output [`Bit-1:0] Lreg;

reg busy;
reg [`Bit:0] Hreg;
reg [`Bit-1:0] Lreg;
reg [1:0] state;
reg [`BitN:0] count;
wire [`Bit:0] sum;

assign sum = Hreg + A;

always @(posedge clk or negedge start) begin
if(!start) begin    //Ready
    busy <= 0;
    count <= `BitN1'd`Bit;
    state <= 2'd`Init;
end else begin
    if(count != 0) begin
        if(state == `Init) begin    //Initialization
            Hreg <= 0;
            Lreg <= B;
            busy <= 1;
            state <= `Add;
        end else if(state == `Add) begin  //Check Lreg's LSB
            Hreg <= (Lreg[0] ? sum : Hreg);
            state <= `Shift;
        end else if(state == `Shift) begin   //Shifter
            {Hreg, Lreg} <= {1'b0, Hreg, Lreg[`Bit-1:1]};
            count <= count - 1;
            state <= `Add;
        end else begin
            busy <= 0;  //illigal state
        end
    end else begin
    busy <= 0;  //Finish
    end
end
end

endmodule
