module ysyx_040066 (
    input                               clock,
    input                               reset,
    input                               io_interrupt,
    output done,error,valid,


    input                               io_master_awready,              
    output                              io_master_awvalid,
    output [31:0]                       io_master_awaddr,
    output [3:0]                        io_master_awid,
    output [7:0]                        io_master_awlen,
    output [2:0]                        io_master_awsize,
    output [1:0]                        io_master_awburst,

    input                               io_master_wready,                
    output                              io_master_wvalid,
    output [63:0]                       io_master_wdata,
    output [7:0]                        io_master_wstrb,
    output                              io_master_wlast,
    
    output                              io_master_bready,                
    input                               io_master_bvalid,
    input  [1:0]                        io_master_bresp,                 
    input  [3:0]                        io_master_bid,

    input                               io_master_arready,                
    output                              io_master_arvalid,
    output [31:0]                       io_master_araddr,
    output [3:0]                        io_master_arid,
    output [7:0]                        io_master_arlen,
    output [2:0]                        io_master_arsize,
    output [1:0]                        io_master_arburst,
    
    output                              io_master_rready,                 
    input                               io_master_rvalid,                
    input  [1:0]                        io_master_rresp,
    input  [63:0]                       io_master_rdata,
    input                               io_master_rlast,
    input  [3:0]                        io_master_rid,

    output [5:0]                        io_sram0_addr,
    output                              io_sram0_cen,
    output                              io_sram0_wen,
    output [127:0]                      io_sram0_wmask,
    output [127:0]                      io_sram0_wdata,
    input  [127:0]                      io_sram0_rdata,
    output [5:0]                        io_sram1_addr,
    output                              io_sram1_cen,
    output                              io_sram1_wen,
    output [127:0]                      io_sram1_wmask,
    output [127:0]                      io_sram1_wdata,
    input  [127:0]                      io_sram1_rdata,
    output [5:0]                        io_sram2_addr,
    output                              io_sram2_cen,
    output                              io_sram2_wen,
    output [127:0]                      io_sram2_wmask,
    output [127:0]                      io_sram2_wdata,
    input  [127:0]                      io_sram2_rdata,
    output [5:0]                        io_sram3_addr,
    output                              io_sram3_cen,
    output                              io_sram3_wen,
    output [127:0]                      io_sram3_wmask,
    output [127:0]                      io_sram3_wdata,
    input  [127:0]                      io_sram3_rdata,
    output [5:0]                        io_sram4_addr,
    output                              io_sram4_cen,
    output                              io_sram4_wen,
    output [127:0]                      io_sram4_wmask,
    output [127:0]                      io_sram4_wdata,
    input  [127:0]                      io_sram4_rdata,
    output [5:0]                        io_sram5_addr,
    output                              io_sram5_cen,
    output                              io_sram5_wen,
    output [127:0]                      io_sram5_wmask,
    output [127:0]                      io_sram5_wdata,
    input  [127:0]                      io_sram5_rdata,
    output [5:0]                        io_sram6_addr,
    output                              io_sram6_cen,
    output                              io_sram6_wen,
    output [127:0]                      io_sram6_wmask,
    output [127:0]                      io_sram6_wdata,
    input  [127:0]                      io_sram6_rdata,
    output [5:0]                        io_sram7_addr,
    output                              io_sram7_cen,
    output                              io_sram7_wen,
    output [127:0]                      io_sram7_wmask,
    output [127:0]                      io_sram7_wdata,
    input  [127:0]                      io_sram7_rdata,

    
    output io_slave_awready,
    input io_slave_awvalid,
    input [31:0] io_slave_awaddr,
    input [3:0] io_slave_awid,
    input [7:0] io_slave_awlen,
    input [2:0] io_slave_awsize,
    input [1:0] io_slave_awburst,

    output io_slave_wready,
    input io_slave_wvalid,
    input [63:0] io_slave_wdata,
    input [7:0] io_slave_wstrb,
    input io_slave_wlast,

    input io_slave_bready,
    output io_slave_bvalid,
    output [1:0] io_slave_bresp,
    output [3:0] io_slave_bid,

    output io_slave_arready,
    input io_slave_arvalid,
    input [31:0] io_slave_araddr,
    input [3:0] io_slave_arid,
    input [7:0] io_slave_arlen,
    input [2:0] io_slave_arsize,
    input [1:0] io_slave_arburst,

    input io_slave_rready,
    output io_slave_rvalid,
    output [1:0] io_slave_rresp,
    output [63:0] io_slave_rdata,
    output io_slave_rlast,
    output [3:0] io_slave_rid
);
    //dummy for slave
    assign io_slave_awready=0;
    assign io_slave_wready=0;
    assign io_slave_bvalid=0;
    assign io_slave_bresp=2'b11;
    assign io_slave_bid={4{1'b0}};
    assign io_slave_arready=0;
    assign io_slave_rvalid=0;
    assign io_slave_rresp=2'b11;
    assign io_slave_rdata=64'b0;
    assign io_slave_rlast=0;
    assign io_slave_rid={4{1'b0}};

    reg [63:0] rd_data;
    reg [63:0] ins_data;
    wire [511:0] wr_data;

    wire ins_req,ins_burst,ins_ready,ins_err,ins_last;
    wire [63:0] ins_addr;

    wire rd_req,rd_burst,rd_ready,rd_err,rd_last;
    wire [2:0] rd_len;
    wire [63:0] rd_addr;

    wire wr_req,wr_burst,wr_ready,wr_err;
    wire [2:0] wr_len;
    wire [7:0] wr_mask;
    wire [63:0] wr_addr;

    wire [127:0] ram_Q [7:0];
    wire [127:0] ram_D [7:0];
    wire [127:0] ram_BWEN [1:0];
    wire [5:0] ram_A [1:0];
    wire ram_WEN [1:0];

    wire rst; assign rst=reset;
    wire clk; assign clk=clock;


    ysyx_040066_top top(
        .clk(clock),.rst(rst),.done(done),.error(error),.valid(valid),
        .ins_req(ins_req),.ins_burst(ins_burst),.ins_addr(ins_addr),.ins_last(ins_last),
        .ins_ready(ins_ready),.ins_err(ins_err),.ins_data(ins_data),

        .rd_req(rd_req),.rd_burst(rd_burst),.rd_len(rd_len),.rd_addr(rd_addr),.rd_last(rd_last),
        .rd_ready(rd_ready),.rd_err(rd_err),.rd_data(rd_data),

        .wr_req(wr_req),.wr_burst(wr_burst),.wr_len(wr_len),.wr_addr(wr_addr),
        .wr_ready(wr_ready),.wr_err(wr_err),.wr_mask(wr_mask),.wr_data(wr_data),

        .ram_Q(ram_Q),.ram_D(ram_D),.ram_BWEN(ram_BWEN),.ram_A(ram_A),.ram_WEN(ram_WEN)
    );

    `ifdef WORKBENCH
    genvar x;generate for(x=0;x<8;x=x+1) begin:sram
        S011HD1P_X32Y2D128_BW ram(
            .CLK(clk),.CEN(0),
            .WEN(ram_WEN[x<4?0:1]),.BWEN(ram_BWEN[x<4?0:1]),.A(ram_A[x<4?0:1]),
            .Q(ram_Q[x]),.D(ram_D[x])
        );
    end endgenerate
    `else
    assign io_sram0_addr=ram_A[0];
    assign io_sram0_cen=0;
    assign io_sram0_wen=ram_WEN[0];
    assign io_sram0_wmask=ram_BWEN[0];
    assign io_sram0_wdata=ram_D[0];
    assign ram_Q[0]=io_sram0_rdata;
    assign io_sram1_addr=ram_A[0];
    assign io_sram1_cen=0;
    assign io_sram1_wen=ram_WEN[0];
    assign io_sram1_wmask=ram_BWEN[0];
    assign io_sram1_wdata=ram_D[1];
    assign ram_Q[1]=io_sram1_rdata;
    assign io_sram2_addr=ram_A[0];
    assign io_sram2_cen=0;
    assign io_sram2_wen=ram_WEN[0];
    assign io_sram2_wmask=ram_BWEN[0];
    assign io_sram2_wdata=ram_D[2];
    assign ram_Q[2]=io_sram2_rdata;
    assign io_sram3_addr=ram_A[0];
    assign io_sram3_cen=0;
    assign io_sram3_wen=ram_WEN[0];
    assign io_sram3_wmask=ram_BWEN[0];
    assign io_sram3_wdata=ram_D[3];
    assign ram_Q[3]=io_sram3_rdata;
    assign io_sram4_addr=ram_A[1];
    assign io_sram4_cen=0;
    assign io_sram4_wen=ram_WEN[1];
    assign io_sram4_wmask=ram_BWEN[1];
    assign io_sram4_wdata=ram_D[4];
    assign ram_Q[4]=io_sram4_rdata;
    assign io_sram5_addr=ram_A[1];
    assign io_sram5_cen=0;
    assign io_sram5_wen=ram_WEN[1];
    assign io_sram5_wmask=ram_BWEN[1];
    assign io_sram5_wdata=ram_D[5];
    assign ram_Q[5]=io_sram5_rdata;
    assign io_sram6_addr=ram_A[1];
    assign io_sram6_cen=0;
    assign io_sram6_wen=ram_WEN[1];
    assign io_sram6_wmask=ram_BWEN[1];
    assign io_sram6_wdata=ram_D[6];
    assign ram_Q[6]=io_sram6_rdata;
    assign io_sram7_addr=ram_A[1];
    assign io_sram7_cen=0;
    assign io_sram7_wen=ram_WEN[1];
    assign io_sram7_wmask=ram_BWEN[1];
    assign io_sram7_wdata=ram_D[7];
    assign ram_Q[7]=io_sram7_rdata;
    `endif

    // ------------------State Machine------------------
    //read
    //ins ID:1111,rd ID:0000
    reg ins_ar_done,rd_ar_done; reg [2:0] done_status;//[0]:last,[1]:which,[2]:onecircle
    reg [63:0] rdata;
    reg [1:0] rresp;
    reg [3:0] rid;

    wire ar_ins,ar_rd,ins_done,rd_done;
    assign ar_ins=ins_req&&~ins_ar_done;
    assign ar_rd=~ar_ins&&rd_req&&~rd_ar_done;
    assign ins_done=done_status[0]&&done_status[1];
    assign rd_done=done_status[0]&&~done_status[1];
    always @(posedge clk) begin
        if(rst) {ins_ar_done,rd_ar_done}<=2'b00;
        else begin
            if(ar_ins && io_master_arready && io_master_arvalid) ins_ar_done<=1;
            else if(ins_done) ins_ar_done<=0;

            if(ar_rd  && io_master_arready && io_master_arvalid) rd_ar_done <=1;
            else if(rd_done ) rd_ar_done <=0;
        end
    end
    always @(posedge clk) begin
        if(rst) done_status<=3'b00;
        else if(io_master_rready&&io_master_rvalid) begin
            rdata<=io_master_rdata;
            rid<=io_master_rid;
            rresp<=io_master_rresp;
            done_status<={1'b1,io_master_rid[0],io_master_rlast};
        end else done_status<=3'b00;
    end
    assign ins_ready=rid[0]&&done_status[2];
    assign rd_ready=~rid[0]&&done_status[2];
    assign ins_data=rdata;         assign rd_data=rdata;
    assign ins_last=done_status[0];assign rd_last=done_status[0];
    assign ins_err =rresp[1];      assign rd_err =rresp[1];

    //write
    reg [2:0] count;
    reg aw_done,w_done,b_done;
    reg [1:0] bresp;
    always @(posedge clk) begin
        if(rst) aw_done<=0;
        else if(io_master_awready && io_master_awvalid ) aw_done<=1;
        else if(b_done) aw_done<=0;
    end
    always @(posedge clk) begin
        if(rst) w_done<=0;
        else if(io_master_wready  && io_master_wvalid  ) w_done<=io_master_wlast;
        else if(b_done) w_done<=0;
    end
    always @(posedge clk) begin
        if(rst) count<=3'b0;
        else if(io_master_wready  && io_master_wvalid  && wr_burst) count<=count+3'b1;
    end
    always @(posedge clk) begin
        if(~rst&&io_master_bready && io_master_bvalid) begin
            bresp<=io_master_bresp;
            b_done<=1;
        end
        else b_done<=0;
    end
    assign wr_err=bresp[1];
    assign wr_ready=b_done;
    wire [63:0] wr_r_data [7:0];
    genvar i;generate for(i=0;i<8;i++)
        assign wr_r_data[i]=wr_data[i*64+63:i*64];
    endgenerate

    // ------------------Write Transaction------------------
    wire [3:0] axi_id              = {4{1'b0}};
    // ???????????????  ???????????????????????????????????????????????????????????????????????????
    assign io_master_awvalid   = wr_req&&~aw_done;
    assign io_master_awaddr    = wr_addr[31:0];
    assign io_master_awid      = axi_id;                                                                      //?????????????????????
    assign io_master_awlen     = wr_burst?8'h7:8'b0;
    assign io_master_awsize    = wr_burst?3'b011:wr_len;
    assign io_master_awburst   = 2'b01;                                                          //?????????????????????

    // ???????????????
    assign io_master_wvalid    = wr_req&&aw_done&&~w_done;
    assign io_master_wdata     = wr_r_data[count];
    assign io_master_wstrb     = wr_burst?8'hff:wr_mask;
    assign io_master_wlast     = ~wr_burst||(count==3'h7);                                                    //?????????????????????

    // ???????????????
    assign io_master_bready    = 1'b1;

    // ------------------Read Transaction------------------

    // Read address channel signals
    assign io_master_arvalid   = ar_rd||ar_ins;
    assign io_master_araddr    = ar_ins?ins_addr[31:0]:rd_addr[31:0];
    assign io_master_arid      = {(4){ar_ins}};                                                                           //?????????????????????                        
    assign io_master_arlen     = (ar_ins&&ins_burst||ar_rd&&rd_burst)?8'h7:8'b0;                                                                          
    assign io_master_arsize    = ar_ins?(ins_burst?3'b011:3'b010):(rd_burst?3'b011:rd_len);
    assign io_master_arburst   = 2'b01;
    
    // Read data channel signals
    assign io_master_rready    = 1'b1;


    `ifdef INSTR
    always @(*) if(~clk&&reset) begin
        $display("axi: wr_req=%b,aw=%b,w=%b,count=%b,b=%b,burst=%b,addr=%h",wr_req,aw_done,w_done,count,b_done,wr_burst,wr_addr[31:0]);
        $display("axi:ins_req=%b,ar=%b,r=%b,is_ins=%b,size=%b,addr=%h",ins_req,ins_ar_done,ins_done,ar_ins,io_master_arsize,ins_addr[31:0]);
        $display("axi: rd_req=%b,ar=%b,r=%b,is_rd =%b,len=%b,addr=%h",rd_req,rd_ar_done,rd_done,ar_rd,io_master_arlen,rd_addr[31:0]);
    end
    `endif
endmodule
