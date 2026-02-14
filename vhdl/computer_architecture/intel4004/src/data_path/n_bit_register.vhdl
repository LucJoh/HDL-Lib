library ieee;
use ieee.std_logic_1164.all;

entity n_bit_reg is
   generic (
      reg_width : natural := 4
      );
   port (
      clk     : in  std_logic;
      rstn    : in  std_logic;
      d       : in  std_logic_vector(reg_width-1 downto 0);
      load_en : in  std_logic;
      q       : out std_logic_vector(reg_width-1 downto 0)
      );
end n_bit_reg;

architecture rtl of n_bit_reg is
begin
   process (clk, rstn)
   begin
      if rstn = '0' then
         q <= (others => '0');
      elsif rising_edge(clk) then
         if load_en = '1' then
            q <= d;
         end if;
      end if;
   end process;
end rtl;
