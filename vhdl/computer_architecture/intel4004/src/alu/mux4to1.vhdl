library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4to1 is
  generic (
    mux_width : natural := 4
    );
  port (
    w0 : in  std_ulogic_vector (mux_width-1 downto 0);
    w1 : in  std_ulogic_vector (mux_width-1 downto 0);
    w2 : in  std_ulogic_vector (mux_width-1 downto 0);
    w3 : in  std_ulogic_vector (mux_width-1 downto 0);
    s  : in  std_ulogic_vector (1 downto 0);
    f  : out std_ulogic_vector (mux_width-1 downto 0)
    );
end mux4to1;

architecture rtl of mux4to1 is

  signal a : std_ulogic_vector (mux_width-1 downto 0);
  signal b : std_ulogic_vector (mux_width-1 downto 0);

begin

  i_mux0 : entity work.mux2to1
    generic map (
      mux_width => mux_width
      )
    port map (
      w0 => w0,
      w1 => w1,
      s  => s(0),
      f  => a
      );

  i_mux1 : entity work.mux2to1
    generic map (
      mux_width => mux_width
      )
    port map (
      w0 => w2,
      w1 => w3,
      s  => s(0),
      f  => b
      );

  i_mux2 : entity work.mux2to1
    generic map (
      mux_width => mux_width
      )
    port map (
      w0 => a,
      w1 => b,
      s  => s(1),
      f  => f
      );

end rtl;
