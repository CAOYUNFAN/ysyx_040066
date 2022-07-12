module ysyx_220066_Wales (
    input [127:0] A,
    input [127:0] B,
    input [127:0] C,

    reg output [127:0] sum,
    reg output [127:0] add
);
    integer i;
    always @(*) begin
        for (i = 0; i<128; i=i+1) begin
            sum[i]=A[i]^B[i]^C[i];
            add[i]=(A[i]&&B[i])||(A[i]&&C[i])||(B[i]&&C[i]);
        end
    end
endmodule