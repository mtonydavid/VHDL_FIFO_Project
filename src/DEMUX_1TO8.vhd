library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DEMUX_1TO8 is
  port(
    Z : in  std_logic;                      -- Input signal
    S : in  std_logic_vector(2 downto 0);   -- Selector
    X : out std_logic_vector(7 downto 0)    -- 8 outputs
  );
end DEMUX_1TO8;

architecture RTL of DEMUX_1TO8 is
begin
  
  process(Z, S)
  begin
    X <= (others => '0');
    
    case S is
      when "000" => X(0) <= Z;
      when "001" => X(1) <= Z;
      when "010" => X(2) <= Z;
      when "011" => X(3) <= Z;
      when "100" => X(4) <= Z;
      when "101" => X(5) <= Z;
      when "110" => X(6) <= Z;
      when "111" => X(7) <= Z;
      when others => X <= (others => '0');
    end case;
  end process;
  
end RTL;