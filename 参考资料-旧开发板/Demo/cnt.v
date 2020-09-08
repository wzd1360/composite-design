module cnt(clk,clk_hz);
	input clk;
	output reg clk_hz;
	
	reg [15:0] cnt;
	parameter TIME=1000;
	 
	
always@(posedge clk)
begin
	 if (cnt==TIME)
	 begin
		cnt<=0;
		clk_hz=!clk_hz;
	 end
	else cnt<=cnt+1;
end 


endmodule

