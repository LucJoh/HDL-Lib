library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rca is
  generic (
    cpu_width : natural := 4
    );
  port (
    a    : in  std_logic_vector(cpu_width-1 downto 0);
    b    : in  std_logic_vector(cpu_width-1 downto 0);
    cin  : in  std_logic;
    s    : out std_logic_vector(cpu_width-1 downto 0);
    cout : out std_logic);
end rca;

architecture rtl of rca is

  signal c : std_ulogic_vector (cpu_width-2 downto 0);  -- internal carry

begin

  fa_inst : entity work.fa
    port map
    (a    => a(0),
     b    => b(0),
     cin  => cin,
     s    => s(0),
     cout => c(0)
     );

  g_fa : for i in 1 to cpu_width-2 generate
    fa_inst : entity work.fa
      port map
      (a    => a(i),
       b    => b(i),
       cin  => c(i-1),
       s    => s(i),
       cout => c(i)
       );
  end generate;

  fa_inst : entity work.fa
    port map
    (a    => a(cpu_width-1),
     b    => b(cpu_width-1),
     cin  => c(cpu_width-2),
     s    => s(cpu_width-1),
     cout => cout
     );

end rtl;
