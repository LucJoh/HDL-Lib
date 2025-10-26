-------------------------------------------------------------------------------
-- Title      : data bus
-- Project    : 
-------------------------------------------------------------------------------
-- File       : data_bus.vhdl
-- Author     : lucjoh
-- Company    : 
-- Created    : 2025-08-17
-- Last update: 2025-08-17
-- Platform   : 
-- Standard   : VHDL-2008
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2025 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-08-17  1.0      lucjoh	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity data_bus is
  generic (
    bus_width : natural := 4
    );
  port (
    deco_en   : in  std_ulogic;
    deco_sel  : in  std_ulogic_vector (1 downto 0);
    instr_out : in  std_ulogic_vector (bus_width-1 downto 0);
    alu_out   : in  std_ulogic_vector (bus_width-1 downto 0);
    acc_out   : in  std_ulogic_vector (bus_width-1 downto 0);
    bus_out   : out std_ulogic_vector (bus_width-1 downto 0)
    );
end data_bus;

architecture rtl of data_bus is
begin
  process(deco_en, deco_sel, instr_out, data_out, acc_out, ext_in)
  begin
    if (deco_en = '1') then
      if (deco_sel = "00") then
        bus_out <= instr_out;
      elsif (deco_sel = "01") then
        bus_out <= alu_out;
      elsif (deco_sel = "10") then
        bus_out <= acc_out;
      end if;
    else
      bus_out <= (others => 'Z');
    end if;
  end process;
end rtl;
