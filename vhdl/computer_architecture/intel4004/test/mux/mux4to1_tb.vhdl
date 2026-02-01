library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library mux;

entity mux4to1_tb is
  generic (runner_cfg : string);
end;

architecture test of mux4to1_tb is
  constant mux_width : natural := 4;

  signal w0, w1, w2, w3, f : std_ulogic_vector(mux_width - 1 downto 0);
  signal s                 : std_ulogic_vector(1 downto 0);

begin

  uut : entity mux.mux4to1
    generic map (
      mux_width => mux_width
      )
    port map (
      w0 => w0,
      w1 => w1,
      w2 => w2,
      w3 => w3,
      s  => s,
      f  => f
      );

  process
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop

      -- Set fixed inputs for testing
      w0 <= (others => '0');
      w1 <= (others => '1');
      w2 <= "1010";
      w3 <= "0101";

      if run("tc1") then
        s <= "00"; wait for 10 ns;
        assert f = w0 report "mux4to1 failed: s=00, expected w0" severity error;
      end if;

      if run("tc2") then
        s <= "01"; wait for 10 ns;
        assert f = w1 report "mux4to1 failed: s=01, expected w1" severity error;
      end if;

      if run("tc3") then
        s <= "10"; wait for 10 ns;
        assert f = w2 report "mux4to1 failed: s=10, expected w2" severity error;
      end if;

      if run("tc4") then
        s <= "11"; wait for 10 ns;
        assert f = w3 report "mux4to1 failed: s=11, expected w3" severity error;
      end if;

    end loop;
    test_runner_cleanup(runner);
  end process;
end architecture;

