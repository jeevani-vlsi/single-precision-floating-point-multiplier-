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
vedic_24 (
                .s(mantissa),
                .a(mantissa_a),
                .b(mantissa_b)
                );
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
// vedic module
module vedic_24(
output [47:0]s,
input [23:0]a,b
);
wire [23:0]v1;
    wire [23:0]v2;
    wire [23:0]v3;
    wire [23:0]v4;
    wire [23:0]r1;
    wire [23:0]r2;
    wire cr1,cr2,cr3;
    vedic_12 vm5(v1[23:0],a[11:0],b[11:0]);
    vedic_12 vm6(v2[23:0],a[23:12],b[11:0]);
    vedic_12 vm7(v3[23:0],a[11:0],b[23:12]);
    vedic_12 vm8(v4[23:0],a[23:12],b[23:12]);
    rca_24 rc1(v2[23:0],v3[23:0],r1[23:0],cr1);
    rca_24 rc2(r1[23:0],{12'b0,v1[23:12]},r2[23:0],cr2);
    rca_24 rc3(v4[23:0],{cr1,11'b0,r2[23:12]},s[47:24],cr3);
    assign s[11:0]=v1[11:0];
    assign s[23:12]=r2[23:12];
    endmodule
module vedic_12(
output [23:0]s,
input [11:0]a,b
    );
    wire [11:0]v1;
    wire [11:0]v2;
    wire [11:0]v3;
    wire [11:0]v4;
    wire [11:0]r1;
    wire [11:0]r2;
    wire cr1,cr2,cr3;
    vedic_6 vm1(v1[11:0],a[5:0],b[5:0]);
    vedic_6 vm2(v2[11:0],a[11:6],b[5:0]);
    vedic_6 vm3(v3[11:0],a[5:0],b[11:6]);
    vedic_6 vm4(v4[11:0],a[11:6],b[11:6]);
    rca_12 inst4(v2[11:0],v3[11:0],r1[11:0],cr1);
    rca_12 inst5(r1[11:0],{6'b000000,v1[11:6]},r2[11:0],cr2);
    rca_12 inst6(v4[11:0],{5'b00000,cr1,r2[11:6]},s[23:12],cr3);
    assign s[5:0]=v1[5:0];
    assign s[11:6]=r2[5:0];
endmodule
module vedic_6(
output [11:0]s,
input [5:0]a,b
 );
   wire [5:0]v1;
   wire [5:0]v2 ;
   wire [5:0]v3;
   wire [5:0]v4;
   wire [5:0]r1;
   wire [5:0]r2;
   wire cr1,cr2,cr3;
   vedic3 vedic_0(v1[5:0],a[2:0],b[2:0]);
   vedic3 vedic_1(v2[5:0],a[2:0],b[5:3]);
   vedic3 vedic_2(v3[5:0],a[5:3],b[2:0]);
   vedic3 vedic_3(v4[5:0],a[5:3],b[5:3]);
   rca_6 ripple0(v2[5:0],v3[5:0],r1[5:0],cr1);
   rca_6 ripple1(r1[5:0],{3'b000,v1[5:3]},r2[5:0],cr2);
   rca_6 ripple2(v4[7:0],{cr2,2'b00,r2[5:3]},s[11:6],cr3);
   assign s[2:0]=v1[2:0];
   assign s[5:3]=r2[2:0];
   
endmodule
module vedic3(
    output [5:0] s,
     input [2:0] a, b
);
    wire [3:0] v1;
    wire [3:0] v2;
    wire [3:0] v3;
    wire [3:0] v4;
    wire [2:0] r1;
    wire [2:0] r2;
    wire cr1, cr2,cr3;

    vedic vedic0(v1[3:0],a[1:0],b[1:0]);
    vedic vedic1(v2[3:0],a[1:0],{0,b[2]});
    vedic vedic2(v3[3:0],{0,a[2]},b[1:0]);
    vedic vedic3(v4[3:0],{0,a[2]},{0,b[2]});
rca_3b inst1(v2[2:0],v3[2:0],0,r1[2:0],cr1);
rca_3b inst2(r1[2:0],{0,v1[3:2]},0,r2[2:0],cr2);
rca_3b inst3(v4[2:0],{cr1,r2[2:1]},0,s[5:3],cr3); 

    assign s[0]=v1[0];
    assign s[1]=v1[1];
    assign s[2]=r2[0];
endmodule
module vedic(
    output [3:0]s,
    input [1:0]a,b
);
    wire w1, w2, w3, c1;
    and (s[0], a[0], b[0]);
    and (w1, a[1], b[0]);
    and (w2, a[0], b[1]);
    and (w3, a[1], b[1]);
    ha ha1(s[1], c1, w1, w2);
    ha ha2(s[2], s[3], w3, c1);
endmodule

module ha(
    output sum, carry,
    input a, b
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule
module rca_3b(
    input [2:0]a,b,
    input cin,
    output [2:0]sum,
    output c4);

wire c1,c2;      //Carry out of each full adder

full_adder fa0(a[0],b[0],cin,sum[0],c1);
full_adder fa1(a[1],b[1],c1,sum[1],c2);
full_adder fa2(a[2],b[2],c2,sum[2],c4);
                
endmodule
module rca_6(
input [5:0]a,b,
output [5:0]sum,
output cout
  );
  wire c1;
  rca_3b rc1(a[2:0],b[2:0],0,sum[2:0],c1);
  rca_3b rc2(a[5:3],b[5:3],c1,sum[5:3],cout);
endmodule
module rca_12(
input [11:0]a,b,
output [11:0]sum,
output cout
  );
  wire c1,c2,c3;
  rca_3b r1(a[2:0],b[2:0],0,sum[2:0],c1);
   rca_3b r2(a[5:3],b[5:3],c1,sum[5:3],c2);
    rca_3b r3(a[8:6],b[8:6],c2,sum[8:6],c3);
     rca_3b r4(a[11:9],b[11:9],c3,sum[11:9],cout);
  
endmodule
module rca_24(
    input [23:0] a, b,
    output [23:0] sum,
    output cout
);
    wire c1,c2,c3,c4,c5,c6,c7;
    rca_3b rc6(a[2:0],b[2:0],0,sum[2:0],c1);
    rca_3b rc7(a[5:3],b[5:3],c1,sum[5:3],c2);
    rca_3b rc8(a[8:6],b[8:6],c2,sum[8:6],c3);
    rca_3b rc9(a[11:9],b[11:9],c3,sum[11:9],c4);
    rca_3b rc10(a[14:12],b[14:12],c4,sum[14:12],c5);
    rca_3b rc11(a[17:15],b[17:15],c5,sum[17:15],c6);
    rca_3b rc12(a[20:18],b[20:18],c6,sum[20:18],c7);
    rca_3b rc13(a[23:21],b[23:21],c7,sum[23:21],cout);
endmodule
module full_adder(
    input a,b,cin,
    output sum,carry);

assign sum = a ^ b ^ cin;
assign carry = (a&b)|((a^b)&cin);
                
endmodule

