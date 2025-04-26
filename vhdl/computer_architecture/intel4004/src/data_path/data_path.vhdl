-------------------------------------------------------------------------------
-- Title      : data_path
-- Project    : 
-------------------------------------------------------------------------------
-- File       : data_path.vhdl
-- Author     : lucjoh
-- Created    : 2025-04-26
-- Last update: 2025-04-26
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2025 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-04-26  1.0      lucjoh  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_path is
  generic (
    cpu_width : natural := 4
    );
  port (

    );
end data_path;

architecture rtl of data_path is

-------------------------------------------------------  
-- BEGIN ARCHITECTURE 
-------------------------------------------------------
begin

  i_alu : entity work.alu
    generic map (
      rca_width => cpu_width
      )
    port map (
      a      => open,
      b      => open,
      op     => open,
      result => open,
      e      => open,
      cout   => open,
      );

  i_n_bit_reg : entity work.n_bit_reg
    generic map (
      reg_width => cpu_width
      )
    port map (
      clk     => open,
      rstn    => open,
      d       => open,
      load_en => open,
      q       => open,
      );

  i_mux4to1 : entity work.mux4to1
    generic map (
      mux_width => cpu_width
      )
    port map (
      w0 => open,
      w1 => open,
      w2 => open,
      w3 => open,
      s  => open,
      f  => open,
      );

  i_mux2to1 : entity work.mux2to1
    generic map (
      mux_width => cpu_width
      )
    port map (
      w0 => open,
      w1 => open,
      s  => open,
      f  => open,
      );

end architecture;
