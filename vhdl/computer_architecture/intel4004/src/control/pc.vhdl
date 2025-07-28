-------------------------------------------------------------------------------
-- Title      : program counter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : pc.vhdl
-- Author     : lucjoh
-- Created    : 2025-07-19
-- Last update: 2025-07-19
-- Standard   : VHDL-2008
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2025 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-07-19  1.0      lucjoh	Created
-------------------------------------------------------------------------------

entity pc is
  generic (
    addr_width : natural := 12
    );
  port (
    clk    : in  std_logic;
    rstn   : in  std_logic;
    inc    : in  std_logic;
    pc_out : out std_logic_vector(addr_width-1 downto 0)
    );
end entity;

architecture rtl of pc is
  signal pc : std_logic_vector(addr_width-1 downto 0) := (others => '0');
begin
  process(clk, rstn)
  begin
    if rstn = '0' then
      pc <= (others => '0');
    elsif rising_edge(clk) then
      if inc = '1' then
        pc <= std_logic_vector(unsigned(pc) + 1);
      end if;
    end if;
  end process;

  pc_out <= pc;

end rtl;
