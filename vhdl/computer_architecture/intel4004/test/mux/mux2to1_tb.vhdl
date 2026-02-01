library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library mux;

entity mux2to1_tb is
  generic (runner_cfg : string);
end;

architecture test of mux2to1_tb is
  constant mux_width : natural := 4;

  signal w0, w1, f : std_ulogic_vector(mux_width - 1 downto 0);
  signal s         : std_ulogic;

begin

  uut : entity mux.mux2to1
    generic map (
      mux_width => mux_width
      )
    port map (
      w0 => w0,
      w1 => w1,
      s  => s,
      f  => f
      );

  process
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop

      if run("tc1") then
        w0 <= "0001"; w1 <= "1111"; s <= '0'; wait for 10 ns;
        assert f = "0001" report "mux2to1 failed: s=0, expected w0" severity error;
      end if;

      if run("tc2") then
        w0 <= "0001"; w1 <= "1111"; s <= '1'; wait for 10 ns;
        assert f = "1111" report "mux2to1 failed: s=1, expected w1" severity error;
      end if;

    end loop;

    test_runner_cleanup(runner);

  end process;
end architecture;

