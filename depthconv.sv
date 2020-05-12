module depthconv(clk, reset, new_weight, weight_addr, next_stage_rdy, nz, nzposition, valid_out, rdy,
					outdata, outdataPosition, ksize_side, valid_in, datasize, inmap_out, numOfOutVals, 
					layer_done_in, layer_done_out);

    input						clk, reset, next_stage_rdy, valid_in, layer_done_in;
    input [31:0]				new_weight, nz, nzposition; 
    input [2:0]					ksize_side; 
    input [5:0]					datasize;
    output logic [5:0]			numOfOutVals;
    output logic				valid_out, rdy, layer_done_out;
    output logic [7:0][31:0]	outdata, outdataPosition;
    output logic [4:0]			inmap_out;
    output logic [11:0]			weight_addr;

    logic						load_weights, flag0, flag1, flag2, flag3, calculations,
    							k0en, k1en, k2en, k3en, calc_delay;
    logic [4:0]					inmap, prev_inmap;
    logic [26:0]				base_position, newposition;
    logic [16:0][31:0]			kvals;//17 vals, last is not used ever
    logic [31:0]				k;
    logic [5:0]					prev_count, count, output_count;// ksize;


    logic [5:0]				ksize, datasize_reg; 
    logic [5:0]				dMinusK, dMinusKPlus1; 
    logic [11:0]			dMinusKPlus1TimesD;


    integer i;
      

    always_ff @(posedge clk) begin
		if(reset) begin
			k0en<=1; k1en<=1; k2en<=1; k3en<=1;
			load_weights<=1;
			prev_inmap<=0;
			weight_addr<=0;
			valid_out<=0;
			prev_count<=0;
			count<=0;
			calculations<=0;
			output_count<=0;
			newposition<=0;
			calc_delay<=0;
			layer_done_out<=0;
			numOfOutVals<=0;
		end else if(!layer_done_in) begin
			/////////////////////////////////////////load weights and incoming in map vals
			prev_count<=count;
			prev_inmap<=inmap;
			if(prev_inmap!=inmap & !(load_weights)) begin
				load_weights<=1;
				weight_addr<=(inmap | 0)*ksize*4;
				count<=0;
			end
			if(load_weights) begin
				weight_addr<=weight_addr+4;
				count<=count+1;
				if(!(count<ksize-1)) begin
					load_weights<=0;
				end
			end
			kvals[prev_count]<=new_weight;

			////////////////////////////////////////begin mult for each output position
			if(valid_out==1)//include rdy from pointwise
				valid_out<=0;
			if(valid_in & !calculations)
				calculations<=1;	
			if((valid_in | calculations) & !(load_weights)) begin
				calc_delay<=1;
				if(ksize==4) begin
					if(flag0 & k0en) begin
						newposition<=0;
						k<=kvals[0];
						k0en<=0;
					end else if(flag1 & k1en) begin
						newposition<=1;
						k<=kvals[1];
						k1en<=0;
					end else if(flag2 & k2en) begin
						newposition<=datasize;
						k<=kvals[2];
						k2en<=0;
					end else if(flag3 & k3en) begin
						newposition<=datasize+1;
						k<=kvals[3];
						k3en<=0;
					end else begin
						calculations<=0;
						valid_out<=1;
						numOfOutVals<=output_count+1;
					end
				end

				if(calc_delay==1 & calculations) begin//delay once so k gets loaded
					outdata[output_count]<=k*nz;
					outdataPosition[output_count]<=base_position-newposition;
					output_count<=output_count+1;
				end

			end else begin
				k0en<=1; k1en<=1; k2en<=1; k3en<=1;
				output_count<=0; calc_delay<=0;
			end

		end else
			layer_done_out<=1;

		ksize<=ksize_side*ksize_side;
		dMinusK<=datasize-ksize_side;
		//dMinusKPlus1<=datasize-ksize_side+1;
		dMinusKPlus1TimesD<=(dMinusK+1)*datasize;
		datasize_reg<=datasize;
	end

	always_comb begin
		//ksize=ksize_side*ksize_side;
		base_position=nzposition[26:0];
		inmap=nzposition[31:27];
		inmap_out=inmap;
		if(prev_inmap!=inmap | load_weights | calculations | valid_in) begin
			rdy=0;
		end else
			rdy=1;


		if(ksize_side==2) begin
			if((base_position%datasize_reg <= dMinusK) & base_position<dMinusKPlus1TimesD)
				flag0 = 1;
			else
				flag0 = 0;
			if((base_position%datasize_reg > 0) & base_position<dMinusKPlus1TimesD)
				flag1 = 1;
			else
				flag1 = 0;
			if((base_position%datasize_reg <= dMinusK) & base_position>=datasize_reg)
				flag2 = 1;
			else
				flag2 = 0;
			if((base_position%datasize_reg > 0) & base_position>=datasize_reg)
				flag3 = 1;
			else
				flag3 = 0;							
		end else begin
			flag0=0; flag1=0; flag2=0; flag3=0;
		end

	end

endmodule




