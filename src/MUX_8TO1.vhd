library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_8TO1 is
  generic(
    N : integer := 8
  );
  port(
    X0, X1, X2, X3, X4, X5, X6, X7 : in  std_logic_vector(N-1 downto 0);
    S  : in  std_logic_vector(2 downto 0);
    Z  : out std_logic_vector(N-1 downto 0)
  );
end MUX_8TO1;

architecture RTL of MUX_8TO1 is
begin
  
  with S select
    Z <= X0 when "000",
         X1 when "001",
         X2 when "010",
         X3 when "011",
         X4 when "100",
         X5 when "101",
         X6 when "110",
         X7 when "111",
         (others => '0') when others;
  
end RTL;