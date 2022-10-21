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
    wire [10:0] first_s;
    ysyx_040066_csa csa00(.src(src_in[32:30]),.cout(cout_group1[10]),.s(first_s[10]));
    ysyx_040066_csa csa01(.src(src_in[29:27]),.cout(cout_group1[ 9]),.s(first_s[ 9]));
    ysyx_040066_csa csa02(.src(src_in[26:24]),.cout(cout_group1[ 8]),.s(first_s[ 8]));
    ysyx_040066_csa csa03(.src(src_in[23:21]),.cout(cout_group1[ 7]),.s(first_s[ 7]));
    ysyx_040066_csa csa04(.src(src_in[20:18]),.cout(cout_group1[ 6]),.s(first_s[ 6]));
    ysyx_040066_csa csa05(.src(src_in[17:15]),.cout(cout_group1[ 5]),.s(first_s[ 5]));
    ysyx_040066_csa csa06(.src(src_in[14:12]),.cout(cout_group1[ 4]),.s(first_s[ 4]));
    ysyx_040066_csa csa07(.src(src_in[11: 9]),.cout(cout_group1[ 3]),.s(first_s[ 3]));
    ysyx_040066_csa csa08(.src(src_in[ 8: 6]),.cout(cout_group1[ 2]),.s(first_s[ 2]));
    ysyx_040066_csa csa09(.src(src_in[ 5: 3]),.cout(cout_group1[ 1]),.s(first_s[ 1]));
    ysyx_040066_csa csa0a(.src(src_in[ 2: 0]),.cout(cout_group1[ 0]),.s(first_s[ 0]));

    //second
    wire [6:0] second_s;
    ysyx_040066_csa csa10(.src(first_s[10: 8]),.cout(cout_group2[ 6]),.s(second_s[6]));
    ysyx_040066_csa csa11(.src(first_s[ 7: 5]),.cout(cout_group2[ 5]),.s(second_s[5]));
    ysyx_040066_csa csa12(.src(first_s[ 4: 2]),.cout(cout_group2[ 4]),.s(second_s[4]));
    ysyx_040066_csa csa13(.src({first_s[1:0],cin1[10]}),.cout(cout_group2[ 3]),.s(second_s[3]));
    ysyx_040066_csa csa14(.src(cin1[ 9: 7]),.cout(cout_group2[ 2]),.s(second_s[2]));
    ysyx_040066_csa csa15(.src(cin1[ 6: 4]),.cout(cout_group2[ 1]),.s(second_s[1]));
    ysyx_040066_csa csa16(.src(cin1[ 3: 1]),.cout(cout_group2[ 0]),.s(second_s[0]));

    //third
    wire [4:0] third_s;
    ysyx_040066_csa csa20(.src(second_s[6:4]),.cout(cout_group3[4]),.s(third_s[4]));
    ysyx_040066_csa csa21(.src(second_s[3:1]),.cout(cout_group3[3]),.s(third_s[3]));
    ysyx_040066_csa csa22(.src({second_s[0],cin1[0],cin2[6]}),.cout(cout_group3[2]),.s(third_s[2]));
    ysyx_040066_csa csa23(.src(cin2[5:3]),.cout(cout_group3[1]),.s(third_s[1]));
    ysyx_040066_csa csa24(.src(cin2[2:0]),.cout(cout_group3[0]),.s(third_s[0]));

    //fourth
    wire [2:0] fourth_s;
    ysyx_040066_csa csa30(.src(third_s[4:2]),.cout(cout_group4[2]),.s(fourth_s[2]));
    ysyx_040066_csa csa31(.src({third_s[1:0],cin3[4]}),.cout(cout_group4[1]),.s(fourth_s[1]));
    ysyx_040066_csa csa32(.src(cin3[3:1]),.cout(cout_group4[0]),.s(fourth_s[0]));

    //fifth
    wire [1:0] fifth_s;
    ysyx_040066_csa csa40(.src(fourth_s[2:0]),.cout(cout_group5[1]),.s(fifth_s[1]));
    ysyx_040066_csa csa41(.src({cin3[0],cin4[2:1]}),.cout(cout_group5[0]),.s(fifth_s[0]));

    //sixth
    wire sixth_s;
    ysyx_040066_csa csa50(.src({fifth_s,cin4[0]}),.cout(cout_group6),.s(sixth_s));

    //seventh
    wire seventh_s;
    ysyx_040066_csa csa60(.src({sixth_s,cin5[1:0]}),.cout(cout_group7),.s(seventh_s));

    //final
    ysyx_040066_csa csa70(.src({seventh_s,cin6,cin7}),.cout(cout),.s(s));
endmodule

module ysyx_040066_csa(
    input [2:0] src,
    output cout,s
);
    assign s=src[0]^src[1]^src[2];
    assign cout=(src[0]&&src[1])||(src[0]&&src[2])||(src[1]&&src[2]);
endmodule
