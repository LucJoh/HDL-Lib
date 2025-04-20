library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmp is
  generic (
    cmp_width : natural := 4
    );
  port (
    a : in  std_ulogic_vector (cmp_width-1 downto 0);
    b : in  std_ulogic_vector (cmp_width-1 downto 0);
    e : out std_ulogic
    );
end CMP;

architecture rtl of cmp is
begin

  e <= '1' when a = b else '0';

end rtl;
