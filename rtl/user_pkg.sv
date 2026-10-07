// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Authors:
// - Philippe Sauter <phsauter@iis.ee.ethz.ch>

`include "obi/typedef.svh"

package user_pkg;

  //////////////////
  // User Manager //
  //////////////////

  // None


  ///////////////////////
  // User Subordinates //
  ///////////////////////

  // The base address of the user domain can be retrived from `croc_pkg::UserBaseAddr`
  // Recommended: place subordinates at 4KB boundaries (32'hXXXX_X000)

  /// Enum with user domain demultiplexer subordinate idxs
  typedef enum bit [4:0]  {
    UserError = 0,
    UserAes   = 1
  } user_demux_outputs_e;

  /// Address rules given to user domain demultiplexer (see croc_pkg.sv for examples)
  // UserBaseAddr + 0x0000 is reserved for a user ROM (see README)
  localparam bit [31:0] UserAesAddrOffset = 32'h0000_1000;
  localparam bit [31:0] UserAesAddrRange  = 32'h0000_1000;

  localparam croc_pkg::addr_map_rule_t [0:0] UserAddrMap = '{
    '{
      idx:        UserAes,
      start_addr: croc_pkg::UserBaseAddr + UserAesAddrOffset,
      end_addr:   croc_pkg::UserBaseAddr + UserAesAddrOffset + UserAesAddrRange
    }
  };
  // All addresses outside the defined address rules go to the error subordinate

  // +1 for additional OBI error
  localparam int unsigned NumDemuxSbr = $size(UserAddrMap) + 1;

endpackage
