library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library logic;

entity and_gate_tb is
  generic (runner_cfg : string);
end;

architecture test of and_gate_tb is
  constant and_gate_width : natural := 4;

  signal a, b, y : std_ulogic_vector(and_gate_width - 1 downto 0);
begin

  uut : entity logic.and_gate
    generic map (
      and_gate_width => and_gate_width
      )
    port map (
      a => a,
      b => b,
      y => y
      );

  process
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop

    if run("tc1") then
      a <= (others       => '0'); b <= (others => '0'); wait for 10 ns;
      assert y = "0000" report "AND failed: 0 AND 0" severity error;
    end if;

    if run("tc2") then
      a <= (others       => '0'); b <= (others => '1'); wait for 10 ns;
      assert y = "0000" report "AND failed: 0 AND 1" severity error;
    end if;

    if run("tc3") then
      a <= (others       => '1'); b <= (others => '0'); wait for 10 ns;
      assert y = "0000" report "AND failed: 1 AND 0" severity error;
    end if;

    if run("tc4") then
      a <= (others       => '1'); b <= (others => '1'); wait for 10 ns;
      assert y = "1111" report "AND failed: 1 AND 1" severity error;
    end if;

    if run("tc5") then
      a <= "1100"; b <= "1010"; wait for 10 ns;
      assert y = "1000" report "AND failed: 1100 AND 1010" severity error;
    end if;

end loop;
    test_runner_cleanup(runner);
  end process;
end architecture;

