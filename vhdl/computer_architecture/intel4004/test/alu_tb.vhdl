-- ============================================================================
-- Title       : ALU Testbench
-- Description : VUnit-based testbench for ALU operations (ADD, SUB, AND)
-- Author      : [Your Name]
-- Created     : [Date]
-- ============================================================================
-- Notes:
-- - Uses VUnit for structured test execution
-- - Verifies result, equal flag (e), and carry-out (cout)
-- ============================================================================

library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

-- ============================================================================
-- Entity Declaration
-- ============================================================================

entity alu_tb is
  generic (
    runner_cfg : string;
    cpu_width  : natural := 4
    );
end entity alu_tb;

-- ============================================================================
-- Architecture
-- ============================================================================

architecture rtl of alu_tb is

  -- ALU I/O Signals
  signal a      : std_ulogic_vector(cpu_width-1 downto 0);
  signal b      : std_ulogic_vector(cpu_width-1 downto 0);
  signal op     : std_ulogic_vector(1 downto 0);
  signal result : std_ulogic_vector(cpu_width-1 downto 0);
  signal e      : std_ulogic;
  signal cout   : std_ulogic;

begin

  -- ==========================================================================
  -- DUT: ALU Instantiation
  -- ==========================================================================

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

  -- ==========================================================================
  -- Stimulus Process
  -- ==========================================================================

  stimulus : process
  begin
    test_runner_setup(runner, runner_cfg);

    while test_suite loop

      -- ======================================================================
      -- Test Case 1: ADD (1 + 2 = 3)
      -- ======================================================================
      if run("tc1") then
        a <= "0001"; b <= "0010"; op <= "00"; wait for 10 ns;
        assert (result = "0011" and e = '0' and cout = '0')
          report
          "  Test Case 1 Failed " & LF &
          "    Expected : result = 0011, e = 0, cout = 0" & LF &
          "    Got      : result = " & to_string(result) &
          ", e = " & to_string(e) &
          ", cout = " & to_string(cout)
          severity error;

      -- ======================================================================
      -- Test Case 2: SUB (4 - 1 = 3)
      -- ======================================================================
      elsif run("tc2") then
        a <= "0100"; b <= "0001"; op <= "01"; wait for 10 ns;
        assert (result = "0011" and e = '0' and cout = '1')
          report
          "  Test Case 2 Failed " & LF &
          "    Expected : result = 0011, e = 0, cout = 1" & LF &
          "    Got      : result = " & to_string(result) &
          ", e = " & to_string(e) &
          ", cout = " & to_string(cout)
          severity failure;

      -- ======================================================================
      -- Test Case 3: AND (12 AND 10 = 8)
      -- ======================================================================
      elsif run("tc3") then
        a <= "1100"; b <= "1010"; op <= "10"; wait for 10 ns;
        assert (result = "1000" and e = '0' and cout = '0')
          report
          "  Test Case 3 Failed " & LF &
          "    Expected : result = 1000, e = 0, cout = 0" & LF &
          "    Got      : result = " & to_string(result) &
          ", e = " & to_string(e) &
          ", cout = " & to_string(cout)
          severity failure;

      -- ======================================================================
      -- Test Case 4: ADD Overflow (15 + 15 = 14, cout and e set)
      -- ======================================================================
      elsif run("tc4") then
        a <= "1111"; b <= "1111"; op <= "00"; wait for 10 ns;
        assert (result = "1110" and e = '1' and cout = '1')
          report
          "  Test Case 4 Failed " & LF &
          "    Expected : result = 1110, e = 1, cout = 1" & LF &
          "    Got      : result = " & to_string(result) &
          ", e = " & to_string(e) &
          ", cout = " & to_string(cout)
          severity failure;

      -- ======================================================================
      -- Test Case 5: ADD (0 + 0 = 0, e set)
      -- ======================================================================
      elsif run("tc5") then
        a <= "0000"; b <= "0000"; op <= "00"; wait for 10 ns;
        assert (result = "0000" and e = '1' and cout = '0')
          report
          " Test Case 5 Failed " & LF &
          "    Expected : result = 0000, e = 1, cout = 0" & LF &
          "    Got      : result = " & to_string(result) &
          ", e = " & to_string(e) &
          ", cout = " & to_string(cout)
          severity failure;

      -- ======================================================================
      -- Test Case 6: SUB (0 - 0 = 0, e and cout set)
      -- ======================================================================
      elsif run("tc6") then
        a <= "0000"; b <= "0000"; op <= "01"; wait for 10 ns;
        assert (result = "0000" and e = '1' and cout = '1')
          report
          " Test Case 6 Failed " & LF &
          "    Expected : result = 0000, e = 1, cout = 1" & LF &
          "    Got      : result = " & to_string(result) &
          ", e = " & to_string(e) &
          ", cout = " & to_string(cout)
          severity failure;

      -- ======================================================================
      -- Test Case 7: Duplicate of tc6 for regression check
      -- ======================================================================
      elsif run("tc7") then
        a <= "0000"; b <= "0000"; op <= "01"; wait for 10 ns;
        assert (result = "0000" and e = '1' and cout = '1')
          report
          "  Test Case 7 Failed " & LF &
          "    Expected : result = 0000, e = 1, cout = 1" & LF &
          "    Got      : result = " & to_string(result) &
          ", e = " & to_string(e) &
          ", cout = " & to_string(cout)
          severity failure;

      -- ======================================================================
      -- Test Case 8: ADD (15 + 1 = 0, carry out)
      -- ======================================================================
      elsif run("tc8") then
        a <= "1111"; b <= "0001"; op <= "00"; wait for 10 ns;
        assert (result = "0000" and e = '0' and cout = '1')
          report
          "  Test Case 8 Failed " & LF &
          "    Expected : result = 0000, e = 0, cout = 1" & LF &
          "    Got      : result = " & to_string(result) &
          ", e = " & to_string(e) &
          ", cout = " & to_string(cout)
          severity failure;

      -- ======================================================================
      -- Test Case 9: SUB (10 - 10 = 0, e and cout set)
      -- ======================================================================
      elsif run("tc9") then
        a <= "0101"; b <= "0101"; op <= "01"; wait for 10 ns;
        assert (result = "0000" and e = '1' and cout = '1')
          report
          "  Test Case 9 Failed " & LF &
          "    Expected : result = 0000, e = 1, cout = 1" & LF &
          "    Got      : result = " & to_string(result) &
          ", e = " & to_string(e) &
          ", cout = " & to_string(cout)
          severity failure;

      -- ======================================================================
      -- Test Case 10: AND (15 AND 0 = 0, no carry, e unset)
      -- ======================================================================
      elsif run("tc10") then
        a <= "1111"; b <= "0000"; op <= "10"; wait for 10 ns;
        assert (result = "0000" and e = '0' and cout = '0')
          report
          "  Test Case 10 Failed " & LF &
          "    Expected : result = 0000, e = 0, cout = 0" & LF &
          "    Got      : result = " & to_string(result) &
          ", e = " & to_string(e) &
          ", cout = " & to_string(cout)
          severity failure;

      end if;

    end loop;

    -- ==========================================================================
    -- All Tests Passed
    -- ==========================================================================
    report " -------- TEST FINISHED SUCCESSFULLY -------- ";
    test_runner_cleanup(runner);
    wait;

  end process;

end architecture rtl;

