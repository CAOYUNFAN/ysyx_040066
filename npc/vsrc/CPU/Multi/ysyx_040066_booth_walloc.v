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
    wire [1429:0] part11,part12,part13;//130*11
    ysyx_040066_switch switch(.part_group(part_group),.sw_group1(part11),.sw_group2(part12),.sw_group3(part13));
    //always @(*) if(~clk)$display("CALC_NOW:%d %d",x,y);
    //walloc_tree
    //first
    wire [1429:0] wt_cout1,wt_s1;//11*130
    assign wt_cout1 = ( part11 & part12 ) | ( part11 & part13 ) | ( part12 & part13 );
    assign wt_s1= part11 ^ part12 ^ part13 ;
    /*always @(*) begin
        if(~clk) $display("11:%b %b %b,%b %b",part11[32:0],part12[32:0],part13[32:0],wt_cout1[32:0],wt_s1[32:0]);
    end*/

    //second
    wire [909:0] wt_cout2,wt_s2,part21,part22,part23; //7*130 22
    assign {part21[6:0],part22[6:0],part23[6:0]}={wt_s1[10:0],part_cout[9:0]};
    genvar x2;
    generate for(x2=1;x2<130;x2=x2+1) begin
        assign {part21[x2*7+6:x2*7],part22[x2*7+6:x2*7],part23[x2*7+6:x2*7]}={
            wt_s1[x2*11+10:x2*11],
            wt_cout1[x2*11+9-11:x2*11-11]
            };
    end endgenerate
    assign wt_cout2 = ( part21 & part22 ) | ( part21 & part23 ) | ( part22 & part23 );
    assign wt_s2= part21 ^ part22 ^ part23 ;
    /*always @(*) begin
        if(~clk) $display("22:%b %b %b,%b %b",part21[32:0],part22[32:0],part23[32:0],wt_cout2[32:0],wt_s2[32:0]);
    end*/

    //third
    wire [649:0] wt_cout3,wt_s3,part31,part32,part33; //5*130 15
    assign {part31[4:0],part32[4:0],part33[4:0]}={wt_s2[6:0],part_cout[17:10]};
    genvar x3;
    generate for(x3=1;x3<130;x3=x3+1) begin
        assign {part31[x3*5+4:x3*5],part32[x3*5+4:x3*5],part33[x3*5+4:x3*5]}={
            wt_s2[x3*7+6:x3*7],
            wt_cout1[x3*11+10-11],wt_cout2[x3*7+6-7:x3*7-7]
            };
    end endgenerate
    assign wt_cout3 = ( part31 & part32 ) | ( part31 & part33 ) | ( part32 & part33 );
    assign wt_s3= part31 ^ part32 ^ part33 ;
    /*always @(*) begin
        if(~clk) $display("33:%b %b %b,%b %b",part31[32:0],part32[32:0],part33[32:0],wt_cout3[32:0],wt_s3[32:0]);
    end*/

    //fourth
    wire [389:0] wt_cout4,wt_s4,part41,part42,part43; //3*130 10
    genvar x4;
    assign {part41[2:0],part42[2:0],part43[2:0]}={wt_s3[4:0],part_cout[21:18]};
    generate for(x4=1;x4<130;x4=x4+1) begin
        assign {part41[x4*3+2:x4*3],part42[x4*3+2:x4*3],part43[x4*3+2:x4*3]}={
            wt_s3[x4*5+4:x4*5],
            wt_cout3[x4*5+3-5:x4*5-5]
            };
    end endgenerate
    assign wt_cout4 = ( part41 & part42 ) | ( part41 & part43 ) | ( part42 & part43 );
    assign wt_s4= part41 ^ part42 ^ part43 ;
    /*always @(*) begin
        if(~clk) $display("44:%b %b %b,%b %b",part41[32:0],part42[32:0],part43[32:0],wt_cout4[32:0],wt_s4[32:0]);
    end*/

    //fifth
    wire [259:0] wt_cout5,wt_s5,part51,part52,part53;//2*130 7
    assign {part51[1:0],part52[1:0],part53[1:0]}={wt_s4[2:0],part_cout[24:22]};
    genvar x5;
    generate for(x5=1;x5<130;x5=x5+1) begin
        assign {part51[x5*2+1:x5*2],part52[x5*2+1:x5*2],part53[x5*2+1:x5*2]}={
            wt_s4[x5*3+2:x5*3],
            wt_cout3[x5*5+4-5],wt_cout4[x5*3+1-3:x5*3-3]
            };
    end endgenerate
    assign wt_cout5 = ( part51 & part52 ) | ( part51 & part53 ) | ( part52 & part53 );
    assign wt_s5= part51 ^ part52 ^ part53 ;
    /*always @(*) begin
        if(~clk) $display("55:%b %b %b,%b %b",part51[32:0],part52[32:0],part53[32:0],wt_cout5[32:0],wt_s5[32:0]);
    end*/

    //sixth
    wire [129:0] wt_cout6,wt_s6,part61,part62,part63;//5
    genvar x6;
    assign {part61[0],part62[0],part63[0]}={wt_s5[1:0],part_cout[25]};
    generate for(x6=1;x6<130;x6=x6+1) begin 
        assign {part61[x6],part62[x6],part63[x6]}={
            wt_s5[x6*2+1:x6*2],
            wt_cout4[x6*3+2-3]
            };
    end endgenerate
    assign wt_cout6 = ( part61 & part62 ) | ( part61 & part63 ) | ( part62 & part63 );
    assign wt_s6= part61 ^ part62 ^ part63 ;
    /*always @(*) begin
        if(~clk) $display("66:%b %b %b,%b %b",part61[32:0],part62[32:0],part63[32:0],wt_cout6[32:0],wt_s6[32:0]);
    end*/

    //seventh
    wire [129:0] wt_cout7,wt_s7,part71,part72,part73;//4
    genvar x7;
    assign {part71[0],part72[0],part73[0]}={wt_s6[0],part_cout[27:26]};
    generate for(x7=1;x7<130;x7=x7+1) begin
        assign {part71[x7],part72[x7],part73[x7]}={
            wt_s6[x7],
            wt_cout5[x7*2+1-2:x7*2-2]
            };
    end endgenerate
    assign wt_cout7 = ( part71 & part72 ) | ( part71 & part73 ) | ( part72 & part73 );
    assign wt_s7= part71 ^ part72 ^ part73 ;
    /*always @(*) begin
        if(~clk) $display("77:%b %b %b,%b %b",part71[32:0],part72[32:0],part73[32:0],wt_cout7[32:0],wt_s7[32:0]);
    end*/

    //finial    
    wire [129:0] wt_c;
    wire [129:0] wt_s,partf1,partf2,partf3;
    genvar xf;
    assign {partf1[0],partf2[0],partf3[0]}={wt_s7[0],part_cout[29:28]};
    generate for(xf=1;xf<130;xf=xf+1) begin
        assign {partf1[xf],partf2[xf],partf3[xf]}={
            wt_s7[xf],
            wt_cout6[xf-1],wt_cout7[xf-1]
            };
    end endgenerate
    assign wt_c=( partf1 & partf2 ) | ( partf1 & partf3 ) | ( partf2 & partf3 );
    assign wt_s= partf1 ^ partf2 ^ partf3;
    /*always @(*) begin
        if(~clk) $display("ff:%b %b %b,%b %b",partf1[32:0],partf2[32:0],partf3[32:0],wt_c[32:0],wt_s[32:0]);
    end*/

    reg is_long;
    reg is_w_native;
    reg [129:0] wt_c_native;
    reg [129:0] wt_s_native;
    reg [1:0] part_cout_native;

    always @(posedge clk) if(~block) begin
        is_long<=ALUctr[0]||ALUctr[1];
        is_w_native<=is_w;
        wt_c_native<={wt_c[128:0],part_cout[30]};
        wt_s_native<=wt_s;
        part_cout_native[1]<=part_cout[32]||part_cout[31];
        part_cout_native[0]<=part_cout[32]^part_cout[31];
    end

    wire [129:0] final_line;
    assign final_line=wt_c_native+wt_s_native+{128'b0,part_cout_native};
    assign result=is_long?final_line[127:64]:(is_w_native?{{32{final_line[31]}},final_line[31:0]}:final_line[63:0]);
    //always @(*) begin
        //if(~clk) $display("final_line=%h",final_line);
    //end
endmodule
