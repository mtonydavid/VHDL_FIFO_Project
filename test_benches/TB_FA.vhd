library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_FA is
end TB_FA;

architecture BEHAVIORAL of TB_FA is
    
    component FA is
        port(X, Y, CIN : in std_logic; S, COUT : out std_logic);
    end component;
    
    signal X, Y, CIN : std_logic := '0';
    signal S, COUT : std_logic;
    
begin
    
    UUT: FA port map(X => X, Y => Y, CIN => CIN, S => S, COUT => COUT);
    
    process
    begin
        -- Prova tutte le combinazioni
        X <= '0'; Y <= '0'; CIN <= '0'; wait for 20 ns;
        X <= '0'; Y <= '0'; CIN <= '1'; wait for 20 ns;
        X <= '0'; Y <= '1'; CIN <= '0'; wait for 20 ns;
        X <= '0'; Y <= '1'; CIN <= '1'; wait for 20 ns;
        X <= '1'; Y <= '0'; CIN <= '0'; wait for 20 ns;
        X <= '1'; Y <= '0'; CIN <= '1'; wait for 20 ns;
        X <= '1'; Y <= '1'; CIN <= '0'; wait for 20 ns;
        X <= '1'; Y <= '1'; CIN <= '1'; wait for 20 ns;
        wait;
    end process;
    
end BEHAVIORAL;