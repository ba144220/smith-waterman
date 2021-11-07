`include "pe.v"



module pe_array(clk,reset,valid, pe_enable, s_in, t_in, max_in, v_in, f_in, max_out, v_out, f_out);

input clk;
input reset;
input valid;
input pe_enable;
input [1:0] s_in, t_in;
input [11:0] max_in, v_in, f_in;

output [11:0] max_out;
output [11:0] v_out;
output [11:0] f_out;

// params
parameter PE_NUMBER =  128;

//------------------------------------------------------------------
// reg & wire

wire [11:0] max_out;
wire [11:0] v_out;
wire [11:0] f_out;

reg save_s_signal, save_s_sent;

//wire [1:0] s_connect[255:0];
wire [1:0] t_connect[PE_NUMBER-1:0];
wire [11:0] max_connect[PE_NUMBER-1:0];
wire [11:0] v_connect[PE_NUMBER-1:0];
wire [11:0] f_connect[PE_NUMBER-1:0];
wire save_s_connect[PE_NUMBER-1:0];

reg save_s_connect_first;



genvar i;

generate
    for (i = 0; i < PE_NUMBER; i = i + 1) begin : pe_array_loop
        if(i==0)begin
            pe pe_test(
                .clk(clk),
                .reset(reset),
                .pe_enable(pe_enable),


                .s_in(s_in),
                
                .t_in(t_in),


                .max_in(max_in), 
                .v_in(v_in),
                .f_in(f_in),

                .save_s_in(save_s_connect_first),

                
                .t_out(t_connect[0]),
                .max_out(max_connect[0]),
                .v_out(v_connect[0]),
                .f_out(f_connect[0]),
                .save_s_out(save_s_connect[0])
            );
        end
        else if(i==PE_NUMBER-1)begin
            pe pe_test(
                .clk(clk),
                .reset(reset),
                .pe_enable(pe_enable),

                .s_in(s_in),
                
                .t_in(t_connect[i-1]),
                .max_in(max_connect[i-1]), 
                .v_in(v_connect[i-1]),
                .f_in(f_connect[i-1]),
                .save_s_in(save_s_connect[i-1]),

                .t_out(t_connect[i]),
                .max_out(max_out),
                .v_out(v_out),
                .f_out(f_out),
                .save_s_out(save_s_connect[i])
            );            
        end
        else begin
            pe pe_test(
                .clk(clk),
                .reset(reset),
                .pe_enable(pe_enable),
                .s_in(s_in),

                
                .t_in(t_connect[i-1]),
                .max_in(max_connect[i-1]), 
                .v_in(v_connect[i-1]),
                .f_in(f_connect[i-1]),
                .save_s_in(save_s_connect[i-1]),

                
                .t_out(t_connect[i]),
                .max_out(max_connect[i]),
                .v_out(v_connect[i]),
                .f_out(f_connect[i]),

                .save_s_out(save_s_connect[i])

            );            
        end

    end
endgenerate

//------------------------------------------------------------------
// combinational part
always@(*) begin

    if( save_s_signal ) begin
        save_s_connect_first = 1'b1;
    end
    else  save_s_connect_first = save_s_connect[PE_NUMBER - 1];

end

//------------------------------------------------------------------
// sequential part
always@( posedge clk  ) begin
    // max_out <= max_connect[PE_NUMBER -1];
end

always@( negedge clk or posedge reset ) begin

    if( reset )begin
        save_s_signal <= 1'b0;
        save_s_sent <= 1'b0;
    end
    else begin
        if ( valid ) begin
            if( save_s_sent )begin
                save_s_signal <= 1'b0;
                save_s_sent <= 1'b1;                
            end
            else begin
                save_s_signal <= 1'b1;
                save_s_sent <= 1'b1;  
            end
          
        end
        
    end
end

    
endmodule
