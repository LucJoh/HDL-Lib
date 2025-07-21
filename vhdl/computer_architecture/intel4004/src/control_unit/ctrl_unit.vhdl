-------------------------------------------------------------------------------
-- Title      : ctrl_unit
-- Project    : 
-------------------------------------------------------------------------------
-- File       : ctrl_unit.vhdl
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
-- 2025-07-19  1.0      lucjoh  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctrl_unit is
  port (
    ctrl_unit_en : in  std_logic;
    clk          : in  std_logic;
    rstn         : in  std_logic;
    instr        : in  std_logic_vector(7 downto 0);  -- 4-bit opcode + 4-bit reg addr
    acc_load_en  : out std_logic;
    reg_load_en  : out std_logic;
    alu_op       : out std_logic_vector(1 downto 0);
    data_bus_sel : out std_logic_vector(1 downto 0);
    pc_inc       : out std_logic
    );
end entity;

architecture rtl of ctrl_unit is

  type state_type is (FETCH, DECODE, EXECUTE);
  signal state, next_state : state_type;

  signal opcode   : std_logic_vector(3 downto 0);
  signal reg_addr : std_logic_vector(3 downto 0);

begin

  -- Separate opcode and reg_addr
  opcode   <= instr(7 downto 4);
  reg_addr <= instr(3 downto 0);

  -- State register
  process(clk, rstn)
  begin
    if rstn = '0' then
      state <= FETCH;
    elsif rising_edge(clk) then
      if ctrl_unit_en = '1' then
        state <= next_state;
      end if;
    end if;
  end process;

  -- Next state logic and outputs
  process(state, opcode)
  begin
    -- Default outputs
    acc_load_en  <= '0';
    reg_load_en  <= '0';
    alu_op       <= (others => '0');
    data_bus_sel <= (others => '0');
    pc_inc       <= '0';

    case state is
      when FETCH =>
        pc_inc     <= '1';              -- Increment PC to next instruction
        next_state <= DECODE;

      when DECODE =>
        -- Decode opcode and prepare signals
        case opcode is
          when "0000" =>                -- ADD reg
            alu_op     <= "00";         -- ADD
            next_state <= EXECUTE;
          when "0001" =>                -- SUB reg
            alu_op     <= "01";         -- SUB
            next_state <= EXECUTE;
          when "0010" =>                -- LOAD reg
            alu_op     <= "10";         -- LOAD (pass through)
            next_state <= EXECUTE;
          when "0011" =>                -- STORE reg
            alu_op     <= "11";         -- STORE (pass through)
            next_state <= EXECUTE;
          when others =>
            next_state <= FETCH;        -- Invalid opcode, just fetch next
        end case;

      when EXECUTE =>
        case opcode is
          when "0000" | "0001" | "0010" =>
            acc_load_en <= '1';  -- Load accumulator after ALU op or LOAD
            pc_inc      <= '1';         -- Increment PC after instruction
          when "0011" =>
            reg_load_en <= '1';         -- STORE accumulator to reg
            pc_inc      <= '1';
          when others =>
            null;
        end case;
        next_state <= FETCH;

      when others =>
        next_state <= FETCH;
    end case;
  end process;

end architecture;

