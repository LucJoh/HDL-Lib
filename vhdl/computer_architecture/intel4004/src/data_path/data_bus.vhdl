library ieee;
use ieee.std_logic_1164.all;

entity data_bus is
  generic (
    bus_width : natural := 4
    );
  port (
    decoEnable : in  std_logic;
    decoSel    : in  std_logic_vector (1 downto 0);
    instrOut   : in  std_logic_vector (bus_width-1 downto 0);
    dataOut    : in  std_logic_vector (bus_width-1 downto 0);
    accOut     : in  std_logic_vector (bus_width-1 downto 0);
    extIn      : in  std_logic_vector (bus_width-1 downto 0);
    busOut     : out std_logic_vector (bus_width-1 downto 0)
    );
end proc_bus;

architecture rtl of data_bus is
begin
  process(decoEnable, decoSel, instrOut, dataOut, accOut, extIn)
  begin
    if (decoEnable = '1') then
      if (decoSel = "00") then
        busOut <= instrOut;
      elsif (decoSel = "01") then
        busOut <= dataOut;
      elsif (decoSel = "10") then
        busOut <= accOut;
      elsif (decoSel = "11") then
        busOut <= extIn;
      end if;
    else
      busOut <= "ZZZZZZZZ";
    end if;
  end process;
end rtl;
