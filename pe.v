module pe(
    clk, 
    reset,
    pe_enable,
    save_s_in,
    s_in, 
    t_in, 
    max_in, 
    v_in, 
    f_in, 
    t_out, 
    max_out, 
    v_out, 
    f_out, 
    save_s_out
);

input clk;
input reset;
input pe_enable;
input save_s_in;
input [1:0] s_in;
input [1:0]  t_in;
input [11:0] max_in;
input [11:0] v_in;
input [11:0] f_in;

output save_s_out;
output [1:0] t_out;
output [11:0] max_out;
output [11:0] v_out;
output [11:0] f_out;


// params
parameter alpha = 12'd7 ;
parameter beta = 12'd3 ;

parameter IDLE = 2'd0;
parameter BUSY = 2'd1;


//------------------------------------------------------------------
// reg & wire
reg save_s_out;
reg save_s_control;
reg [1:0] t_out;
reg [11:0] max_out;
reg [11:0] v_out;
reg [11:0] f_out;
reg [11:0] e_out;

reg [11:0] v_diag;

reg [11:0] v_diag_LUT; 
reg [11:0] e_i_j;
reg [11:0] f_i_j;
reg [1:0] s;

reg [1:0] state;


//------------------------------------------------------------------
// combinational part
always@(*) begin
    if(state==BUSY)begin
        v_diag_LUT = v_diag + LUT(s, t_out);
        e_i_j = max2(e_out - beta, v_out - alpha);
        f_i_j = max2(v_in - alpha, f_in - beta);
    end      
    else begin
        v_diag_LUT = 12'd0;
        e_i_j = 12'd0;
        f_i_j = -12'd4;  
    end



end

//------------------------------------------------------------------
// sequential part
always@( posedge clk ) begin
    if( pe_enable ) begin
        t_out <= t_in;
        v_diag <= v_in;
        v_out <= max2( max2(v_diag_LUT, 12'd0) , max2(e_i_j,f_i_j) );
        
        f_out <= f_i_j;
        max_out <= max3(max_out, v_out, max_in);
        state <= BUSY;
        

        if( save_s_in  ) begin
            if( save_s_control) begin
                s <= s_in;
                save_s_control <= 1'b0;
                e_out <= -12'd4;
            end
            else begin
                s <= s;
                save_s_control <= 1'b1;
                e_out <= e_i_j;
            end
        end
        else begin
            s <= s;  
            e_out <= e_i_j;
        end

    end
    else begin
        t_out <= 12'd0;
        v_diag <= 12'd0;
        v_out <= 12'd0;
        e_out <= -12'd4;
        f_out <= -12'd4;
        max_out <= 12'd0;
        e_i_j <= -12'd4;
        f_i_j <= -12'd4;
        state <= IDLE;
        save_s_control <= 1'b1;
        //save_s_out <= 2'b0;
        
    end

end

always@( negedge clk or posedge reset ) begin
    if(reset) begin
        save_s_out <= 1'b0;
    end
    else save_s_out <= save_s_in;
end

/*------------  functions -------*/
function [11:0] max2;
    input [11:0]   a;
    input [11:0]   b;
    if($signed(a)>$signed(b))begin
        max2 = a;
    end
    else begin
        max2 = b;
    end
endfunction
function [11:0] max3;
    input [11:0]   a;
    input [11:0]   b;
    input [11:0]   c;
    reg [11:0] tmp;
    begin
        if($signed(a)>$signed(b) )begin
            tmp = a;
        end
        else begin
            tmp = b;
        end
        if($signed(tmp) > $signed(c))begin
            max3=tmp;
        end
        else begin
            max3=c;
        end

    end
endfunction

function [11:0] LUT;
    input [11:0]   s;
    input [11:0]   t;
    begin
        if(s==t)begin
            LUT = 12'd8;
        end
        else begin
            LUT = -12'd5;
        end
    end
endfunction
    
endmodule
