library ieee;
use ieee.std_logic_1164.all;

entity data_bus is
  generic (
    bus_width : natural := 4
    );
  port (
    deco_en   : in  std_logic;
    deco_sel  : in  std_logic_vector (1 downto 0);
    instr_out : in  std_logic_vector (bus_width-1 downto 0);
    data_out  : in  std_logic_vector (bus_width-1 downto 0);
    acc_out   : in  std_logic_vector (bus_width-1 downto 0);
    ext_in    : in  std_logic_vector (bus_width-1 downto 0);
    bus_out   : out std_logic_vector (bus_width-1 downto 0)
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
        bus_out <= data_out;
      elsif (deco_sel = "10") then
        bus_out <= acc_out;
      elsif (deco_sel = "11") then
        bus_out <= ext_in;
      end if;
    else
      bus_out <= "ZZZZZZZZ";
    end if;
  end process;
end rtl;
