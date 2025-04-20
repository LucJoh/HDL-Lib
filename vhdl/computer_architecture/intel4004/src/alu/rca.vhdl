library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rca is
  generic (
    rca_width : natural := 4
    );
  port (
    a    : in  std_ulogic_vector(rca_width-1 downto 0);
    b    : in  std_ulogic_vector(rca_width-1 downto 0);
    cin  : in  std_ulogic;
    s    : out std_ulogic_vector(rca_width-1 downto 0);
    cout : out std_ulogic);
end rca;

architecture rtl of rca is

  signal c : std_ulogic_vector (rca_width-1 downto 0);  -- internal carry

begin

  i_fa_0 : entity work.fa
    port map (
      a    => a(0),
      b    => b(0),
      cin  => cin,
      s    => s(0),
      cout => c(1)
      );

  g_fa : for i in 1 to rca_width-2 generate
    i_fa_1_2 : entity work.fa
      port map (
        a    => a(i),
        b    => b(i),
        cin  => c(i),
        s    => s(i),
        cout => c(i+1)
        );
  end generate;

  i_fa_3 : entity work.fa
    port map (
      a    => a(rca_width-1),
      b    => b(rca_width-1),
      cin  => c(rca_width-1),
      s    => s(rca_width-1),
      cout => cout
      );

end rtl;
