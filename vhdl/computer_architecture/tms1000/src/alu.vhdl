-------------------------------------------------------------------------------
-- Title      : alu
-- Project    : 
-------------------------------------------------------------------------------
-- File       : alu.vhdl
-- Author     : lucjoh
-- Created    : 2025-03-19
-- Last update: 2025-03-23
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2025 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-03-19  1.0      lucjoh  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  generic (
    cpu_width : natural := 4
    );
  port (
    a      : in  std_ulogic_vector(3 downto 0);
    b      : in  std_ulogic_vector(3 downto 0);
    op     : in  std_ulogic_vector(2 downto 0);
    result : out std_ulogic_vector(3 downto 0);
    e      : out std_ulogic;
    cout   : out std_ulogic
    );
end alu;

architecture rtl of alu is

  rca_inst : entity work.rca
    generic map (
      cpu_width => cpu_width
      )
    port map
    (a    => a,
     b    => b,
     cin  => open,
     s    => open,
     cout => open
     );

-------------------------------------------------------  
-- BEGIN ARCHITECTURE 
-------------------------------------------------------
begin



end architecture;
