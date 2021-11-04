module sw(clk, reset, valid, data_s, data_t, finish, max);

input clk;
input reset;
input valid;
input [1:0] data_t, data_s;
output finish;
output [11:0] max;

//------------------------------------------------------------------
// reg & wire
	
//------------------------------------------------------------------
// combinational part
always@(*) begin
	
end

//------------------------------------------------------------------
// sequential part
always@( posedge clk or posedge reset) begin
   
end
    
endmodule
