`include "pe_array.v"
`include "pe_reg_array.v"

module pe_combine(clk,reset,valid, pe_enable, s_in, t_in, max_out);

input clk;
input reset;
input valid;
input pe_enable;
input [1:0] s_in, t_in;
output [11:0] max_out;

wire [11:0] max_out;

wire [11:0] v_connect_tail, f_connect_tail;
wire [11:0] max_connect_head, v_connect_head, f_connect_head;


pe_reg_array pe_reg_array(
    .clk(clk),
    .reset(reset),
    .max_in(max_out), 


    .v_in(v_connect_tail), 
    .f_in(f_connect_tail), 
    .max_out(max_connect_head), 
    .v_out(v_connect_head), 
    .f_out(f_connect_head)
);



pe_array pe_array_test(
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .pe_enable(pe_enable),


    .s_in(s_in),
    .t_in(t_in),

    .max_in(max_connect_head),
    .v_in(v_connect_head),
    .f_in(f_connect_head),

    .max_out(max_out),
    .v_out(v_connect_tail),
    .f_out(f_connect_tail)
);

endmodule