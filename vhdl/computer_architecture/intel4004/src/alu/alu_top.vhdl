-------------------------------------------------------------------------------
-- Title      : alu
-- Project    : 
-------------------------------------------------------------------------------
-- File       : alu.vhdl
-- Author     : lucjoh
-- Created    : 2025-03-19
-- Last update: 2025-08-23
-- Standard   : VHDL-2008
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

library alu;
library mux;
library logic;

entity alu_top is
  generic (
    cpu_width : natural := 4
    );
  port (
    a      : in  std_ulogic_vector(3 downto 0);
    b      : in  std_ulogic_vector(3 downto 0);
    op     : in  std_ulogic_vector(1 downto 0);
    result : out std_ulogic_vector(3 downto 0);
    e      : out std_ulogic;            -- eq flag
    cout   : out std_ulogic
    );
end alu_top;

architecture rtl of alu_top is

  signal sum         : std_ulogic_vector(cpu_width-1 downto 0);
  signal diff        : std_ulogic_vector(cpu_width-1 downto 0);
  signal logical_and : std_ulogic_vector(cpu_width-1 downto 0);
  signal b_inv       : std_ulogic_vector(cpu_width-1 downto 0);
  signal mux2to1_out : std_ulogic;
  signal cout_add    : std_ulogic;
  signal cout_sub    : std_ulogic;

-------------------------------------------------------  
-- BEGIN ARCHITECTURE 
-------------------------------------------------------
begin

  i_rca_add : entity alu.rca
    generic map (
      rca_width => cpu_width
      )
    port map (
      a    => a,
      b    => b,
      cin  => '0',
      s    => sum,
      cout => cout_add
      );

  i_rca_sub : entity alu.rca
    generic map (
      rca_width => cpu_width
      )
    port map (
      a    => a,
      b    => b_inv,
      cin  => '1',
      s    => diff,
      cout => cout_sub
      );

  i_cmp : entity alu.cmp
    generic map (
      cmp_width => cpu_width
      )
    port map (
      a => a,
      b => b,
      e => e
      );

  i_and_gate : entity logic.and_gate
    generic map (
      and_gate_width => cpu_width
      )
    port map (
      a => a,
      b => b,
      y => logical_and
      );

  i_not_gate : entity logic.not_gate
    generic map (
      not_gate_width => cpu_width
      )
    port map (
      a => b,
      y => b_inv
      );

  i_mux4to1 : entity mux.mux4to1
    generic map (
      mux_width => cpu_width
      )
    port map (
      w0 => sum,
      w1 => diff,
      w2 => logical_and,
      w3 => b_inv,
      s  => op,
      f  => result
      );

  i_mux2to1_0 : entity mux.mux2to1
    generic map (
      mux_width => 1
      )
    port map (
      w0(0) => cout_add,
      w1(0) => cout_sub,
      s     => op(0),
      f(0)  => mux2to1_out
      );

  i_mux2to1_1 : entity mux.mux2to1
    generic map (
      mux_width => 1
      )
    port map (
      w0(0) => mux2to1_out,
      w1(0) => '0',
      s     => op(1),
      f(0)  => cout
      );

end architecture;
