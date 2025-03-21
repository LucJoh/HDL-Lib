library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tdm_rx is
  generic (
    channel_size : natural := 4
    );
  port (
    clk  : in  std_ulogic;
    rstn : in  std_ulogic;
    en   : in  std_ulogic;
    din  : in  std_ulogic;
    done : out std_ulogic;
    ch1  : out std_ulogic_vector(channel_size-1 downto 0);
    ch2  : out std_ulogic_vector(channel_size-1 downto 0);
    ch3  : out std_ulogic_vector(channel_size-1 downto 0);
    ch4  : out std_ulogic_vector(channel_size-1 downto 0)
    );
end entity;

architecture logic of tdm_rx is

  signal frame     : std_ulogic_vector(4*channel_size-1 downto 0) := (others => '0');
  signal frame_cnt : integer                                      := 0;

begin

  process(clk, rstn)
  begin
    if rstn = '0' then
      ch1       <= (others => 'Z');
      ch2       <= (others => 'Z');
      ch3       <= (others => 'Z');
      ch4       <= (others => 'Z');
      frame_cnt <= 0;
    elsif rising_edge(clk) then
      if en = '1' then
        if frame_cnt = 4*channel_size then
          ch1       <= frame(4*channel_size-1 downto 3*channel_size);
          ch2       <= frame(3*channel_size-1 downto 2*channel_size);
          ch3       <= frame(2*channel_size-1 downto channel_size);
          ch4       <= frame(channel_size-1 downto 0);
          done      <= '1';
          frame_cnt <= 0;
        else
          frame     <= din & frame(4*channel_size-1 downto 1);
          ch1       <= (others => 'Z');
          ch2       <= (others => 'Z');
          ch3       <= (others => 'Z');
          ch4       <= (others => 'Z');
          done      <= '0';
          frame_cnt <= frame_cnt + 1;
        end if;
      end if;
    end if;
  end process;

end architecture;

