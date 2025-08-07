-------------------------------------------------------------------------------
-- Title      : and gate
-- Project    : 
-------------------------------------------------------------------------------
-- File       : and_gate.vhdl
-- Author     : lucjoh
-- Created    : 2025-07-29
-- Last update: 2025-07-29
-- Standard   : VHDL-2008
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2025 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-07-29  1.0      lucjoh	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity and_gate is
  generic (
    and_gate_width : natural := 4
    );
  port (
    a : in  std_ulogic_vector(and_gate_width - 1 downto 0);
    b : in  std_ulogic_vector(and_gate_width - 1 downto 0);
    y : out std_ulogic_vector(and_gate_width - 1 downto 0)
    );
end and_gate;

architecture rtl of and_gate is
begin

  y <= a and b;

end rtl;
