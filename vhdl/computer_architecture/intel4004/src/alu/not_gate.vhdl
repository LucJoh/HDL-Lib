library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity not_gate is
  generic (
    not_gate_width : natural := 4
    );
  port (
    a : in  std_ulogic_vector(not_gate_width - 1 downto 0);
    y : out std_ulogic_vector(not_gate_width - 1 downto 0)
    );
end not_gate;

architecture rtl of not_gate is
begin

  y <= not a;

end rtl;
