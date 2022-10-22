module ysyx_040066_switch (
    input [4289:0] part_group,

    output [1429:0] sw_group1,sw_group2,sw_group3
);
    wire [129:0] po32,po31,po30,po29,po28,po27,po26,po25,po24,po23,po22,po21,po20,po19,po18,po17,po16,po15,po14,po13,po12,po11,po10,po09,po08,po07,po06,po05,po04,po03,po02,po01,po00;

    assign {po32,po31,po30,po29,po28,po27,po26,po25,po24,po23,po22,po21,po20,po19,po18,po17,po16,po15,po14,po13,po12,po11,po10,po09,po08,po07,po06,po05,po04,po03,po02,po01,po00}=part_group;

    genvar x;
    generate
        for(x=0;x<130;x=x+1) begin : genswitch
            assign sw_group1[x*11+10:x*11]={po32[x],po31[x],po30[x],po29[x],po28[x],po27[x],po26[x],po25[x],po24[x],po23[x],po22[x]};
            assign sw_group2[x*11+10:x*11]={po21[x],po20[x],po19[x],po18[x],po17[x],po16[x],po15[x],po14[x],po13[x],po12[x],po11[x]};
            assign sw_group3[x*11+10:x*11]={po10[x],po09[x],po08[x],po07[x],po06[x],po05[x],po04[x],po03[x],po02[x],po01[x],po00[x]};
        end
    endgenerate

endmodule
