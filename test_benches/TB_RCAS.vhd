library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_RCAS is
end TB_RCAS;

architecture BEHAVIORAL of TB_RCAS is
    
    component RCAS is
        generic(N : integer := 4);
        port(X, Y : in std_logic_vector(N-1 downto 0);
             UD : in std_logic;
             S : out std_logic_vector(N-1 downto 0);
             COUT : out std_logic);
    end component;
    
    signal X    : std_logic_vector(3 downto 0) := "0000";
    signal Y    : std_logic_vector(3 downto 0) := "0000";
    signal UD   : std_logic := '0';
    signal S    : std_logic_vector(3 downto 0);
    signal COUT : std_logic;
    
begin
    
    UUT: RCAS 
        generic map(N => 4)
        port map(X => X, Y => Y, UD => UD, S => S, COUT => COUT);
    
    process
    begin
        -- Test 1: 5 + 3 = 8
        X <= "0101";
        Y <= "0011";
        UD <= '0';
        wait for 20 ns;
        
        -- Test 2: 7 + 8 = 15
        X <= "0111";
        Y <= "1000";
        UD <= '0';
        wait for 20 ns;
        
        -- Test 3: 9 + 6 = 15
        X <= "1001";
        Y <= "0110";
        UD <= '0';
        wait for 20 ns;
        
        wait for 20 ns;        
        
        -- Test 4: 8 - 3 = 5
        X <= "1000";
        Y <= "0011";
        UD <= '1';
        wait for 20 ns;
        
        -- Test 5: 10 - 5 = 5
        X <= "1010";
        Y <= "0101";
        UD <= '1';
        wait for 20 ns;
        
        -- Test 6: 7 - 7 = 0
        X <= "0111";
        Y <= "0111";
        UD <= '1';
        wait for 20 ns;
        
        -- Test 7: 5 - 1 = 4
        X <= "0101";
        Y <= "0001";
        UD <= '1';
        wait for 20 ns;
            
        wait;
    end process;
    
end BEHAVIORAL;
