
module S_REG (clk,reset, in, out);

input clk;
input reset;
input [1:0] in;

output [1:0] out;

reg [1:0] out;

always@( negedge clk or posedge reset) begin

    if (reset) begin
        out <= 1'b0;
    end
    else begin
        out <= in;
    end
end
endmodule




module s_reg_array(clk,reset, valid, s_in, s_out);

input clk;
input reset;
input valid;
input [1:0] s_in;
output [1:0] s_out;

// params
parameter REG_NUM = 128;

// reg & wire
reg [1:0] s_out, next_s_out;
wire [1:0] s_connect[REG_NUM - 2:0];


genvar i;
generate
    
    for ( i = 0; i < REG_NUM - 1 ; i = i+1) begin : s_reg_array_loop
        if (i==0) begin
            T_REG t_reg(
                .clk(clk),
                .reset(reset),
                .in(s_out),

                .out(s_connect[i])
            );              
        end
        else begin
            T_REG t_reg(
                .clk(clk),
                .reset(reset),
                .in(s_connect[i-1]),

                .out(s_connect[i])
            );            
        end 
    end
endgenerate


// combinational part
always@(*) begin
    if (valid==1'b1) begin
        next_s_out = s_in;
    end
    else begin
        next_s_out = s_connect[REG_NUM - 2];
    end
end

// sequential part
always@( negedge clk or posedge reset) begin
   if (reset) begin
        s_out <= 2'b0;
        next_s_out <= 2'b0;
   end
   else begin
        s_out <= next_s_out;
   end


end

endmodule
