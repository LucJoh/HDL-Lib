library vunit_lib;
context vunit_lib.vunit_context;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

library data_path;

-- ============================================================================
-- Entity Declaration
-- ============================================================================
entity data_path_core_tb is
   generic (
      runner_cfg : string;
      cpu_width  : natural := 4
      );
end entity data_path_core_tb;

-- ============================================================================
-- Architecture
-- ============================================================================
architecture rtl of data_path_core_tb is

   -- data_path I/O Signals
   signal clk              : std_ulogic                              := '0';
   signal rstn             : std_ulogic                              := '0';
   signal cout             : std_ulogic                              := '0';
   signal acc_load_en      : std_ulogic                              := '0';
   signal temp_reg_load_en : std_ulogic                              := '0';
   signal alu_op           : std_ulogic_vector(1 downto 0)           := (others => '0');
   signal data_in          : std_ulogic_vector(cpu_width-1 downto 0) := (others => '0');
   signal acc_out          : std_ulogic_vector(cpu_width-1 downto 0) := (others => '0');
   signal c_flag           : std_ulogic                              := '0';
   signal e_flag           : std_ulogic                              := '0';

   constant clk_period : time := 20 ns;

begin

   clk <= not clk after clk_period / 2;  -- 50 MHz clock

   -- ==========================================================================
   -- DUT: data_path_core Instantiation
   -- ==========================================================================
   i_dut : entity data_path.data_path_core
      generic map (
         cpu_width => cpu_width
         )
      port map (
         clk              => clk,
         rstn             => rstn,
         -- control inputs
         acc_load_en      => acc_load_en,
         temp_reg_load_en => temp_reg_load_en,
         alu_op           => alu_op,
         -- external data input (temporary for testing)
         data_in          => data_in,
         -- outputs
         acc_out          => acc_out,
         c_flag           => c_flag,
         e_flag           => e_flag
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
            alu_op  <= "00";
            data_in <= "0001"; temp_reg_load_en <= '1'; acc_load_en <= '0'; wait for clk_period;
            data_in <= "0010"; temp_reg_load_en <= '0'; acc_load_en <= '1'; wait for clk_period;
            assert (acc_out = "0011" and e_flag = '0' and c_flag = '0')
               report
               "  Test Case 1 Failed " & LF &
               "    Expected : acc_out = 0011, e_flag = 0, c_flag = 0" & LF &
               "    Got      : acc_out = " & to_string(acc_out) &
               ", e = " & to_string(e_flag) &
               ", cout = " & to_string(c_flag)
               severity error;

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

