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
   signal rstn             : std_ulogic                              := '1';
   signal cout             : std_ulogic                              := '0';
   signal acc_load_en      : std_ulogic                              := '0';
   signal temp_reg_load_en : std_ulogic                              := '0';
   signal alu_op           : std_ulogic_vector(1 downto 0)           := (others => '0');
   signal data_in          : std_ulogic_vector(cpu_width-1 downto 0) := (others => '0');
   signal acc_out          : std_ulogic_vector(cpu_width-1 downto 0) := (others => '0');
   signal c_flag           : std_ulogic                              := '0';

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
         c_flag           => c_flag
         );

   -- ==========================================================================
   -- Stimulus Process
   -- ==========================================================================
   stimulus : process
   begin
      test_runner_setup(runner, runner_cfg);

      rstn <= '0';
      wait for 2*clk_period;
      wait until rising_edge(clk);
      rstn <= '1';
      wait until rising_edge(clk);

      while test_suite loop

         -- =========================================================
         -- TC1: ADD bootstrap (0 -> 1 -> 3)
         -- =========================================================
         if run("tc1_add_bootstrap") then

            -- clean reset at start of test
            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            alu_op <= "00";             -- ADD

            -- After reset ACC should be 0
            wait for 1 ns;
            assert acc_out = "0000"
               report "TC1: after reset expected ACC=0000 got " & to_string(acc_out)
               severity error;

            -- TEMP <- 1
            data_in          <= "0001";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            -- ACC <- 0 + 1 = 1
            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0001"
               report "TC1: step1 expected ACC=0001 got " & to_string(acc_out)
               severity error;

            -- TEMP <- 2
            data_in          <= "0010";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            -- ACC <- 1 + 2 = 3
            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0011"
               report "TC1: step2 expected ACC=0011 got " & to_string(acc_out)
               severity error;

         -- =========================================================
         -- TC2: ADD overflow carry (15 + 1 -> 0, C=1)
         -- =========================================================
         elsif run("tc2_add_overflow") then

            -- clean reset
            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            alu_op <= "00";             -- ADD

            -- Bootstrap ACC to 15 via ALU: ACC = 0 + 15
            data_in          <= "1111";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "1111"
               report "TC2: bootstrap expected ACC=1111 got " & to_string(acc_out)
               severity error;

            -- Now add 1: 15 + 1 = 0 with carry=1
            data_in          <= "0001";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert (acc_out = "0000" and c_flag = '1')
               report "TC2: expected ACC=0000 C=1, got ACC=" &
               to_string(acc_out) & " C=" & to_string(c_flag)
               severity error;

         -- =========================================================
         -- TC3: SUB no-borrow vs borrow check (4-1 and 1-4)
         -- (carry semantics for SUB vary; this checks both patterns
         -- without assuming what 'carry' means on SUB)
         -- =========================================================
         elsif run("tc3_sub_borrow_patterns") then

            -- clean reset
            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            alu_op <= "00";             -- ADD (bootstrap)

            -- Bootstrap ACC = 4 via ALU: ACC = 0 + 4
            data_in          <= "0100";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0100"
               report "TC3: bootstrap expected ACC=0100 got " & to_string(acc_out)
               severity error;

            -- TEMP = 1
            data_in          <= "0001";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            -- SUB: 4 - 1 = 3
            alu_op      <= "01";        -- SUB
            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0011"
               report "TC3: expected 0100-0001=0011 got " & to_string(acc_out)
               severity error;

            -- Now do 1 - 4 (forces borrow), result should wrap (mod 16): 1-4 = -3 -> 13
            -- Bootstrap ACC = 1 (via ADD: ACC = 0 + 1)
            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            alu_op           <= "00";   -- ADD
            data_in          <= "0001";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0001"
               report "TC3: re-bootstrap expected ACC=0001 got " & to_string(acc_out)
               severity error;

            -- TEMP = 4
            data_in          <= "0100";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            -- SUB: 1 - 4 = 13 (1101)
            alu_op      <= "01";
            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "1101"
               report "TC3: expected 0001-0100=1101 got " & to_string(acc_out)
               severity error;

         -- =========================================================
         -- TC4: ACC hold when acc_load_en=0
         -- =========================================================
         elsif run("tc4_acc_hold") then

            -- clean reset
            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            alu_op <= "00";             -- ADD

            -- Bootstrap ACC = 5 via ALU: ACC = 0 + 5
            data_in          <= "0101";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0101"
               report "TC4: bootstrap expected ACC=0101 got " & to_string(acc_out)
               severity error;

            -- Change TEMP and op, but do NOT load ACC
            data_in          <= "1111";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            alu_op <= "00";             -- ADD (ALU will be doing something)
            wait until rising_edge(clk);

            wait for 1 ns;
            assert acc_out = "0101"
               report "TC4: ACC changed without load enable, got " & to_string(acc_out)
               severity error;

         -- =========================================================
         -- TC5: ADD then SUB from same starting ACC (4+1=5 and 4-1=3)
         -- =========================================================
         elsif run("tc5_add_vs_sub") then

            -- clean reset
            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            alu_op <= "00";             -- ADD

            -- Bootstrap ACC = 4 via ALU
            data_in          <= "0100";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0100"
               report "TC5: bootstrap expected ACC=0100 got " & to_string(acc_out)
               severity error;

            -- TEMP = 1
            data_in          <= "0001";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            -- ADD: 4 + 1 = 5
            alu_op      <= "00";
            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0101"
               report "TC5: ADD failed, expected 0101 got " & to_string(acc_out)
               severity error;

            -- Reset again, bootstrap ACC = 4 again (keeps test independent)
            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            alu_op <= "00";             -- ADD

            data_in          <= "0100";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0100"
               report "TC5: re-bootstrap expected ACC=0100 got " & to_string(acc_out)
               severity error;

            -- TEMP = 1 again
            data_in          <= "0001";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            -- SUB: 4 - 1 = 3
            alu_op      <= "01";
            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0011"
               report "TC5: SUB failed, expected 0011 got " & to_string(acc_out)
               severity error;

         -- =========================================================
         -- TC6: carry flag stability (carry should NOT change unless acc_load_en=1)
         -- =========================================================
         elsif run("tc6_carry_hold") then

            -- clean reset
            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            alu_op <= "00";             -- ADD

            -- Make carry = 1 by doing 15 + 1
            -- Bootstrap ACC = 15
            data_in          <= "1111";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            -- TEMP = 1
            data_in          <= "0001";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            -- Load: ACC = 15+1 = 0, C should become 1
            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert (acc_out = "0000" and c_flag = '1')
               report "TC6: expected after overflow ACC=0000 C=1 got ACC=" &
               to_string(acc_out) & " C=" & to_string(c_flag)
               severity error;

            -- Now change TEMP to something that would produce a different carry,
            -- but DO NOT load ACC. c_flag must stay 1.
            data_in          <= "1111";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            -- let ALU “run” a cycle without loading
            wait until rising_edge(clk);

            wait for 1 ns;
            assert c_flag = '1'
               report "TC6: carry flag changed without acc_load_en"
               severity error;

         -- =========================================================
         -- TC7: randomized-ish quick sweep (a few ops chained)
         -- Makes sim longer + catches sequencing bugs
         -- =========================================================
         elsif run("tc7_long_chain") then

            -- clean reset
            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            -- Start with ADD
            alu_op <= "00";

            -- ACC = 0 + 2 = 2
            data_in          <= "0010";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0010"
               report "TC7: expected ACC=2 got " & to_string(acc_out)
               severity error;

            -- ACC = 2 + 7 = 9
            data_in          <= "0111";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "1001"
               report "TC7: expected ACC=9 got " & to_string(acc_out)
               severity error;

            -- SUB: ACC = 9 - 3 = 6
            alu_op <= "01";

            data_in          <= "0011";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0110"
               report "TC7: expected ACC=6 got " & to_string(acc_out)
               severity error;

            -- ADD: ACC = 6 + 10 = 0 (16) -> 0, C should go 1
            alu_op <= "00";

            data_in          <= "1010";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert (acc_out = "0000" and c_flag = '1')
               report "TC7: expected ACC wrap to 0 and C=1, got ACC=" &
               to_string(acc_out) & " C=" & to_string(c_flag)
               severity error;

         -- =========================================================
         -- TC8: ADD identity (ACC + 0 = ACC), carry should be 0
         -- =========================================================
         elsif run("tc8_add_identity") then

            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            alu_op <= "00";             -- ADD

            -- ACC = 0 + 9 = 9
            data_in          <= "1001";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "1001"
               report "TC8: bootstrap expected ACC=1001 got " & to_string(acc_out)
               severity error;

            -- TEMP = 0
            data_in          <= "0000";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            -- ACC = 9 + 0 = 9
            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert (acc_out = "1001" and c_flag = '0')
               report "TC8: expected ACC stay 1001 and C=0 got ACC=" &
               to_string(acc_out) & " C=" & to_string(c_flag)
               severity error;

         -- =========================================================
         -- TC9: SUB identity (ACC - 0 = ACC)
         -- =========================================================
         elsif run("tc9_sub_identity") then

            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            -- Bootstrap ACC = 6 via ADD
            alu_op           <= "00";
            data_in          <= "0110";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0110"
               report "TC9: bootstrap expected ACC=0110 got " & to_string(acc_out)
               severity error;

            -- SUB with TEMP=0
            alu_op           <= "01";
            data_in          <= "0000";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0110"
               report "TC9: expected ACC remain 0110 got " & to_string(acc_out)
               severity error;

         -- =========================================================
         -- TC10: ADD carry boundary (8 + 8 = 0, C=1)
         -- =========================================================
         elsif run("tc10_add_8_plus_8") then

            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            alu_op <= "00";

            -- ACC = 0 + 8 = 8
            data_in          <= "1000";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            wait for 1 ns;
            assert acc_out = "1000"
               report "TC10: bootstrap expected ACC=1000 got " & to_string(acc_out)
               severity error;

            -- TEMP = 8, ACC = 8+8 = 0 C=1
            data_in          <= "1000";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert (acc_out = "0000" and c_flag = '1')
               report "TC10: expected ACC=0000 C=1 got ACC=" &
               to_string(acc_out) & " C=" & to_string(c_flag)
               severity error;

         -- =========================================================
         -- TC11: SUB wrap (0 - 1 = 15)
         -- =========================================================
         elsif run("tc11_sub_wrap_0_minus_1") then

            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            -- ACC should start 0 after reset
            wait for 1 ns;
            assert acc_out = "0000"
               report "TC11: expected ACC=0000 after reset got " & to_string(acc_out)
               severity error;

            -- TEMP = 1
            data_in          <= "0001";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            -- SUB
            alu_op      <= "01";
            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "1111"
               report "TC11: expected 0-1=1111 got " & to_string(acc_out)
               severity error;

         -- =========================================================
         -- TC12: AND operation (A & B)
         -- op="10" -> logical_and
         -- =========================================================
         elsif run("tc12_and_basic") then

            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            -- Bootstrap ACC = 1100 via ADD
            alu_op           <= "00";
            data_in          <= "1100";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            wait for 1 ns;
            assert acc_out = "1100"
               report "TC12: bootstrap expected ACC=1100 got " & to_string(acc_out)
               severity error;

            -- TEMP = 1010
            data_in          <= "1010";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            -- AND: 1100 & 1010 = 1000
            alu_op      <= "10";
            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "1000"
               report "TC12: expected AND result 1000 got " & to_string(acc_out)
               severity error;

         -- =========================================================
         -- TC13: NOT(B) operation
         -- op="11" -> b_inv
         -- =========================================================
         elsif run("tc13_not_b") then

            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            -- Make ACC something arbitrary (doesn't matter for NOT)
            alu_op           <= "00";
            data_in          <= "0011";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            -- TEMP = 0101 -> NOT = 1010
            data_in          <= "0101";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            alu_op      <= "11";        -- NOT(b)
            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "1010"
               report "TC13: expected NOT(0101)=1010 got " & to_string(acc_out)
               severity error;

         -- =========================================================
         -- TC14: carry should clear on a non-carry add (after a carry event)
         -- =========================================================
         elsif run("tc14_carry_clears") then

            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            alu_op <= "00";             -- ADD

            -- ACC = 15
            data_in          <= "1111";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            -- TEMP = 1, overflow -> ACC=0, C=1
            data_in          <= "0001";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            wait for 1 ns;
            assert (acc_out = "0000" and c_flag = '1')
               report "TC14: expected overflow C=1 got ACC=" &
               to_string(acc_out) & " C=" & to_string(c_flag)
               severity error;

            -- Now add 0 -> no carry, C should become 0 after load
            data_in          <= "0000";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            wait for 1 ns;
            assert c_flag = '0'
               report "TC14: expected carry cleared to 0, got C=" & to_string(c_flag)
               severity error;

         -- =========================================================
         -- TC15: multiple ADDs in a row (stress sequencing)
         -- =========================================================
         elsif run("tc15_multi_add") then

            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            alu_op <= "00";

            -- ACC = 0 + 1 = 1
            data_in          <= "0001";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            -- ACC = 1 + 2 = 3
            data_in          <= "0010";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            -- ACC = 3 + 4 = 7
            data_in          <= "0100";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            -- ACC = 7 + 8 = 15
            data_in          <= "1000";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            wait for 1 ns;
            assert acc_out = "1111"
               report "TC15: expected ACC=1111 got " & to_string(acc_out)
               severity error;

         -- =========================================================
         -- TC16: multiple SUBs in a row (stress sequencing)
         -- =========================================================
         elsif run("tc16_multi_sub") then

            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            -- Bootstrap ACC = 12 via ADD
            alu_op           <= "00";
            data_in          <= "1100";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            -- SUB mode
            alu_op <= "01";

            -- ACC = 12 - 1 = 11
            data_in          <= "0001";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            -- ACC = 11 - 2 = 9
            data_in          <= "0010";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            -- ACC = 9 - 9 = 0
            data_in          <= "1001";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            wait for 1 ns;
            assert acc_out = "0000"
               report "TC16: expected ACC=0000 got " & to_string(acc_out)
               severity error;

         -- =========================================================
         -- TC17: mixed logic then arithmetic (AND -> ADD)
         -- =========================================================
         elsif run("tc17_and_then_add") then

            rstn <= '0';
            wait for 2*clk_period;
            wait until rising_edge(clk);
            rstn <= '1';
            wait until rising_edge(clk);

            -- Bootstrap ACC = 1101
            alu_op           <= "00";
            data_in          <= "1101";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';
            acc_load_en      <= '1';
            wait until rising_edge(clk);
            acc_load_en      <= '0';

            -- TEMP = 0110, AND -> 0100
            data_in          <= "0110";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            alu_op      <= "10";        -- AND
            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0100"
               report "TC17: expected AND result 0100 got " & to_string(acc_out)
               severity error;

            -- Now ADD + 3 -> 0100 + 0011 = 0111
            alu_op           <= "00";
            data_in          <= "0011";
            temp_reg_load_en <= '1';
            wait until rising_edge(clk);
            temp_reg_load_en <= '0';

            acc_load_en <= '1';
            wait until rising_edge(clk);
            acc_load_en <= '0';

            wait for 1 ns;
            assert acc_out = "0111"
               report "TC17: expected final ACC=0111 got " & to_string(acc_out)
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

