library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fa is
  port (
    a    : in  std_ulogic;
    b    : in  std_ulogic;
    cin  : in  std_ulogic;
    s    : out std_ulogic;
    cout : out std_ulogic
    );
end fa;

architecture rtl of fa is

begin

  s    <= a xor b xor cin;
  cout <= (a and b) or (cin and a) or (cin and b);

end rtl;
