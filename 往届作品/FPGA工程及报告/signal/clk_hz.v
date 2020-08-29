module clk_hz(clk_in,clk_out);
input clk_in;
output clk_out;
reg clk_out;
reg [31:0] cnt;
parameter TIME=1_000_000;
always @(posedge clk_in)
begin
   if(cnt == TIME/2)
			begin 
				cnt<= 32'b0; 
				clk_out = !clk_out;
			end
		else cnt <= cnt + 1'b1;
end
endmodule
