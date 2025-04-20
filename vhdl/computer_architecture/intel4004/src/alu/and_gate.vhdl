library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity and_gate is
  generic (
    and_gate_width : natural := 4
    );
  port (
    a : in  std_ulogic_vector(and_gate_width - 1 downto 0);
    b : in  std_ulogic_vector(and_gate_width - 1 downto 0);
    y : out std_ulogic_vector(and_gate_width - 1 downto 0)
    );
end and_gate;

architecture rtl of and_gate is
begin

  y <= a and b;

end rtl;
