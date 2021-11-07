
module PE_REG (clk,reset, max_in, v_in, f_in, max_out, v_out, f_out);

input clk;
input reset;
input [11:0] max_in, v_in, f_in;
output [11:0] max_out, v_out, f_out;


reg [11:0] max_out, v_out, f_out;

always@( posedge clk or posedge reset) begin

    if (reset) begin
        max_out <= 12'd0;
        v_out <= 12'd0;
        f_out <= -12'd4;
    end
    else begin
        max_out <= max_in;
        v_out <= v_in;
        f_out <= f_in;
    end
end
endmodule




module pe_reg_array(clk,reset, max_in, v_in, f_in, max_out, v_out, f_out);

input clk;
input reset;
input [11:0] max_in, v_in, f_in;
output [11:0] max_out, v_out, f_out;

// params
parameter REG_NUM = 128;

// reg & wire
wire [11:0] max_out;
wire [11:0] v_out;
wire [11:0] f_out;

wire [11:0] max_connect[REG_NUM-1 :0];
wire [11:0] v_connect[REG_NUM-1 :0];
wire [11:0] f_connect[REG_NUM-1 :0];


genvar i;
generate
    
    for ( i = 0; i <= REG_NUM-1  ; i = i+1) begin : pe_reg_array_loop
        if (i==0) begin
            PE_REG pe_reg(
                .clk(clk),
                .reset(reset),

                .max_in(max_in),
                .v_in(v_in),
                .f_in(f_in),

                .max_out(max_connect[i]),
                .v_out(v_connect[i]),
                .f_out(f_connect[i])

            );              
        end
        else if (i==REG_NUM-1) begin
            PE_REG pe_reg(
                .clk(clk),
                .reset(reset),

                .max_in(max_connect[i-1]),
                .v_in(v_connect[i-1]),
                .f_in(f_connect[i-1]),

                .max_out(max_out),
                .v_out(v_out),
                .f_out(f_out)                
            );
        end
        else begin
            PE_REG pe_reg(
                .clk(clk),
                .reset(reset),

                .max_in(max_connect[i-1]),
                .v_in(v_connect[i-1]),
                .f_in(f_connect[i-1]),

                .max_out(max_connect[i]),
                .v_out(v_connect[i]),
                .f_out(f_connect[i])
            );            
        end 
    end
endgenerate


// combinational part
// always@(*) begin

// end

// sequential part
// always@( posedge clk or posedge reset) begin

// end

endmodule
