-------------------------------------------------------------------------------
-- Title      : data_path
-- Project    : 
-------------------------------------------------------------------------------
-- File       : data_path.vhdl
-- Author     : lucjoh
-- Created    : 2025-04-26
-- Last update: 2026-02-14
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
library data_path;

entity data_path_core is
   generic (
      cpu_width : natural := 4
      );
   port (
      clk              : in  std_ulogic;
      rstn             : in  std_ulogic;
      -- control inputs
      acc_load_en      : in  std_ulogic;
      temp_reg_load_en : in  std_ulogic;
      alu_op           : in  std_ulogic_vector(1 downto 0);
      -- external data input (temporary for testing)
      data_in          : in  std_ulogic_vector(cpu_width-1 downto 0);
      -- outputs
      acc_out          : out std_ulogic_vector(cpu_width-1 downto 0);
      c_flag           : out std_ulogic;
      e_flag           : out std_ulogic
      );
end entity;

architecture rtl of data_path_core is

   signal acc_reg    : std_ulogic_vector(cpu_width-1 downto 0);
   signal temp_reg   : std_ulogic_vector(cpu_width-1 downto 0);
   signal alu_result : std_ulogic_vector(cpu_width-1 downto 0);
   signal carry      : std_ulogic;
   signal eq         : std_ulogic;

begin

   -- =====================================   
   -- Temp register
   -- =====================================   
   i_temp_reg : entity data_path.n_bit_reg
      generic map (
         reg_width => cpu_width
         )
      port map (
         clk     => clk,
         rstn    => rstn,
         d       => data_in,
         load_en => temp_reg_load_en,
         q       => temp_reg
         );

   -- =====================================   
   -- ALU
   -- =====================================   
   i_alu : entity alu.alu_top
      generic map (
         alu_width => cpu_width
         )
      port map (
         a      => acc_reg,
         b      => temp_reg,
         op     => alu_op,
         result => alu_result,
         cout   => carry,
         e      => eq
         );

   -- =====================================   
   -- Accumulator
   -- =====================================   
   i_acc_reg : entity data_path.n_bit_reg
      generic map (
         reg_width => cpu_width
         )
      port map (
         clk     => clk,
         rstn    => rstn,
         d       => data_in,
         load_en => acc_load_en,
         q       => acc_reg
         );

   acc_out <= alu_result;
   c_flag  <= carry;
   e_flag  <= eq;

end architecture;

