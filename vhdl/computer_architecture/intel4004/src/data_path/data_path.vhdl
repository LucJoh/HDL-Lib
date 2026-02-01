-------------------------------------------------------------------------------
-- Title      : data_path
-- Project    : 
-------------------------------------------------------------------------------
-- File       : data_path.vhdl
-- Author     : lucjoh
-- Created    : 2025-04-26
-- Last update: 2025-08-18
-- Standard   : VHDL-2008
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

library alu;
library mux;
library logic;
library memory;
library data_path;
library control;

entity data_path is
  generic (
    cpu_width : natural := 4
    );
  port (
    clk  : in std_ulogic;
    rstn : in std_ulogic
    );
end data_path;

architecture rtl of data_path is

  --==========================================================  
  -- INTERNAL SIGNALS 
  --==========================================================
  -- accumulator
  signal acc_out      : std_ulogic_vector(cpu_width-1 downto 0);
  signal acc_load_en  : std_ulogic;
  -- alu
  signal alu_result   : std_ulogic_vector(cpu_width-1 downto 0);
  signal s_flag       : std_ulogic;
  signal z_flag       : std_ulogic;
  signal p_flag       : std_ulogic;
  signal c_flag       : std_ulogic;
  signal e_flag       : std_ulogic;
  --data_bus
  signal bus_out      : std_ulogic_vector(cpu_width-1 downto 0);
  -- control unit
  signal master_en    : std_ulogic;
  signal data_bus_en  : std_ulogic;
  signal data_bus_sel : std_ulogic_vector(1 downto 0);
  signal pc_inc       : std_ulogic;

--=====================================================
-- BEGIN ARCHITECTURE 
--=====================================================
begin

  --==========================================================  
  -- COMPONENTS 
  --==========================================================
  i_data_bus : entity data_path.data_bus
    generic map (
      bus_width => cpu_width
      )
    port map (
      deco_en   => deco_en,
      deco_sel  => deco_sel,
      instr_out => instr_out,
      alu_out   => alu_result,
      acc_out   => acc_out,
      bus_out   => bus_out
      );
  i_ctrl_unit : entity control.ctrl_unit
    port map (
      master_en    => master_en,
      clk          => clk,
      rstn         => rstn,
      instr        => instr_out,
      acc_load_en  => acc_load_en,
      reg_load_en  => reg_load_en,
      alu_op       => alu_op,
      data_bus_en  => data_bus_en,
      data_bus_sel => data_bus_sel,
      pc_inc       => pc_inc
      );

  i_alu : entity alu.alu
    generic map (
      rca_width => cpu_width
      )
    port map (
      a      => acc_out,
      b      => b_to_alu,
      op     => alu_op,
      result => alu_result,
      e      => e_flag,
      cout   => c_flag
      );

  i_accumulator : entity data_path.n_bit_register
    generic map (
      reg_width => cpu_width
      )
    port map (
      clk     => clk,
      rstn    => rstn,
      d       => alu_result,
      load_en => acc_load_en,
      q       => acc_out
      );

  i_b_reg : entity data_path.n_bit_register
    generic map (
      reg_width => cpu_width
      )
    port map (
      clk     => clk,
      rstn    => rstn,
      d       => b,
      load_en => b_reg_load_en,
      q       => b_to_alu
      );

  i_n_bit_reg : entity data_path.n_bit_register
    generic map (
      reg_width => cpu_width
      )
    port map (
      clk     => open,
      rstn    => open,
      d       => open,
      load_en => open,
      q       => open
      );

  i_mux4to1 : entity mux.mux4to1
    generic map (
      mux_width => cpu_width
      )
    port map (
      w0 => open,
      w1 => open,
      w2 => open,
      w3 => open,
      s  => open,
      f  => open
      );

  i_mux2to1 : entity mux.mux2to1
    generic map (
      mux_width => cpu_width
      )
    port map (
      w0 => open,
      w1 => open,
      s  => open,
      f  => open
      );

end architecture;
