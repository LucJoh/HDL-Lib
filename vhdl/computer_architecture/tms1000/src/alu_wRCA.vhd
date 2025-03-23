library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity alu_wRCA is
  port(alu_inA : in  std_logic_vector (7 downto 0);
       alu_inB : in  std_logic_vector (7 downto 0);
       alu_op  : in  std_logic_vector (1 downto 0);
       alu_out : out std_logic_vector (7 downto 0);
       C       : out std_logic;
       E       : out std_logic;
       Z       : out std_logic);
end alu_wRCA;

architecture dataflow of alu_wRCA is
  component RCA                         -- RCA component
    port(a    : in  std_logic_vector (7 downto 0);
         b    : in  std_logic_vector (7 downto 0);
         cin  : in  std_logic;
         s    : out std_logic_vector(7 downto 0);
         cout : out std_logic);
  end component;

  component cmp                         -- cmp component
    port(a : in  std_logic_vector (7 downto 0);
         b : in  std_logic_vector (7 downto 0);
         e : out std_logic);
  end component;

  component mux4to1
    port(w0 : in  std_logic_vector (7 downto 0);
         w1 : in  std_logic_vector (7 downto 0);
         w2 : in  std_logic_vector (7 downto 0);
         w3 : in  std_logic_vector (7 downto 0);
         s  : in  std_logic_vector (1 downto 0);
         f  : out std_logic_vector (7 downto 0));
  end component;

  signal sum              : std_logic_vector (7 downto 0);  -- result after RCA addition
  signal diff             : std_logic_vector (7 downto 0);  -- result after RCA subtraction
  signal b_inv            : std_logic_vector (7 downto 0);  -- inverse of B used for subtraction
  signal a_n_d            : std_logic_vector (7 downto 0);  -- alu_inA AND alu_inB
  signal a_inv            : std_logic_vector (7 downto 0);  -- inverse of A used in multiplexer
  signal sel              : std_logic_vector (7 downto 0);  -- selected operation in multiplexer
  signal comp             : std_logic;  -- result of cmp
  signal cout_addition    : std_logic;  -- carry out from RCA addition
  signal cout_subtraction : std_logic;  -- carry out from RCA subtraction

begin
  b_inv <= not alu_inB;                 -- inverting B
  a_inv <= not alu_inA;                 -- inverting A
  a_n_d <= alu_inA and alu_inB;         -- A AND B

  Addition    : RCA port map (alu_inA, alu_inB, '0', sum, cout_addition);  -- RCA used for addition
  Subtraction : RCA port map (alu_inA, b_inv, '1', diff, cout_subtraction);  -- RCA used for subtraction
  Comparison  : cmp port map (alu_inA, alu_inB, comp);  -- cmp used for comparison
  Selection   : mux4to1 port map (sum, diff, a_n_d, a_inv, alu_op, sel);  -- multiplexer

  with alu_op select
    C <= cout_addition when "00",       -- C-flag
    cout_subtraction   when "01",
    '0'                when others;

  alu_out <= sel;                       -- alu_out

  Z <= '1' when alu_inA = alu_inB else '0';  -- Z-flag

  E <= comp;                            -- E-flag

end dataflow;

