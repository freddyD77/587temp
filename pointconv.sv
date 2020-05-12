module pointconv2(clk, reset, new_weight, weight_addr, valid_out, rdy,
					indata, indataPosition, numOfOutmaps, valid_in, inmap_in, numOfInVals, outdata, 
					outposition, layer_done_in, layer_done_out);
    input						clk, reset, valid_in, layer_done_in;//asynch signal
    input [31:0]				new_weight; 
    input [6:0] 				numOfOutmaps; 
    input [5:0] 				numOfInVals;
    input [31:0]			indata, indataPosition;
    input [4:0]					inmap_in;
    output logic [31:0]			outposition;
    output logic [11:0]			weight_addr;
    output logic				valid_out, rdy, layer_done_out;
    output logic [7:0][31:0]			outdata;
    

    logic						load_weights, calculations, calc_delay;
    logic [4:0]					prev_inmap;
    logic [16:0][31:0]			outmapfilter;//17 vals, last is not used ever
    logic [6:0]				prev_count, count, input_count;


    integer i;
      

    always_ff @(posedge clk) begin
		if(reset) begin
			load_weights<=1;
			prev_inmap<=0;
			weight_addr<=0;
			valid_out<=0;
			prev_count<=0;
			count<=0;
			calculations<=0;
			input_count<=0;
			calc_delay<=0;
			layer_done_out<=0;
		end else if(!layer_done_in) begin
			/////////////////////////////////////////load weights and incoming in map vals
			prev_count<=count;
			prev_inmap<=inmap_in;
			if(prev_inmap!=inmap_in & !(load_weights)) begin
				load_weights<=1;
				weight_addr<=(inmap_in | 0)*numOfOutmaps*4;
				count<=0;
			end
			if(load_weights) begin
				weight_addr<=weight_addr+4;
				count<=count+1;
				if(!(count<numOfOutmaps-1)) begin
					load_weights<=0;
				end
			end
			outmapfilter[prev_count]<=new_weight;

			////////////////////////////////////////mult with outmap filters in parallel
			if(valid_in & !(load_weights) & (prev_inmap==inmap_in)) begin
				outposition<=indataPosition;
				valid_out<=1;
				for(i=0; i<8; i=i+1)//16 is max number of numOfOutmaps in this system
					outdata[i]<=indata*outmapfilter[i];
			end else
				valid_out<=0;

		end else
			layer_done_out<=1;
	end

	always_comb begin
		if(prev_inmap!=inmap_in | load_weights) begin
			rdy=0;
		end else
			rdy=1;

	end

endmodule




