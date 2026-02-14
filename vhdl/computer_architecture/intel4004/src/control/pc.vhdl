-------------------------------------------------------------------------------
-- Title      : program counter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : pc.vhdl
-- Author     : lucjoh
-- Created    : 2025-07-19
-- Last update: 2026-02-14
-- Standard   : VHDL-2008
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2025 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-07-19  1.0      lucjoh  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
   generic (
      addr_width : natural := 12
      );
   port (
      clk  : in  std_ulogic;
      rstn : in  std_ulogic;
      inc  : in  std_ulogic;
      pc   : out natural
      );
end entity;

architecture rtl of pc is
   signal pc_tmp : natural := 0;
begin
   process(clk, rstn)
   begin
      if rstn = '0' then
         pc_tmp <= 0;
      elsif rising_edge(clk) then
         if inc = '1' then
            if pc_tmp = 100 then
               pc_tmp <= 0;
            else
               pc_tmp <= pc_tmp + 1;
            end if;
         end if;
      end if;
   end process;

   pc <= pc_tmp;

end rtl;
