-------------------------------------------------------------------------------
-- Title      : memory
-- Project    : 
-------------------------------------------------------------------------------
-- File       : memory.vhdl
-- Author     : lucjoh
-- Created    : 2025-07-29
-- Last update: 2025-07-30
-- Standard   : VHDL-2008
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2025 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-07-29  1.0      lucjoh  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
  generic (
    addr_width : natural := 12
    );
  port (
    clk   : in std_ulogic;
    rstn  : in std_ulogic;
    write : in std_ulogic;
    read  : in std_ulogic
    );
end entity;

architecture rtl of memory is

-------------
-- IR ???
-------------
  type memory_array is array(0 to 5) of std_ulogic_vector(7 downto 0);
  constant memory : memory_array := (
    "00000000",
    "00000000",
    "00010000",
    "00000000",
    "00000000",
    "00000000"
    );

begin



end rtl;
