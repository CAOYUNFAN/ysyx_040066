module ysyx_040066_walloc_33bits(
    input [32:0] src_in,
    input [10:0] cin1,
    input [6:0] cin2,
    input [4:0] cin3,
    input [2:0] cin4,
    input [1:0] cin5,
    input cin6,
    input cin7,

    output [10:0] cout_group1,
    output [6:0] cout_group2,
    output [4:0] cout_group3,
    output [2:0] cout_group4,
    output [1:0] cout_group5,
    output cout_group6,
    output cout_group7,

    output cout,s
);
    //first
    wire [10:0] s_1;
    wire [10:0] part1 [2:0];
    assign part1[0]=src_in[32:22];
    assign part1[1]=src_in[21:11];
    assign part1[2]=src_in[10:0];
    assign cout_group1=(part1[0]&part1[1])|(part1[0]&part1[2])|(part1[1]&part1[2]);
    assign s_1=part1[0]^part1[1]^part1[2];

    //second
    wire [6:0] s_2;
    wire [6:0] part2 [2:0];
    assign part2[0]=s_1[10:4];
    assign part2[1]={s_1[3:0],cin1[10:8]};
    assign part2[2]={cin1[7:1]};
    assign cout_group2=(part2[0]&part2[1])|(part2[0]&part2[2])|(part2[1]&part2[2]);
    assign s_2=part2[0]^part2[1]^part2[2];

    //third
    wire [4:0] s_3;
    wire [4:0] part3 [2:0];
    assign part3[0]=s_2[6:2];
    assign part3[1]={s_2[1:0],cin1[0],cin2[6:5]};
    assign part3[2]=cin2[4:0];
    assign cout_group3=(part3[0]&part3[1])|(part3[0]&part3[2])|(part3[1]&part3[2]);
    assign s_3=part3[0]^part3[1]^part3[2];

    //fourth
    wire [2:0] s_4;
    wire [2:0] part4 [2:0];
    assign part4[0]=s_3[4:2];
    assign part4[1]={s_3[1:0],cin3[4]};
    assign part4[2]=cin3[3:1];
    assign cout_group4=(part4[0]&part4[1])|(part4[0]&part4[2])|(part4[1]&part4[2]);
    assign s_4=part4[0]^part4[1]^part4[2];

    //fifth
    wire [1:0] s_5;
    wire [1:0] part5 [2:0];
    assign part5[0]=s_4[2:1];
    assign part5[1]={s_4[0],cin3[0]};
    assign part5[2]={cin4[2:1]};
    assign cout_group5=(part5[0]&part5[1])|(part5[0]&part5[2])|(part5[1]&part5[2]);
    assign s_5=part5[0]^part5[1]^part5[2];

    //sixth
    wire s_6;
    ysyx_040066_csa csa50(.src({s_5,cin4[0]}),.cout(cout_group6),.s(s_6));

    //seventh
    wire s_7;
    ysyx_040066_csa csa60(.src({s_6,cin5[1:0]}),.cout(cout_group7),.s(s_7));

    //final
    ysyx_040066_csa csa70(.src({s_7,cin6,cin7}),.cout(cout),.s(s));
endmodule

module ysyx_040066_csa(
    input [2:0] src,
    output cout,s
);
    assign {s,cout}={1'b0,src[0]}+{1'b0,src[1]}+{1'b0,src[2]};
endmodule