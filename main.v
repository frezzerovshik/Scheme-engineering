`timescale 1 ns / 1 ps

`define PULSE_WIDTH(period) period / 2 + (period % 2 ? 1 : 0)

module clockwise (
	output reg clk
);
integer period = 31;
integer clk_dt = 15;
    
    always #(clk_dt) clk = ~clk;
    
    initial begin
        #(100);
        period = 15;
        clk_dt = `PULSE_WIDTH(period);
        
        
        #(100);
        period = 1;
        clk_dt = `PULSE_WIDTH(period);
        
        #(100);
        $finish;
    end
endmodule

module counter (
	input wire reset,
	input wire clk,
	output reg [3:0] cnt
);
always @(posedge clk)
begin
if (reset == 0) 
	cnt <= 0;
else 
	cnt <= cnt +1;
end
endmodule 

module comparator (
	input A,
	input B,
	output reg aLessThanB,
	output reg aMoreThanB,
	output reg aEqualB
);
always @(A,B)
begin
if (A == B)
	begin
		aEqualB = 1;
		aLessThanB = 0;
		aMoreThanB = 0;
		
	end
else
	begin
		if (A > B)
		begin
			aEqualB = 0;
			aLessThanB = 0;
			aMoreThanB = 1;
		end
		else
			begin
				aEqualB = 0;
				aLessThanB = 1;
				aMoreThanB = 0;
			
			end
	end
end
endmodule

module twoInputOr (
	input wire firstIn,
	input wire secondIn,
	output reg out
);
always @(firstIn,secondIn)
begin
out = firstIn | secondIn;
end
endmodule

module twoInputXor (
	input wire firstIn,
	input wire secondIn,
	output reg out
);
always @(firstIn,secondIn)
begin
out = firstIn ^ secondIn;
end
endmodule

module Cursach ();
	wire [3:0] value_1;
	wire [3:0] value_2;
	


	comparator COMPARATOR_1(value_1,value_2,aLessThanB_1,aMoreThanB_1,aEqualB_1);
	comparator COMPARATOR_2(value_1,value_2,aLessThanB_2,aMoreThanB_2,aEqualB_2);
	
	twoInputXor forALessThanB (aLessThanB_1,aLessThanB_2, out_1);
	twoInputXor forAMoreThanB (aMoreThanB_1,aMoreThanB_2, out_2);
	twoInputXor forAEqualB (aEqualB_1,aEqualB_2, out_3);
	
	twoInputOr forAandCOutputs (out_1,out_3, out_ac);
	twoInputOr lastLevel (out_2,out_ac,result);
	
	clockwise firstClock (clockOutput_1);
	clockwise secondClock (clockOutput_2);
	
	twoInputOr forFirstClock (clockOutput_1,result, clockForFirstCounter);
	twoInputOr forSecondClock (clockOutput_2,result,clockForSecondCounter);

	counter COUNTER_1(1,clockForFirstCounter,value_1);
	counter COUNTER_2(1,clockForSecondCounter,value_2);
endmodule 

