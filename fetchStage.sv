module fetchStage2(clk, reset, rddata, rddataPosition, addr, next_stage_rdy, nz, nzposition, valid, 
					next_stage_rdy2, layer_done);
    input						clk, reset, next_stage_rdy, next_stage_rdy2;
    input [31:0]				rddata, rddataPosition;
    output logic [31:0]			nz, nzposition;
    output logic [15:0]			addr;
    output logic				valid, layer_done;

    logic [31:0]				prev_addr;
	integer i;
     
    always_ff @(posedge clk) begin
		if(reset) begin
			addr<=0;
			prev_addr<=0;
			layer_done<=0;
		end else begin
			if(!layer_done) begin
				if(next_stage_rdy & next_stage_rdy2) begin
					nz<=rddata;
					nzposition<=rddataPosition;
					addr<=addr+4;
					prev_addr<=addr;
					valid<=1;
					if(rddataPosition==32'hFFFFFFFF) begin//stop address for the layer
						layer_done<=1;
					end
				end else begin
					valid<=0;
				end
			end
		end
	end

endmodule




