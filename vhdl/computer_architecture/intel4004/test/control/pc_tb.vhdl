library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library control;

entity pc_tb is
   generic (runner_cfg : string);
end pc_tb;

architecture rtl of pc_tb is

   signal clk  : std_logic := '0';
   signal rstn : std_logic := '1';
   signal inc  : std_logic := '0';
   signal pc   : natural   := 0;

begin

   i_dut : entity control.pc
      port map (
         clk  => clk,
         rstn => rstn,
         inc  => inc,
         pc   => pc
         );

   clk <= not clk after 10 ns;          -- 50 MHz clock

   process
   begin
      test_runner_setup(runner, runner_cfg);
      while test_suite loop

         -- Test increment
         if run("tc1") then
            wait for 100 ns;
            assert pc = 0 report "Increment error" severity error;
            inc <= '1';
            wait for 20 ns;
            assert pc = 1 report "Increment error" severity error;
            wait for 20 ns;
            assert pc = 2 report "Increment error" severity error;
            wait for 20 ns;
            assert pc = 3 report "Increment error" severity error;
            wait for 20 ns;
            assert pc = 4 report "Increment error" severity error;
         end if;

         -- Test reset
         if run("tc2") then
            inc  <= '1';
            wait for 20 ns;
            rstn <= '0';
            wait for 100 ns;
            assert pc = 0 report "Reset error" severity error;
         end if;

         -- Test increment and reset
         if run("tc3") then
            wait for 100 ns;
            assert pc = 0 report "Increment error" severity error;
            inc  <= '1';
            wait for 20 ns;
            assert pc = 1 report "Increment error" severity error;
            inc  <= '0';
            wait for 200 ns;
            assert pc = 1 report "Increment error" severity error;
            wait for 20 ns;
            rstn <= '0';
            wait for 1 ns;
            rstn <= '1';
            assert pc = 0 report "Increment error" severity error;
            wait for 1 ns;
            inc  <= '1';
            wait for 10 ms;
            rstn <= '0';
            wait for 1 ns;
            assert pc = 0 report "Increment error" severity error;
         end if;

      end loop;
      test_runner_cleanup(runner);
   end process;
end architecture;

