library vunit_lib;
context vunit_lib.vunit_context;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity alu_tb is
  generic (
    runner_cfg : string;
    cpu_width  : natural := 4
    );
end entity alu_tb;

architecture rtl of alu_tb is

  signal a      : std_ulogic_vector(cpu_width-1 downto 0);
  signal b      : std_ulogic_vector(cpu_width-1 downto 0);
  signal op     : std_ulogic_vector(1 downto 0);
  signal result : std_ulogic_vector(cpu_width-1 downto 0);
  signal e      : std_ulogic;
  signal cout   : std_ulogic;

begin

  i_alu : entity work.alu
    generic map (
      cpu_width => cpu_width
      )
    port map (
      a      => a,
      b      => b,
      op     => op,
      result => result,
      e      => e,
      cout   => cout
      );

  -- Stimulus process
  stimulus : process
  begin

    test_runner_setup(runner, runner_cfg);

    while test_suite loop

      if run("tc1") then
        -- Test case 1: ADD operation
        a  <= "0001";                   -- A = 1
        b  <= "0010";                   -- B = 2
        op <= "00";                     -- ADD
        wait for 10 ns;                 -- wait for the result to propagate
        assert (result = "0011" and e = '0' and cout = '0') report "Test Case 1 Failed: result = " & to_string(result) & ", e = " & to_string(e) & ", cout = " & to_string(cout) 
    severity error;

      elsif run("tc2") then
        -- Test case 2: SUBTRACT operation (example for subtraction)
        a  <= "0100";                   -- A = 4
        b  <= "0001";                   -- B = 1
        op <= "01";                     -- SUBTRACT
        wait for 10 ns;
        assert (result = "0011" and e = '0' and cout = '1') 
        report "------------ Test Case 2 Failed ---------- result = " & to_string(result) & ", e = " & to_string(e) & ", cout = " & to_string(cout)
        severity failure;

      elsif run("tc3") then
        -- Test case 3: AND operation
        a  <= "1100";                   -- A = 12
        b  <= "1010";                   -- B = 10
        op <= "10";                     -- AND
        wait for 10 ns;
        assert (result = "1000" and e = '0' and cout = '0')
        report "------------ Test Case 3 Failed ---------- result = " & to_string(result) & ", e = " & to_string(e) & ", cout = " & to_string(cout)
        severity failure;

      elsif run("tc4") then
        -- Test case 4: ADD operation (e flag and cout)
        a  <= "1111";                   -- A = 15
        b  <= "1111";                   -- B = 15
        op <= "00";                     -- ADD
        wait for 10 ns;
        assert (result = "1110" and e = '1' and cout = '1')
        report "------------ Test Case 3 Failed ---------- result = " & to_string(result) & ", e = " & to_string(e) & ", cout = " & to_string(cout)
        severity failure;

      elsif run("tc5") then
        -- Test case 5: ADD operation (e flag)
        a  <= "0000";                   -- A = 15
        b  <= "0000";                   -- B = 15
        op <= "00";                     -- ADD
        wait for 10 ns;
        assert (result = "0000" and e = '1' and cout = '0')
        report "------------ Test Case 3 Failed ---------- result = " & to_string(result) & ", e = " & to_string(e) & ", cout = " & to_string(cout)
        severity failure;

      elsif run("tc6") then
        -- Test case 6: SUB operation (e flag)
        a  <= "0000";                   -- A = 15
        b  <= "0000";                   -- B = 15
        op <= "01";                     -- SUB
        wait for 10 ns;
        assert (result = "0000" and e = '1' and cout = '0')
        report "------------ Test Case 3 Failed ---------- result = " & to_string(result) & ", e = " & to_string(e) & ", cout = " & to_string(cout)
        severity failure;

      elsif run("tc7") then
        -- Test case 7: SUB operation (e flag)
        a  <= "0000";                   -- A = 15
        b  <= "0000";                   -- B = 15
        op <= "01";                     -- SUB
        wait for 10 ns;
        assert (result = "0000" and e = '1' and cout = '0')
        report "------------ Test Case 3 Failed ---------- result = " & to_string(result) & ", e = " & to_string(e) & ", cout = " & to_string(cout)
        severity failure;

      end if;

    end loop;

    report "-------- TEST FINISHED SUCESSFULLY --------";
    test_runner_cleanup(runner);
    wait;

  end process;
end architecture rtl;

