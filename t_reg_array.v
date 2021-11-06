
module T_REG (clk,reset, in, out);

input clk;
input reset;
input [1:0] in;

output [1:0] out;

reg [1:0] out;

always@( posedge clk or posedge reset) begin

    if (reset) begin
        out <= 1'b0;
    end
    else begin
        out <= in;
    end
end
endmodule




module t_reg_array(clk,reset, valid, t_in, t_out);

input clk;
input reset;
input valid;
input [1:0] t_in;
output [1:0] t_out;

// params
parameter REG_NUM = 256;

// reg & wire
reg [1:0] t_out, next_t_out;
wire [1:0] t_connect[REG_NUM - 2:0];


genvar i;
generate
    
    for ( i = 0; i < REG_NUM - 1 ; i = i+1) begin : gen_loop
        if (i==0) begin
            T_REG t_reg(
                .clk(clk),
                .reset(reset),
                .in(t_out),

                .out(t_connect[i])
            );              
        end
        else begin
            T_REG t_reg(
                .clk(clk),
                .reset(reset),
                .in(t_connect[i-1]),

                .out(t_connect[i])
            );            
        end 
    end
endgenerate


// combinational part
always@(*) begin
    if (valid==1'b1) begin
        next_t_out = t_in;
    end
    else begin
        next_t_out = t_connect[REG_NUM - 2];
    end
end

// sequential part
always@( posedge clk or posedge reset) begin
   if (reset) begin
        t_out <= 2'b0;
        next_t_out <= 2'b0;
   end
   else begin
        t_out <= next_t_out;
   end


end

endmodule
