#include <bits/stdc++.h>
using namespace std;

const char * table_1[]={
    "module ysyx_220066_generate(",
    "    input [65:0] sum_part [32:0],",
    "    input clk,",
    "    output [127:0] add_result",
    ")",
    "    wire [127:0] s_all;",
    "    wire [127:0] c_all;",
    "",
    NULL
};

const char * table_2[]={
    "",
    "    assign add_result=s_all+c_all;",
    "endmodule",
    "",
    NULL
};

int main(){
    freopen("ysyx_220066_generate.v","w",stdout);
    for(int i=0;table_1[i];i++) puts(table_1[i]);
    for(int i=0;i<128;i++){
        if(i!=128) printf("    wire [29:0] ctemp_%d;\n",i);
        printf("    ysyx_220066_WalesTree Tree_%d (\n",i);
        printf("        .clk(clk),.s(s_all[%d]),.c(c_all[%d]),\n",i,i);
        if(i!=128) printf("        .cout(ctemp_%d),\n",i);
        if(i!=0) printf("        .cin(ctemp_%d),\n",i);
        printf("        .num({");
        int j=0;
        for(int k=i;j<=32&&k>=0;j++,k-=2){
            if(k>65) printf("sum_part[%d][65]",j);
            if(k>=0&&k<=65) printf("sum_part[%d][%d]",j,k);
            if(j<32) printf(",");
        }
        if(j<32) printf("%d'b0",32-j);
        printf("})\n    );\n");
    }
    for(int i=0;table_2[i];i++) puts(table_2[i]);
}