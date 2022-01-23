`timescale 1ns/1ns

module elevator 
(
  input i_clock,
  input i_reset,
  input [1:0] i_buttons,
  output [1:0] o_current_floor
);
  
	  logic dp_up, dp_down, done_moving;
	  
	  controlpath thecontrolpath(
		 .i_clock(i_clock),
		 .i_reset(i_reset),
		 .i_buttons(i_buttons),
		 .o_current_floor(o_current_floor),
		 .i_done(done_moving),
		 .o_dp_up(dp_up),
		 .o_dp_down(dp_down)
	  );
	  
	  datapath thedatapath(
		 .i_clock(i_clock),
		 .i_reset(i_reset),
		 .i_dp_up(dp_up),
		 .i_dp_down(dp_down),
		 .o_done(done_moving)
	  );  

endmodule

module controlpath (
  input i_clock,
  input i_reset,
  input [1:0] i_buttons,
  output logic [1:0] o_current_floor,
  input i_done, 
  output logic o_dp_up,
  output logic o_dp_down
);
  
  // Declare two objects, 'state' and 'nextstate' of type enum.
  // Add more states as needed for your design. 
  enum int unsigned{
    S_G,
    S_1,
    S_2,
    S_3
  } state, nextstate;
  
  // Clocked always block for making state registers
  always_ff @ (posedge i_clock or posedge i_reset) begin
    if (i_reset) state <= S_G;
    else state <= nextstate;
  end
  
  always_comb begin
    nextstate = state;
    o_dp_up = 1'b0;
    o_dp_down = 1'b0;
    o_current_floor = 2'd0;
    
    case(state)
	
        //cases for ground floor 
		S_G: begin
			o_current_floor = 2'd0;
			if (i_buttons == 0) begin	
				o_dp_up = 1'b0;
				o_dp_down = 1'b0;
				
				nextstate = S_G;
			end
			else if (i_buttons == 1)begin
				o_dp_up = 1'b1;
				o_dp_down = 1'b0;
				 
				nextstate = S_1;
			end
			else if (i_buttons == 2)begin
				o_dp_up = 1'b1;
				o_dp_down = 1'b0;
				 
				nextstate = S_1;
			end
			else begin
				o_dp_up = 1'b1;
				o_dp_down = 1'b0;
				 
				nextstate = S_1;
			end
		end
		
		//cases for first floor
		S_1: begin
			o_current_floor = 2'd1;
			if (i_buttons == 0) begin	
				o_dp_up = 1'b0;
				o_dp_down = 1'b1;				 
				nextstate = S_G;
			end
			else if (i_buttons == 1)begin
				o_dp_up = 1'b0;
				o_dp_down = 1'b0;				
				nextstate = S_1;
			end
			else if (i_buttons == 2)begin
				o_dp_up = 1'b1;
				o_dp_down = 1'b0;				 
				nextstate = S_2;
			end
			else begin
				o_dp_up = 1'b1;
				o_dp_down = 1'b0;				 
				nextstate = S_2;
			end
		end
		
		//case for second floor 
		S_2: begin
			o_current_floor = 2'd2;
			if (i_buttons == 0) begin	
				o_dp_up = 1'b0;
				o_dp_down = 1'b1;				 
				nextstate = S_1;
			end
			else if (i_buttons == 1)begin
				o_dp_up = 1'b0;
				o_dp_down = 1'b1;				 
				nextstate = S_1;
			end
			else if (i_buttons == 2)begin
				o_dp_up = 1'b0;
				o_dp_down = 1'b0;				
				nextstate = S_2;
			end
			else begin
				o_dp_up = 1'b1;
				o_dp_down = 1'b0;				 
				nextstate = S_3;
			end
		end
		
		//case for third floor 
		S_3: begin
			o_current_floor = 2'd3;
			if (i_buttons == 0) begin	
				o_dp_up = 1'b0;
				o_dp_down = 1'b1;				 
				nextstate = S_2;
			end
			else if (i_buttons == 1)begin
				o_dp_up = 1'b0;
				o_dp_down = 1'b1;
				nextstate = S_2;
			end
			else if (i_buttons == 2)begin
				o_dp_up = 1'b0;
				o_dp_down = 1'b1;
				nextstate = S_2;
			end
			else begin
				o_dp_up = 1'b0;
				o_dp_down = 1'b0;				
				nextstate = S_3;
			end
		end 
		
		default: begin
			o_current_floor = 2'd0;
			o_dp_up = 1'b0;
			o_dp_down = 1'b0;			 
			nextstate = S_G;	
		end
    endcase
  end
  
endmodule

// The datapath takes a move up or move down input and waits 5 cycles 
// before asserting o_done, to indicate that it has moved 1 floor. 
// NOTE 1: You do not need to edit the data path code. 
// NOTE 2: The datapath doesn't do any error checking; so if you ask it to move down
// from G or move up from 3, it will still do that. All checks should happen
// inside the control path. 

module datapath (
  input i_clock,
  input i_reset,
  input i_dp_up,
  input i_dp_down,
  output o_done 
);
  
  logic [2:0] count;
  
  always_ff @ (posedge i_clock or posedge i_reset) begin
    if ((i_reset) || (i_dp_up) || (i_dp_down))
      count <= 3'd0;
    else
      count <= count + 3'd1;
  end
  
  assign o_done = (count == 3'd5);
          
endmodule
