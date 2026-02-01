library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library logic;

entity not_gate_tb is
  generic (runner_cfg : string);
end;

architecture test of not_gate_tb is
  constant not_gate_width : natural := 4;

  signal a, y : std_ulogic_vector(not_gate_width - 1 downto 0);
begin

  uut : entity logic.not_gate
    generic map (
      not_gate_width => not_gate_width
      )
    port map (
      a => a,
      y => y
      );

  process
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop

      if run("tc1") then
        a <= (others => '0'); wait for 10 ns;
        assert y = "1111" report "NOT failed: NOT 0" severity error;
      end if;

      if run("tc2") then
        a <= (others => '1'); wait for 10 ns;
        assert y = "0000" report "NOT failed: NOT 1" severity error;
      end if;

      if run("tc3") then
        a <= "1010"; wait for 10 ns;
        assert y = "0101" report "NOT failed: NOT 1010" severity error;
      end if;

    end loop;
    test_runner_cleanup(runner);
  end process;
end architecture;

