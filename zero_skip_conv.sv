module zero_skip_conv2(wr_enout0, wr_enout1, wr_enout2, wr_enout3,
                        wr_enout4, wr_enout5, wr_enout6, wr_enout7,
                        wr_enout8, wr_enout9, wr_enout10, wr_enout11,
                        wr_enout12, wr_enout13, wr_enout14, wr_enout15,

                        wr_addrout0, wrdataout0, rd_addrout0, 
                        wr_addrout1, wrdataout1, rd_addrout1,  
                        wr_addrout2, wrdataout2, rd_addrout2, 
                        wr_addrout3, wrdataout3, rd_addrout3,  
                        wr_addrout4, wrdataout4, rd_addrout4,  
                        wr_addrout5, wrdataout5, rd_addrout5,  
                        wr_addrout6, wrdataout6, rd_addrout6,  
                        wr_addrout7, wrdataout7, rd_addrout7,  
                        wr_addrout8, wrdataout8, rd_addrout8,  
                        wr_addrout9, wrdataout9, rd_addrout9,  
                        wr_addrout10, wrdataout10, rd_addrout10,  
                        wr_addrout11, wrdataout11, rd_addrout11,  
                        wr_addrout12, wrdataout12, rd_addrout12,  
                        wr_addrout13, wrdataout13, rd_addrout13,  
                        wr_addrout14, wrdataout14, rd_addrout14,  
                        wr_addrout15, wrdataout15, rd_addrout15,

                        rddataout0, rddataout1, rddataout2, rddataout3, 
                        rddataout4, rddataout5, rddataout6, rddataout7, 
                        rddataout8, rddataout9, rddataout10, rddataout11, 
                        rddataout12, rddataout13, rddataout14, rddataout15,

                        addrweightD, addrweightP, wrdata_for_input_data, 
                        wrposition_for_input_data, addr_for_input_data,
                        wr_en_for_input_data, PL_need_weights, PL_need_data, controlled_reset,

                        rddataF, rddataAddrF, rddataweightD, rddataweightP,
                        ksize_side_PS, datasize_PS, numOfOutmaps_PS, numOfExecutedLayers_PS,
                        clk, reset, PS_loading

                        );

    input               clk, reset, PS_loading;
    input [2:0]         ksize_side_PS;
    input [4:0]         numOfExecutedLayers_PS;
    input [5:0]         datasize_PS;
    input [6:0]         numOfOutmaps_PS;
    input [31:0]        rddataF, rddataAddrF, rddataweightD, rddataweightP;
    input [31:0]        rddataout0, rddataout1, rddataout2, rddataout3, 
                        rddataout4, rddataout5, rddataout6, rddataout7, 
                        rddataout8, rddataout9, rddataout10, rddataout11, 
                        rddataout12, rddataout13, rddataout14, rddataout15;

    output logic        wr_en_for_input_data, PL_need_weights, PL_need_data, controlled_reset;
    output logic        wr_enout0, wr_enout1, wr_enout2, wr_enout3,
                        wr_enout4, wr_enout5, wr_enout6, wr_enout7,
                        wr_enout8, wr_enout9, wr_enout10, wr_enout11,
                        wr_enout12, wr_enout13, wr_enout14, wr_enout15;
    output logic [31:0] wrdata_for_input_data, wrposition_for_input_data;
    output logic [15:0] addr_for_input_data;
    output logic [31:0] wrdataout0, wrdataout1, wrdataout2, wrdataout3,  
                        wrdataout4, wrdataout5, wrdataout6, wrdataout7, 
                        wrdataout8, wrdataout9, wrdataout10, wrdataout11,  
                        wrdataout12, wrdataout13, wrdataout14, wrdataout15;
    output logic [11:0] rd_addrout0, rd_addrout1, rd_addrout2, rd_addrout3, 
                        rd_addrout4, rd_addrout5, rd_addrout6, rd_addrout7, 
                        rd_addrout8, rd_addrout9, rd_addrout10, rd_addrout11, 
                        rd_addrout12, rd_addrout13, rd_addrout14, rd_addrout15,
                        wr_addrout0, wr_addrout1, wr_addrout2, wr_addrout3, 
                        wr_addrout4, wr_addrout5, wr_addrout6, wr_addrout7, 
                        wr_addrout8, wr_addrout9, wr_addrout10, wr_addrout11, 
                        wr_addrout12, wr_addrout13, wr_addrout14, wr_addrout15,
                        addrweightD, addrweightP; 

    logic				rdyD, rdyP, layer_doneF, layer_doneD, layer_doneP;
    logic [31:0]		nzFD, nzpositionFD, outaddrP;
    logic				validF, validD, validP, done_translating, last_wr_en;
    logic [31:0]        outdataD, outdataAddrD; 
    logic [7:0][31:0]   outdataP;
    logic [2:0]         ksize_side;
    logic [4:0]         inmap_inDP;
    logic [5:0]         numOfOutVals, datasize;
    logic [6:0]         numOfOutmaps;
    logic               RELU0done, wr_en_beggining0, RELU1done, wr_en_beggining1,
                        RELU2done, wr_en_beggining2, RELU3done, wr_en_beggining3,
                        RELU4done, wr_en_beggining4, RELU5done, wr_en_beggining5,
                        RELU6done, wr_en_beggining6, RELU7done, wr_en_beggining7,
                        RELU8done, wr_en_beggining8, RELU9done, wr_en_beggining9,
                        RELU10done, wr_en_beggining10, RELU11done, wr_en_beggining11,
                        RELU12done, wr_en_beggining12, RELU13done, wr_en_beggining13,
                        RELU14done, wr_en_beggining14, RELU15done, wr_en_beggining15;
    logic [31:0]        wrdata_beggining0, dataposition0,
                        wrdata_beggining1, dataposition1,
                        wrdata_beggining2, dataposition2,
                        wrdata_beggining3, dataposition3,
                        wrdata_beggining4, dataposition4,
                        wrdata_beggining5, dataposition5,
                        wrdata_beggining6, dataposition6,
                        wrdata_beggining7, dataposition7,
                        wrdata_beggining8, dataposition8,
                        wrdata_beggining9, dataposition9,
                        wrdata_beggining10, dataposition10,
                        wrdata_beggining11, dataposition11,
                        wrdata_beggining12, dataposition12,
                        wrdata_beggining13, dataposition13,
                        wrdata_beggining14, dataposition14,
                        wrdata_beggining15, dataposition15;
    logic [15:0]        addr_beggining0, addr_beggining1, addr_beggining2, addr_beggining3, 
                        addr_beggining4, addr_beggining5, addr_beggining6, addr_beggining7,
                        addr_beggining8, addr_beggining9, addr_beggining10, addr_beggining11,
                        addr_beggining12, addr_beggining13, addr_beggining14, addr_beggining15,
                        addrF, recent_addr;
    logic [4:0]         next_state, numOfExecutedLayers;
    


    
    fetchStage2 f0(.clk(clk) , .reset(controlled_reset) , .rddata(rddataF) , .rddataPosition(rddataAddrF) 
    	, .addr(addrF) , .next_stage_rdy(rdyD) , .nz(nzFD) , .nzposition(nzpositionFD) , .valid(validF), 
        .next_stage_rdy2(rdyP), .layer_done(layer_doneF));
    
    depthconv2 d0(.clk(clk) , .reset(controlled_reset) , .new_weight(rddataweightD) , .weight_addr(addrweightD) , 
        .next_stage_rdy(1'b0) , .nz(nzFD) , .nzposition(nzpositionFD) , .valid_out(validD) , .rdy(rdyD) , 
        .outdata(outdataD) , .outdataPosition(outdataAddrD) , .ksize_side(ksize_side), .valid_in(validF), 
        .datasize(datasize), .inmap_out(inmap_inDP), .numOfOutVals(numOfOutVals), 
        .layer_done_in(layer_doneF), .layer_done_out(layer_doneD));
    
    pointconv2 p0(.clk(clk) , .reset(controlled_reset) , .new_weight(rddataweightP) , 
        .weight_addr(addrweightP) , .valid_out(validP) , .rdy(rdyP) ,
        .indata(outdataD) , .indataPosition(outdataAddrD) , .numOfOutmaps(numOfOutmaps) , .valid_in(validD) , 
        .inmap_in(inmap_inDP), .numOfInVals(numOfOutVals), .outposition(outaddrP), .outdata(outdataP), 
        .layer_done_in(layer_doneD), .layer_done_out(layer_doneP));

    relu_accum #(0) ra0(.clk(clk) , .reset(controlled_reset) , .rddata(rddataout0) , .rd_addr(rd_addrout0) , 
        .valid_in(validP) , .wrdata(wrdataout0) , .wr_addr(wr_addrout0) , .wr_en(wr_enout0) , 
        .indata(outdataP[0]) , .inposition(outaddrP) , .numOfOutmaps(numOfOutmaps), 
        .layer_done_in(layer_doneP), .start(layer_doneP), .finished(RELU0done), 
        .addr_beggining_index_in(16'd0), .datasize(datasize), .ksize_side(ksize_side),
        .wrdata_beggining(wrdata_beggining0), .wr_en_beggining(wr_en_beggining0), 
        .addr_beggining_index_out(addr_beggining0), .dataposition(dataposition0));

    relu_accum #(1) ra1(.clk(clk) , .reset(controlled_reset) , .rddata(rddataout1) , .rd_addr(rd_addrout1) , 
        .valid_in(validP) , .wrdata(wrdataout1) , .wr_addr(wr_addrout1) , .wr_en(wr_enout1) , 
        .indata(outdataP[1]) , .inposition(outaddrP) , .numOfOutmaps(numOfOutmaps), 
        .layer_done_in(layer_doneP), .start(RELU0done), .finished(RELU1done), 
        .addr_beggining_index_in(addr_beggining0), .datasize(datasize), .ksize_side(ksize_side),
        .wrdata_beggining(wrdata_beggining1), .wr_en_beggining(wr_en_beggining1), 
        .addr_beggining_index_out(addr_beggining1), .dataposition(dataposition1));

    relu_accum #(2) ra2(.clk(clk) , .reset(controlled_reset) , .rddata(rddataout2) , .rd_addr(rd_addrout2) , 
        .valid_in(validP) , .wrdata(wrdataout2) , .wr_addr(wr_addrout2) , .wr_en(wr_enout2) , 
        .indata(outdataP[2]) , .inposition(outaddrP) , .numOfOutmaps(numOfOutmaps), 
        .layer_done_in(layer_doneP), .start(RELU1done), .finished(RELU2done), 
        .addr_beggining_index_in(addr_beggining1), .datasize(datasize), .ksize_side(ksize_side),
        .wrdata_beggining(wrdata_beggining2), .wr_en_beggining(wr_en_beggining2), 
        .addr_beggining_index_out(addr_beggining2), .dataposition(dataposition2));

    relu_accum #(3) ra3(.clk(clk) , .reset(controlled_reset) , .rddata(rddataout3) , .rd_addr(rd_addrout3) , 
        .valid_in(validP) , .wrdata(wrdataout3) , .wr_addr(wr_addrout3) , .wr_en(wr_enout3) , 
        .indata(outdataP[3]) , .inposition(outaddrP) , .numOfOutmaps(numOfOutmaps), 
        .layer_done_in(layer_doneP), .start(RELU2done), .finished(RELU3done), 
        .addr_beggining_index_in(addr_beggining2), .datasize(datasize), .ksize_side(ksize_side),
        .wrdata_beggining(wrdata_beggining3), .wr_en_beggining(wr_en_beggining3), 
        .addr_beggining_index_out(addr_beggining3), .dataposition(dataposition3));

    relu_accum #(4) ra4(.clk(clk) , .reset(controlled_reset) , .rddata(rddataout4) , .rd_addr(rd_addrout4) , 
        .valid_in(validP) , .wrdata(wrdataout4) , .wr_addr(wr_addrout4) , .wr_en(wr_enout4) , 
        .indata(outdataP[4]) , .inposition(outaddrP) , .numOfOutmaps(numOfOutmaps), 
        .layer_done_in(layer_doneP), .start(RELU3done), .finished(RELU4done), 
        .addr_beggining_index_in(addr_beggining3), .datasize(datasize), .ksize_side(ksize_side),
        .wrdata_beggining(wrdata_beggining4), .wr_en_beggining(wr_en_beggining4), 
        .addr_beggining_index_out(addr_beggining4), .dataposition(dataposition4));

    relu_accum #(5) ra5(.clk(clk) , .reset(controlled_reset) , .rddata(rddataout5) , .rd_addr(rd_addrout5) , 
        .valid_in(validP) , .wrdata(wrdataout5) , .wr_addr(wr_addrout5) , .wr_en(wr_enout5) , 
        .indata(outdataP[5]) , .inposition(outaddrP) , .numOfOutmaps(numOfOutmaps), 
        .layer_done_in(layer_doneP), .start(RELU4done), .finished(RELU5done), 
        .addr_beggining_index_in(addr_beggining4), .datasize(datasize), .ksize_side(ksize_side),
        .wrdata_beggining(wrdata_beggining5), .wr_en_beggining(wr_en_beggining5), 
        .addr_beggining_index_out(addr_beggining5), .dataposition(dataposition5));

    relu_accum #(6) ra6(.clk(clk) , .reset(controlled_reset) , .rddata(rddataout6) , .rd_addr(rd_addrout6) , 
        .valid_in(validP) , .wrdata(wrdataout6) , .wr_addr(wr_addrout6) , .wr_en(wr_enout6) , 
        .indata(outdataP[6]) , .inposition(outaddrP) , .numOfOutmaps(numOfOutmaps), 
        .layer_done_in(layer_doneP), .start(RELU5done), .finished(RELU6done), 
        .addr_beggining_index_in(addr_beggining5), .datasize(datasize), .ksize_side(ksize_side),
        .wrdata_beggining(wrdata_beggining6), .wr_en_beggining(wr_en_beggining6), 
        .addr_beggining_index_out(addr_beggining6), .dataposition(dataposition6));

    relu_accum #(7) ra7(.clk(clk) , .reset(controlled_reset) , .rddata(rddataout7) , .rd_addr(rd_addrout7) , 
        .valid_in(validP) , .wrdata(wrdataout7) , .wr_addr(wr_addrout7) , .wr_en(wr_enout7) , 
        .indata(outdataP[7]) , .inposition(outaddrP) , .numOfOutmaps(numOfOutmaps), 
        .layer_done_in(layer_doneP), .start(RELU6done), .finished(RELU7done), 
        .addr_beggining_index_in(addr_beggining6), .datasize(datasize), .ksize_side(ksize_side),
        .wrdata_beggining(wrdata_beggining7), .wr_en_beggining(wr_en_beggining7), 
        .addr_beggining_index_out(addr_beggining7), .dataposition(dataposition7));

    always_comb begin
        if(layer_doneP) begin
            if(1'b1 & !RELU0done) begin
                addr_for_input_data=addr_beggining0;
                wr_en_for_input_data=wr_en_beggining0;
                wrdata_for_input_data=wrdata_beggining0; 
                wrposition_for_input_data=dataposition0;
                done_translating=0;
            end else if(RELU0done & !RELU1done) begin
                addr_for_input_data=addr_beggining1;
                wr_en_for_input_data=wr_en_beggining1;
                wrdata_for_input_data=wrdata_beggining1; 
                wrposition_for_input_data=dataposition1;
                done_translating=0;
            end else if(RELU1done & !RELU2done) begin
                addr_for_input_data=addr_beggining2;
                wr_en_for_input_data=wr_en_beggining2;
                wrdata_for_input_data=wrdata_beggining2; 
                wrposition_for_input_data=dataposition2;
                done_translating=0;
            end else if(RELU2done & !RELU3done) begin
                addr_for_input_data=addr_beggining3;
                wr_en_for_input_data=wr_en_beggining3;
                wrdata_for_input_data=wrdata_beggining3; 
                wrposition_for_input_data=dataposition3;
                done_translating=0;
            end else if(RELU3done & !RELU4done) begin
                addr_for_input_data=addr_beggining4;
                wr_en_for_input_data=wr_en_beggining4;
                wrdata_for_input_data=wrdata_beggining4; 
                wrposition_for_input_data=dataposition4;
                done_translating=0;
            end else if(RELU4done & !RELU5done) begin
                addr_for_input_data=addr_beggining5;
                wr_en_for_input_data=wr_en_beggining5;
                wrdata_for_input_data=wrdata_beggining5; 
                wrposition_for_input_data=dataposition5;
                done_translating=0;
            end else if(RELU5done & !RELU6done) begin
                addr_for_input_data=addr_beggining6;
                wr_en_for_input_data=wr_en_beggining6;
                wrdata_for_input_data=wrdata_beggining6; 
                wrposition_for_input_data=dataposition6;
                done_translating=0;
            end else if(RELU6done & !RELU7done) begin
                addr_for_input_data=addr_beggining7;
                wr_en_for_input_data=wr_en_beggining7;
                wrdata_for_input_data=wrdata_beggining7; 
                wrposition_for_input_data=dataposition7;
                done_translating=0;
            end else begin
                addr_for_input_data=recent_addr;
                wr_en_for_input_data=last_wr_en;
                wrdata_for_input_data=32'hFFFFFFFF; 
                wrposition_for_input_data=32'hFFFFFFFF;
                done_translating=1;
            end
        end else begin
            addr_for_input_data=addrF;
            wr_en_for_input_data=1'b0;
            wrdata_for_input_data=0; 
            wrposition_for_input_data=0;
            done_translating=0;
        end

    end



    always_ff @(posedge clk) begin
        if(reset) begin
            next_state<=0;
            controlled_reset<=1;
            PL_need_data<=1;
            PL_need_weights<=1;
            numOfExecutedLayers<=0;
        end else begin

            ////////////////////////////////////////band-aid logic for writing stopping word on feedback
            if(done_translating) begin
                last_wr_en<=0;
            end else begin
                last_wr_en<=1;
                recent_addr<=addr_for_input_data+4;
            end

            ///////////////////////////////////////FSM
            if(next_state==0) begin
                if(PS_loading) begin
                    next_state<=0;//redundant
                    PL_need_weights<=0;
                    PL_need_data<=0;
                end else if(!PL_need_weights & !PL_need_data) begin
                    next_state<=1;
                    controlled_reset<=0;//allows units to begin
                    ksize_side<=ksize_side_PS;
                    datasize<=datasize_PS;
                    numOfOutmaps<=numOfOutmaps_PS;
                    numOfExecutedLayers<=0;
                end
            end else if(next_state==1) begin
                controlled_reset<=0;
                if(layer_doneP & layer_doneF & !controlled_reset) begin
                    next_state<=2;
                    numOfExecutedLayers<=numOfExecutedLayers+1;
                    PL_need_weights<=1;
                end
            end else if(next_state==2) begin
                if(!done_translating) begin
                    if(PS_loading)
                        PL_need_weights<=0;
                end else if(numOfExecutedLayers==numOfExecutedLayers_PS) begin
                    PL_need_weights<=1;
                    PL_need_data<=1;
                    next_state<=0;
                    controlled_reset<=1;
                end else if(!PS_loading) begin//ensures the next layer will compute if weights have been loaded
                    ksize_side<=ksize_side_PS;
                    datasize<=datasize_PS;
                    numOfOutmaps<=numOfOutmaps_PS;
                    controlled_reset<=1;//reset units when starting a new layer
                    next_state<=1;
                end
            end

        end 
    end

endmodule
		











