module  count(CLK,KEY1,KEY2,ir_code,clk_in,clk_hz,rst_n,clk_out,//DS_C,DS_D,DS_G,DS_DP);
DS_A,DS_B,DS_E,DS_F,
DS_EN1,DS_EN2,DS_EN3,DS_EN4,
DS_C,DS_D,DS_G,DS_DP);
input KEY1;
input KEY2;
input CLK;
input clk_in ;
input clk_hz ;
input ir_code;
input rst_n;         //PIN 100  全局低电平复位
output clk_out;//DS_C,DS_D,DS_G,DS_DP;

output 	DS_A,DS_B,DS_E,DS_F;
output	DS_EN1,DS_EN2,DS_EN3,DS_EN4;
output 	DS_C,DS_D,DS_G,DS_DP;
	
parameter TIME=32'd100_000_000;
wire [7:0] ir_code;
reg clk_out;
reg [31:0] cnt;
reg[31:0] tmp1;
reg[31:0] tmp2;
reg [31:0] num;
reg [1:0] num_4=2'b00;
reg [3:0] code [3:0];
/*
reg [3:0]led_reg;
wire [3:0]led ;
assign {DS_D,DS_C,DS_G,DS_DP} = led;
*/


always @ (posedge clk_hz)  //改为1HZ,指示灯
begin
/*if(KEY1 ==1'b1)   //改为按键
begin
   code[0]=4'h0;
   code[1]=4'h0;
   code[2]=4'h0;
   code[3]=4'h1;//排除全零
end
else*/
 if (KEY2==1'b0)
//else if(ir_code==8'h40)  //改为按键       
begin 
   num_4<=num_4+1'b1;
/*
case(num_4)
2'b00:led_reg=4'b0111;
2'b01:led_reg=4'b1011;
2'b10:led_reg=4'b1101;
2'b11:led_reg=4'b1110;
endcase
*/
case(ir_code)
8'h16:code[num_4]=4'h0;
8'h0C:code[num_4]=4'h1;
8'h18:code[num_4]=4'h2;
8'h5E:code[num_4]=4'h3;
8'h08:code[num_4]=4'h4;
8'h1C:code[num_4]=4'h5;
8'h5A:code[num_4]=4'h6;
8'h42:code[num_4]=4'h7;
8'h52:code[num_4]=4'h8;
8'h4A:code[num_4]=4'h9;
endcase

end

tmp1=TIME+TIME;
case (code[3])
4'h0:begin tmp2<=code[2]*100+code[1]*10+code[0]-1;
				num=tmp1/tmp2;end
4'h1:begin tmp2<=(code[2]*100+code[1]*10+code[0])*10-1;
				num=tmp1/tmp2;end
4'h2:begin tmp2<=(code[2]*100+code[1]*10+code[0])*100-1;
				num=tmp1/tmp2;end
4'h3:begin tmp2<=(code[2]*100+code[1]*10+code[0])*1_000-1;
				num=tmp1/tmp2;end
4'h4:begin tmp2<=(code[2]*100+code[1]*10+code[0])*10_000-1;
				num=tmp1/tmp2;end
4'h5:begin tmp2<=(code[2]*100+code[1]*10+code[0])*100_000-1;
				num=tmp1/tmp2;end

/*		
4'h6:begin tmp2<=(code[2]*100+code[1]*10+code[0])*1_000_000-1;
				num=tmp1/tmp2;end
4'h7:begin tmp2<=(code[2]*100+code[1]*10+code[0])*10_000_000-1;
				num=tmp1/tmp2;end
*/				
default:begin tmp2<=code[2]*100+code[1]*10+code[0]-1;
				num=tmp1/tmp2;end
endcase

end

//assign led=led_reg;



always @ (posedge clk_in or negedge rst_n)
begin 
         if(1'b0==rst_n)
			   cnt<=32'd0;	
				else if (cnt==num/4)
				cnt<=32'd0;
				else
				cnt<=cnt+1'b1;
				end
				
always @ (posedge clk_in or negedge rst_n)
begin 
		if (1'b0==rst_n)
		clk_out<=1'b1;
		else if (cnt==num/4)
		clk_out<=~clk_out ;
end



wire [6:0]ds_reg;
wire [3:0]ds_en;
assign {DS_G,DS_F,DS_E,DS_D,DS_C,DS_B,DS_A} = ds_reg ;
assign {DS_EN1,DS_EN2,DS_EN3,DS_EN4} = ds_en;

reg  [3:0]num_dt[3:0];
	dt_module dt_ct(
	.clk(CLK),
	.num1(num_dt[0]),
	.num2(num_dt[1]),
	.num3(num_dt[2]),
	.num4(num_dt[3]),
	.ds_en(ds_en),
	.ds_reg(ds_reg)
);
reg [31:0]cnt1;
always @(posedge CLK)
	begin
		cnt1 <= cnt1 + 1;
		num_dt[0] = code[0];
		num_dt[1] = code[1];
		num_dt[2] = code[2];
		num_dt[3] = code[3];
	end
	
endmodule


