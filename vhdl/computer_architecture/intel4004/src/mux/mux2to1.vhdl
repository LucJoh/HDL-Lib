library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2to1 is
  generic (
    mux_width : natural := 4
    );
  port (
    w0 : in  std_ulogic_vector (mux_width-1 downto 0);
    w1 : in  std_ulogic_vector (mux_width-1 downto 0);
    s  : in  std_ulogic;
    f  : out std_ulogic_vector (mux_width-1 downto 0)
    );
end mux2to1;

architecture rtl of mux2to1 is
begin

  f <= w0 when s = '0' else w1;

end rtl;
