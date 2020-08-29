module address(CLK,add);
input CLK;
output add;
reg [7:0] add;
always @ (posedge CLK)
begin
  add[7:0]<=add[7:0]+1'b1;
end
endmodule
