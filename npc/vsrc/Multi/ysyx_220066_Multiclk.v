module ysyx_220066_Multiclk(
    input clk,
    input [1:0] mul_crt,
    input [63:0] rs1,
    input [63:0] rs2,
    
    output [127:0] result
)
    wire [65:0] rs2_ext;
    assign rs2_ext={{2{rs2[63]&&~mul_crt[2]}},rs2};
    
    wire [65:0] rs2_pos;
    wire [65:0] rs2_pos2;
    wire [65:0] rs2_neg;
    wire [65:0] rs2_neg2;
    assign rs2_pos=rs2_ext;
    assign rs2_pos2={rs2_ext[64:0],1'b0};
    assign rs2_neg=~rs2_ext+{65'b0,1};
    assign rs2_neg2={~rs2_ext[64:0],1'b1};

    wire [66:0] rs1_ext; 
    assign rs1_ext={{2{rs1[63]&&(mul_crt==2'b11)}},rs1,1'b0};
    
    reg [65:0] sum_part [32:0];
    integer i;
    always @(*) begin
        for(i=0;i<33;i=i+1) begin
            if(rs1_ext[i*2+2]) begin
                if(rs1_temp[i*2+1:i*2]==2'b00) 
                    sum_part[i]=66'b0;
                else if(rs1_temp[i*2+1:i*2]==2'b11)
                    sum_part[i]=rs2_pos2;
                else
                    sum_part[i]=rs2_pos;
            end else begin
                if(rs1_temp[i*2+1:i]==2'b00)
                    sum_part[i]=rs2_neg2;
                else if(rs1_temp[i*2+1:i]==2'b11)
                    sum_part[i]=66'b0;
                else
                    sum_part[i]=rs2_neg;
            end
        end
    end

    ysyx_220066_generate gen(
        .sum_part(sum_part),.clk(clk)
    );
    
endmodule

module ysyx_220066_WalesLine #(
    parameter  len=11
)(
    input [len*3-1:0] x,

);  
    reg [len-1:0] c;
    reg [len-1:0] y;
    integer i;
    always @(*) begin
        for (i = 0; i<len; i=i+1) begin
            y[i]=x[i*3+2]^x[i*3+1]^x[i*3];
            c[i]= x[i*3+2] && x[i*3+1] ||
                  x[i*3+2] && x[i*3  ] ||
                  x[i*3+1] && x[i*3];
        end
    end
endmodule

module ysyx_220066_WalesTree(
    input clk,
    input [32:0] num,
    input [29:0] cin,

    output [29:0] cout,
    output s,c
)
    //33
    ysyx_220066_WalesLine #(.len(11)) line_1(num);
    assign cout[10:0]=line_1.c;
    //22
    ysyx_220066_WalesLine #(.len(7)) line_2({line_1.y,cin[10:1]});
    assign cout[17:11]=line_2.c;
    //14+1
    ysyx_220066_WalesLine #(.len(5)) line_3({cin[0],line_2.y,cin[17:11]});
    assign cout[22:18]=line_3.c;
    //10
    ysyx_220066_WalesLine #(.len(3)) line_4({line_3.y,cin[22:19]});
    assign cout[25:23]=line_4.c;
    //6+1

    reg [2:0] line_4_sum;
    reg [3:0] cin_temp;
    always @(posedge clk) begin
        line_4_sum=line_4.y;
        cin_temp[2]=cin[18];
        cin_temp[1:0]=cin[25:24];
        cin_temp[3]=cin[23];
    end

    ysyx_220066_WalesLine #(.len(2)) line_5({cin_temp[2],line_4_sum,cin_temp[1:0]});
    assign cout[27:26]=line_5.c;
    //4+1
    ysyx_220066_WalesLine #(.len(1)) line_6({cin_temp[3],line_5.y});
    assign cout[28]=line_6.c;
    //2+2
    ysyx_220066_WalesLine #(.len(1)) line_7({cin[27:26],line_6.y});
    assign cout[29]=line_7.c;
    //2+1
    ysyx_220066_WalesLine #(.len(1)) line_8({cin[28],line_7.y,cin[29]});
    assign s=line_8.y;
    assign c=line_8.c;
endmodule