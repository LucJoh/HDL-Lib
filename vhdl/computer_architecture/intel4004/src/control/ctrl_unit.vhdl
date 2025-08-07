-------------------------------------------------------------------------------
-- Title      : ctrl_unit
-- Project    : 
-------------------------------------------------------------------------------
-- File       : ctrl_unit.vhdl
-- Author     : lucjoh
-- Created    : 2025-07-19
-- Last update: 2025-07-27
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
    master_en    : in  std_ulogic;
    clk          : in  std_ulogic;
    rstn         : in  std_ulogic;
    instr        : in  std_ulogic_vector(7 downto 0);  -- 4-bit opcode + 4-bit reg addr
    acc_load_en  : out std_ulogic;
    reg_load_en  : out std_ulogic;
    alu_op       : out std_ulogic_vector(1 downto 0);
    data_bus_sel : out std_ulogic_vector(1 downto 0);
    pc_inc       : out std_ulogic
    );
end entity;

architecture rtl of ctrl_unit is

  type state_type is (FETCH, DECODE, EXECUTE);
  signal state, next_state : state_type;

  signal opcode   : std_ulogic_vector(3 downto 0);
  signal reg_addr : std_ulogic_vector(3 downto 0);

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
      if master_en = '1' then
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
        pc_inc     <= '0';
        -- Decode opcode and prepare signals
        case opcode is
          when "0000" =>                -- ADD
            alu_op     <= "00";         
            next_state <= EXECUTE;
          when "0001" =>                -- SUB
            alu_op     <= "01";         
            next_state <= EXECUTE;
          when "0010" =>                -- AND
            alu_op     <= "10";         
            next_state <= EXECUTE;
          when "0011" =>                -- B INV
            alu_op     <= "11";         
            next_state <= EXECUTE;
          when others =>
            next_state <= FETCH;        -- Invalid opcode, fetch next opcode
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

