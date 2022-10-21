module ysyx_040066_booth_walloc(
    input clk,block,
    input [63:0] src1_in,//clk0
    input [63:0] src2_in,//clk0
    input [1:0] ALUctr_in,//clk0
    input [1:0] ALUctr,//clk1
    input is_w,//clk1

    output [63:0] result
);
    reg [129:0] x;
    reg [65:0] y;
    always @(posedge clk) if(~block) begin
        x[63:0]<=src1_in;
        x[129:64]<={66{src1_in[63]&&(ALUctr_in[1]^ALUctr_in[0])}};
        y[63:0]<=src2_in;
        y[65:64]<={2{src2_in[63]&&~ALUctr_in[1]}};
    end

    //pre_work
    wire [4289:0] part_group;
    wire [32:0] part_cout;
    ysyx_040066_walloc_prework part0(
        .src(x),.sel({y[1:0],1'b0}),
        .data(part_group[129:0]),.cout(part_cout[0])
    );

    genvar i;
    generate for(i=1;i<33;i=i+1) begin:gen_walloc_prework
        ysyx_040066_walloc_prework part(
            .src({x[129-2*i:0],{2*i{1'b0}}}),.sel(y[i*2+1:i*2-1]),
            .data(part_group[(i+1)*130-1:i*130]),.cout(part_cout[i])
        );
    end endgenerate
    
    //switch
    wire [4289:0] sw_group;
    ysyx_040066_switch switch(.part_group(part_group),.sw_group(sw_group));

    //walloc_tree
    wire [128:0] wt_c;
    wire [129:0] wt_s;
    wire [10:0] wt_cout1 [128:0];
    wire [6:0] wt_cout2 [128:0];
    wire [4:0] wt_cout3 [128:0];
    wire [2:0] wt_cout4 [128:0];
    wire [1:0] wt_cout5 [128:0];
    wire wt_cout6 [128:0];
    wire wt_cout7 [128:0];

    ysyx_040066_walloc_33bits walloc0(
        .src_in(sw_group[32:0]),
        .cin7(part_cout[29]),
        .cin6(part_cout[28]),
        .cin5(part_cout[27:26]),
        .cin4(part_cout[25:23]),
        .cin3(part_cout[22:18]),
        .cin2(part_cout[17:11]),
        .cin1(part_cout[10:0]),
        .cout_group7(wt_cout7[0]),
        .cout_group6(wt_cout6[0]),
        .cout_group5(wt_cout5[0]),
        .cout_group4(wt_cout4[0]),
        .cout_group3(wt_cout3[0]),
        .cout_group2(wt_cout2[0]),
        .cout_group1(wt_cout1[0])
        ,.s(wt_s[0]),.cout(wt_c[0])
    );

    genvar j;
    generate for(j=1;j<129;j=j+1) begin:gen_walloc_tree
        ysyx_040066_walloc_33bits walloc(
            .src_in(sw_group[(j+1)*33-1:j*33]),
            .cin7(wt_cout7[j-1]),
            .cin6(wt_cout6[j-1]),
            .cin5(wt_cout5[j-1]),
            .cin4(wt_cout4[j-1]),
            .cin3(wt_cout3[j-1]),
            .cin2(wt_cout2[j-1]),
            .cin1(wt_cout1[j-1]),
            .cout_group7(wt_cout7[j]),
            .cout_group6(wt_cout6[j]),
            .cout_group5(wt_cout5[j]),
            .cout_group4(wt_cout4[j]),
            .cout_group3(wt_cout3[j]),
            .cout_group2(wt_cout2[j]),
            .cout_group1(wt_cout1[j]),
            .s(wt_s[j]),.cout(wt_c[j])
        );
    end endgenerate

    wire unused_cout;
    ysyx_040066_walloc_33bits walloc129(
        .src_in(sw_group[4289:4257]),
        .cin7(wt_cout7[128]),
        .cin6(wt_cout6[128]),
        .cin5(wt_cout5[128]),
        .cin4(wt_cout4[128]),
        .cin3(wt_cout3[128]),
        .cin2(wt_cout2[128]),
        .cin1(wt_cout1[128]),
        .cout_group7(),
        .cout_group6(),
        .cout_group5(),
        .cout_group4(),
        .cout_group3(),
        .cout_group2(),
        .cout_group1(),
        .s(wt_s[129]),.cout(unused_cout)
    );

    reg is_long;
    reg is_w_native;
    reg [129:0] wt_c_native;
    reg [129:0] wt_s_native;
    reg [1:0] part_cout_native;

    always @(posedge clk) if(~block) begin
        is_long<=ALUctr[0]||ALUctr[1];
        is_w_native<=is_w;
        wt_c_native<={wt_c,part_cout[30]};
        wt_s_native<=wt_s;
        part_cout_native[1]<=part_cout[32]||part_cout[31];
        part_cout_native[0]<=part_cout[32]^part_cout[31];
        //$display("display:wt_c=%h,wt_s%h",wt_c,wt_s);
    end

    wire [129:0] final_line;
    assign final_line=wt_c_native+wt_s_native+{128'b0,part_cout_native};
    assign result=is_long?final_line[127:64]:(is_w_native?{{32{final_line[31]}},final_line[31:0]}:final_line[63:0]);
    //always @(*) begin
        //if(~clk) $display("final_line=%h",final_line);
    //end
endmodule
