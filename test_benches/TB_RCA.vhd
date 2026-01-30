library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_RCA is
end TB_RCA;

architecture BEHAVIORAL of TB_RCA is
    
    component RCA is
        generic(N : integer := 4);
        port(X, Y : in std_logic_vector(N-1 downto 0);
             CIN : in std_logic;
             S : out std_logic_vector(N-1 downto 0);
             COUT : out std_logic);
    end component;
    
    signal X   : std_logic_vector(3 downto 0) := "0000";
    signal Y   : std_logic_vector(3 downto 0) := "0000";
    signal CIN : std_logic := '0';
    signal S   : std_logic_vector(3 downto 0);
    signal COUT : std_logic;
    
begin
    
    UUT: RCA 
        generic map(N => 4)
        port map(X => X, Y => Y, CIN => CIN, S => S, COUT => COUT);
    
    process
    begin
        -- Test 1: 0 + 0
        X <= "0000";
        Y <= "0000";
        CIN <= '0';
        wait for 20 ns;
        
        -- Test 2: 3 + 5 = 8
        X <= "0011";
        Y <= "0101";
        CIN <= '0';
        wait for 20 ns;
        
        -- Test 3: 7 + 8 = 15
        X <= "0111";
        Y <= "1000";
        CIN <= '0';
        wait for 20 ns;
        
        -- Test 4: 15 + 1 = 16 (overflow)
        X <= "1111";
        Y <= "0001";
        CIN <= '0';
        wait for 20 ns;
        
        -- Test 5: 9 + 6 = 15
        X <= "1001";
        Y <= "0110";
        CIN <= '0';
        wait for 20 ns;
        
        -- Test 6: 0 + 0 + CIN = 1
        X <= "0000";
        Y <= "0000";
        CIN <= '1';
        wait for 20 ns;
        
        -- Test 7: 7 + 7 + CIN = 15
        X <= "0111";
        Y <= "0111";
        CIN <= '1';
        wait for 20 ns;
        
        wait;
    end process;
    
end BEHAVIORAL;