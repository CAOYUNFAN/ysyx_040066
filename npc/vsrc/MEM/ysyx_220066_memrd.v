module ysyx_220066_memrd (
    input clk,rst,MemRd,
    input [63:0] addr,
    output reg [63:0] data,
    output ready,error,
    output reg valid
);
    assign ready=1;
    import "DPI-C" function void data_read(
        input longint raddr, output longint rdata, output byte valid
    );
    
    always @(posedge clk) valid<=~rst;
    reg [7:0] error_native;
    always @(posedge clk) begin
        data_read(addr,data,error_native);
    end
    assign error=error_native[0];
endmodule


module ysyx_220066_imem (
    input clk,rst,

    input [63:0] pc,
    output [31:0] instr,
    output ready,error,valid
);
    wire [63:0] instr_long;
    ysyx_220066_memrd imem(
        .clk(clk),.rst(rst),.MemRd(1),
        .ready(ready),.error(error),.valid(valid),
        .addr(pc),.data(instr_long)
    );

    assign instr=pc[2]?instr_long[63:32]:instr_long[31:0];
endmodule

module ysyx_220066_dmem_rd (
    input clk,rst,MemRd,
    input [63:0] addr,
    input [2:0] MemOp,
    output reg [63:0] data,
    output error,ready,valid
);
    wire [63:0] basic_data;
    ysyx_220066_memrd dmemrd(
        .clk(clk),.rst(rst),.MemRd(MemRd),
        .ready(ready),.error(error),.valid(valid),
        .addr(addr),.data(basic_data)
    );

    reg [7:0] b_Rd;reg [15:0] h_Rd;reg [31:0] w_Rd;
    always @(*) begin
        case(addr[2:0])
            3'b000:begin b_Rd=basic_data[ 7: 0]; h_Rd=basic_data[15: 0]; w_Rd=basic_data[31: 0];end
            3'b001:begin b_Rd=basic_data[15: 8]; h_Rd=basic_data[15: 0]; w_Rd=basic_data[31: 0];end
            3'b010:begin b_Rd=basic_data[23:16]; h_Rd=basic_data[31:16]; w_Rd=basic_data[31: 0];end
            3'b011:begin b_Rd=basic_data[31:24]; h_Rd=basic_data[31:16]; w_Rd=basic_data[31: 0];end
            3'b100:begin b_Rd=basic_data[39:32]; h_Rd=basic_data[47:32]; w_Rd=basic_data[63:32];end
            3'b101:begin b_Rd=basic_data[47:40]; h_Rd=basic_data[47:32]; w_Rd=basic_data[63:32];end
            3'b110:begin b_Rd=basic_data[55:48]; h_Rd=basic_data[63:48]; w_Rd=basic_data[63:32];end
            3'b111:begin b_Rd=basic_data[63:56]; h_Rd=basic_data[63:48]; w_Rd=basic_data[63:32];end
        endcase
    end

    always @(*) begin
        case(MemOp)
        3'b100: data={56'h0,b_Rd};
        3'b000: data={{56{b_Rd[7]}},b_Rd};
        3'b101: data={48'h0,h_Rd};
        3'b001: data={{48{h_Rd[15]}},h_Rd};
        3'b110: data={32'h0,w_Rd};
        3'b010: data={{32{w_Rd[31]}},w_Rd};
        default:data=basic_data;
        endcase
    //    $display("addr=%h,addr_low=%b",addr,addr[2:0]);
    //    $display("b=%h,h=%h,w=%h,q=%h,final=%h",b_Rd,h_Rd,w_Rd,basic_data,data);
    end

endmodule