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

  signal clk   : std_ulogic                                 := '0';
  signal rstn  : std_ulogic                                 := '1';
  signal en    : std_ulogic                                 := '0';
  signal din   : std_ulogic                                 := '0';
  signal done  : std_ulogic                                 := '0';
  signal frame : std_ulogic_vector(frame_size-1 downto 0)   := (others => '0');
  signal ch1   : std_ulogic_vector(channel_size-1 downto 0) := (others => '0');
  signal ch2   : std_ulogic_vector(channel_size-1 downto 0) := (others => '0');
  signal ch3   : std_ulogic_vector(channel_size-1 downto 0) := (others => '0');
  signal ch4   : std_ulogic_vector(channel_size-1 downto 0) := (others => '0');

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
      done => done,                     -- o
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

      if run("tc1") then
        frame <= x"BABE" & x"BEEF" & x"DEAD" & x"CAFE";
        wait for 100 ns;
        en    <= '1';
        for i in 0 to frame_size-1 loop
          din <= frame(i);
          wait until rising_edge(clk);
        end loop;
        wait until rising_edge(done);
        en <= '0';
        assert ch1 = x"BABE" severity failure;
        assert ch2 = x"BEEF" severity failure;
        assert ch3 = x"DEAD" severity failure;
        assert ch4 = x"CAFE" severity failure;

      elsif run("tc2") then
        frame <= x"AAAA" & x"0000" & x"0000" & x"0000";
        wait for 100 ns;
        en    <= '1';
        for i in 0 to frame_size-1 loop
          din <= frame(i);
          wait until rising_edge(clk);
        end loop;
        wait until rising_edge(done);
        en <= '0';
        assert ch1 = x"AAAA" severity failure;
        assert ch2 = x"0000" severity failure;
        assert ch3 = x"0000" severity failure;
        assert ch4 = x"0000" severity failure;

      elsif run("tc3") then
        frame <= x"AAAA" & x"BBBB" & x"CCCC" & x"DDDD";
        wait for 100 ns;
        en    <= '1';
        for i in 0 to frame_size-1 loop
          din <= frame(i);
          wait until rising_edge(clk);
        end loop;
        wait until rising_edge(done);
        en <= '0';
        assert ch1 = x"AAAA" severity failure;
        assert ch2 = x"BBBB" severity failure;
        assert ch3 = x"CCCC" severity failure;
        assert ch4 = x"DDDD" severity failure;

      elsif run("tc4") then
        frame <= x"AAAA" & x"BBBB" & x"CCCC" & x"DDDD";
        wait for 100 ns;
        en    <= '1';
        for i in 0 to frame_size-1 loop
          din <= frame(i);
          wait until rising_edge(clk);
        end loop;
        wait until rising_edge(done);
        en   <= '0';
        rstn <= '0';                    -- Reset after frame transaction
        wait for clk_period*2;
        rstn <= '1';
        assert ch1 = "ZZZZZZZZZZZZZZZZ" severity failure;
        assert ch2 = "ZZZZZZZZZZZZZZZZ" severity failure;
        assert ch3 = "ZZZZZZZZZZZZZZZZ" severity failure;
        assert ch4 = "ZZZZZZZZZZZZZZZZ" severity failure;

      elsif run("tc5") then
        frame <= x"AAAA" & x"0000" & x"0000" & x"0000";
        wait for 100 ns;
        en    <= '1';
        for i in 0 to frame_size-1 loop
          din <= frame(i);
          wait until rising_edge(clk);
        end loop;
        wait until rising_edge(done);
        en <= '0';
        assert ch1 = x"AAAA" severity failure;
        assert ch2 = x"0000" severity failure;
        assert ch3 = x"0000" severity failure;
        assert ch4 = x"0000" severity failure;

      elsif run("tc6") then
        frame <= x"0000" & x"AAAA" & x"BBBB" & x"CCCC";
        wait for 100 ns;
        en    <= '1';
        for i in 0 to frame_size-1 loop
          din <= frame(i);
          wait until rising_edge(clk);
        end loop;
        wait until rising_edge(done);
        en <= '0';
        assert ch1 = x"0000" severity failure;
        assert ch2 = x"AAAA" severity failure;
        assert ch3 = x"BBBB" severity failure;
        assert ch4 = x"CCCC" severity failure;

      elsif run("tc7") then
        frame <= x"5555" & x"AAAA" & x"5555" & x"AAAA";
        wait for 100 ns;
        en    <= '1';
        for i in 0 to frame_size-1 loop
          din <= frame(i);
          wait until rising_edge(clk);
        end loop;
        wait until rising_edge(done);
        en <= '0';
        assert ch1 = x"5555" severity failure;
        assert ch2 = x"AAAA" severity failure;
        assert ch3 = x"5555" severity failure;
        assert ch4 = x"AAAA" severity failure;

      elsif run("tc8") then
        frame <= x"0000" & x"0000" & x"0000" & x"0000";
        wait for 100 ns;
        en    <= '1';
        for i in 0 to frame_size-1 loop
          din <= frame(i);
          wait until rising_edge(clk);
        end loop;
        wait until rising_edge(done);
        en <= '0';
        assert ch1 = x"0000" severity failure;
        assert ch2 = x"0000" severity failure;
        assert ch3 = x"0000" severity failure;
        assert ch4 = x"0000" severity failure;

      elsif run("tc9") then
        frame <= x"FFFF" & x"FFFF" & x"FFFF" & x"FFFF";
        wait for 100 ns;
        en    <= '1';
        for i in 0 to frame_size-1 loop
          din <= frame(i);
          wait until rising_edge(clk);
        end loop;
        wait until rising_edge(done);
        en <= '0';
        assert ch1 = x"FFFF" severity failure;
        assert ch2 = x"FFFF" severity failure;
        assert ch3 = x"FFFF" severity failure;
        assert ch4 = x"FFFF" severity failure;

      elsif run("tc10") then
        frame <= x"AAAA" & x"BBBB" & x"CCCC" & x"DDDD";
        wait for 100 ns;
        en    <= '1';
        for i in 0 to frame_size-1 loop
          din  <= frame(i);
          wait until rising_edge(clk);
          rstn <= not rstn;  -- Toggle reset in the middle of data transfer
        end loop;
--        wait until rising_edge(done);
        en <= '0';
        assert ch1 = "ZZZZZZZZZZZZZZZZ" severity failure;
        assert ch2 = "ZZZZZZZZZZZZZZZZ" severity failure;
        assert ch3 = "ZZZZZZZZZZZZZZZZ" severity failure;
        assert ch4 = "ZZZZZZZZZZZZZZZZ" severity failure;


      end if;

    end loop;

    report "-------- TEST FINISHED SUCESSFULLY --------";
    test_runner_cleanup(runner);
    wait;

  end process;

end architecture;
