`include "t_reg_array.v"
`include "s_reg_array.v"


module sw(clk, reset, valid, data_s, data_t, finish, max);

input clk;
input reset;
input valid;
input [1:0] data_t, data_s;
output finish;
output [11:0] max;

// parameters
parameter IDLE = 2'd0;
parameter BUSY = 2'd1;
parameter FINISH = 2'd2;


//------------------------------------------------------------------
// reg & wire
reg [1:0] state, next_state;
reg pe_enable, next_pe_enable;

// tmp
reg [11:0] counter;

reg finish;
	
//------------------------------------------------------------------
// other modules
t_reg_array t_reg_array_test(
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .t_in(data_t)
);
s_reg_array s_reg_array_test(
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .s_in(data_s)
);



//------------------------------------------------------------------
// combinational part
always@(*) begin
    case(state)
        IDLE: begin
            $display("IDLE");
            finish = 1'b0;

            if(valid) begin
                next_state = BUSY;
                next_pe_enable = 1'b1;
            end
            else begin
                next_state = IDLE;
                next_pe_enable = 1'b0;
            end
        end

        BUSY: begin
            $display("BUSY: %d", counter);
            finish = 1'b0;

            if(counter >= 12'd640)begin  
                next_state = FINISH;
            end
            else begin
                next_state = BUSY;
            end

        end

        FINISH: begin
            $display("FINISH");
            finish = 1'b1;
        end

        default begin
            finish = 1'b0;
        end
    endcase
end

//------------------------------------------------------------------
// sequential part
always@( posedge clk or posedge reset) begin
   if (reset) begin
       state <= IDLE;
       pe_enable <= 1'b0;

       counter <= 12'd1;
   end
   else begin
        state <= next_state;
        pe_enable <= next_pe_enable;
        if (state==BUSY) begin
            counter <= counter + 12'd1;
        end
        else begin
            counter <= 12'd1;
        end
   end


end
    
endmodule
