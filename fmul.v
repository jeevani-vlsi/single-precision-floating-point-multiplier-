`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2024 15:50:56
// Design Name: 
// Module Name: fmul
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fmul(
input [31:0]a,
input [31:0]b,
output reg NAN,zero,underflow,overflow,
output reg [31:0]z
 );
 reg sign;
 reg [7:0]exp;
 reg [7:0] exponent;
 reg [23:0]mantissa_a;
 reg [23:0]mantissa_b;
 reg [47:0] mantissa;
 reg [22:0] final;
 integer i=0;
 // checking exceptional cases
 always @(*) begin
 NAN=0;
 overflow=0;
 underflow=0;
 zero=0;
 if((a[30:23]==8'b1 && a[22:0]==23'b0)||(b[30:23]==8'b1&& b[22:0]==23'b0)) begin
 overflow =1;
 z[45:0] ={sign,8'hff,23'b0};
 end
 else if(a[30:23]==8'b1 || b[30:23]==8'b1) begin
 NAN = 1;
  z[45:0] =32'hFFC00000;// standard representation of NAN
 end
 else if((a[30:23]==8'b0 && a[22:0]==23'b0)||(b[30:23]==8'b0&& b[22:0]==23'b0))
 begin
 zero =1;
  z[45:0] ={sign,31'b0};
 end
 else if(a[30:23]==8'b1 || b[30:23]==8'b1) begin
 underflow =1;
  z[45:0] =32'b0;
  end
  else begin
 // sign calculation 
  sign = a[31]^b[31];
 // exponent calculation
  exp = a[30:23]+b[30:23]-127;
 // mantissa calculation
  mantissa_a={1'b1,a[22:0]};
  mantissa_b={1'b1,b[22:0]};
mantissa = mantissa_a*mantissa_b;
 if(mantissa[47]==1) begin
 final= mantissa[46:24];
 exp=exp+1;
 end
 else begin
 for(i=0;i<47&& mantissa[46-i]==0;i=i+1) begin
 mantissa = mantissa << i;
 end
 final= mantissa[46:24];
 exp =exp-i;
 end
 z={sign,exp,final};
 end
 end
endmodule
//////////////////////////////////////////////////////////////////////////////
