// Read-Only memory interface
interface mem_ro_itf #(
    parameter DATA_WIDTH = 256,     // data bus width
    parameter ADDR_WIDTH = 32       // addresss width
);

    logic resp;
    logic read;
    logic [DATA_WIDTH-1:0] rdata;
    logic [ADDR_WIDTH-1:0] addr;

    // memory side interface
    modport server (
        input read, addr,
        output resp, rdata
    );

    // requestor side interface
    modport requestor (
        input resp, rdata,
        output read, addr
    );

endinterface : mem_ro_itf

// Read-Write memory interface
interface mem_rw_itf #(
    parameter DATA_WIDTH = 256,     // data bus width
    parameter ADDR_WIDTH = 32,      // addresss width
    parameter WMASK_WIDTH = DATA_WIDTH / 8 // wmask width
);

    logic read;
    logic write;
    logic [WMASK_WIDTH-1:0] wmask;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] wdata;
    logic resp;
    logic [DATA_WIDTH-1:0] rdata;

    // memory side interface
    modport server (
        input read, write, addr, wmask, wdata,
        output resp, rdata
    );

    // requestor side interface
    modport requestor (
        input resp, rdata,
        output read, write, wmask, addr, wdata
    );

endinterface : mem_rw_itf
