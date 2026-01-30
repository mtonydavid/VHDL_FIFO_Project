library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity REG_PP is
    generic(
        N : integer := 8
    );
    port(
        CLK : in  std_logic;
        RST : in  std_logic;
        CE  : in  std_logic; -- Clock Enable
        D   : in  std_logic_vector(N-1 downto 0);
        Q   : out std_logic_vector(N-1 downto 0)
    );
end REG_PP;


architecture RTL of REG_PP is
begin

    process(CLK, RST)
    begin
        if RST = '1' then
            Q <= (others => '0');             
        elsif(CLK'event and CLK = '1') then
            if CE = '1' then
                Q <= D; 
            end if;
        end if;
    end process;

end RTL;