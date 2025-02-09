library vunit_lib;
context vunit_lib.vunit_context;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb is
  generic (
    runner_cfg   : string;
    channel_size : integer := 16;
    frame_size   : integer := channel_size * 4
    );
end entity;

architecture rtl of tb is

  signal clk        : std_ulogic                                 := '0';
  signal rstn       : std_ulogic                                 := '1';
  signal en         : std_ulogic                                 := '0';
  signal din        : std_ulogic                                 := '0';
  signal frame      : std_ulogic_vector(2*frame_size-1 downto 0) := (others => '0');
  signal ch1        : std_ulogic_vector(channel_size-1 downto 0) := (others => '0');
  signal ch2        : std_ulogic_vector(channel_size-1 downto 0) := (others => '0');
  signal ch3        : std_ulogic_vector(channel_size-1 downto 0) := (others => '0');
  signal ch4        : std_ulogic_vector(channel_size-1 downto 0) := (others => '0');

  constant clk_period : time := 10 ns;

begin

  -------------------------------------------------------------
  -- DUT
  -------------------------------------------------------------
  tdm_rx_inst : entity work.tdm_rx
    port map (
      clk  => clk,                      -- i 
      rstn => rstn,                     -- i 
      en   => en,                       -- i
      din  => din,                      -- i
      ch1  => ch1,                      -- o
      ch2  => ch2,                      -- o
      ch3  => ch3,                      -- o
      ch4  => ch4                       -- o 
      );

  --------------------------------------------------------------
  -- SYSTEM CLOCK GENERATION
  --------------------------------------------------------------
  clk <= not clk after clk_period / 2;

  --------------------------------------------------------------
  -- STIMULUS PROCESS
  --------------------------------------------------------------
  stimulus_process : process
  begin

    test_runner_setup(runner, runner_cfg);

    ------------------------------------------------------------
    -- RESET THE SYSTEM
    ------------------------------------------------------------
    -- rstn <= '0';
    -- wait for 20 ns;
    -- rstn <= '1';
    wait for 10000 ns;

    while test_suite loop

      if run("frame 1") then
        frame <= x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF";
        wait for 100 ns;
        en    <= '1';
        for i in frame_size-1 downto 0 loop
          wait until rising_edge(clk);
          din <= frame(i);
        end loop;
        en <= '0';
      elsif run("frame 2") then
        frame <= x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF";
      elsif run("frame 3") then
        frame <= x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF";
      elsif run("frame 4") then
        frame <= x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF";
      elsif run("frame 5") then
        frame <= x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF";
      elsif run("frame 6") then
        frame <= x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF";
      elsif run("frame 7") then
        frame <= x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF";
      elsif run("frame 8") then
        frame <= x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF";
      elsif run("frame 9") then
        frame <= x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF" & x"DEADBEEF";
      end if;

    end loop;

    report "-------- TEST FINISHED SUCESSFULLY --------";
    test_runner_cleanup(runner);
    wait;

  end process;

end architecture;
