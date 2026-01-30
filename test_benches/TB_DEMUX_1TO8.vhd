library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_DEMUX_1TO8 is
end TB_DEMUX_1TO8;

architecture BEHAVIORAL of TB_DEMUX_1TO8 is
    
    component DEMUX_1TO8 is
        port(Z : in std_logic;
             S : in std_logic_vector(2 downto 0);
             X : out std_logic_vector(7 downto 0));
    end component;
    
    signal Z : std_logic := '0';
    signal S : std_logic_vector(2 downto 0) := "000";
    signal X : std_logic_vector(7 downto 0);
    
begin
    
    UUT: DEMUX_1TO8 port map(Z => Z, S => S, X => X);
    
    process
    begin
        -- Test con Z=0 (tutte uscite dovrebbero essere 0)
        Z <= '0';
        S <= "000";
        wait for 20 ns;
        
        S <= "011";
        wait for 20 ns;
        
        S <= "111";
        wait for 20 ns;
        
        -- Test con Z=1 (solo un'uscita alta) 
        Z <= '1';
        
        -- Seleziona uscita 0
        S <= "000";
        wait for 20 ns;
        
        -- Seleziona uscita 1
        S <= "001";
        wait for 20 ns;
        
        -- Seleziona uscita 2
        S <= "010";
        wait for 20 ns;
        
        -- Seleziona uscita 3
        S <= "011";
        wait for 20 ns;
        
        -- Seleziona uscita 4
        S <= "100";
        wait for 20 ns;
        
        -- Seleziona uscita 5
        S <= "101";
        wait for 20 ns;
        
        -- Seleziona uscita 6
        S <= "110";
        wait for 20 ns;
        
        -- Seleziona uscita 7
        S <= "111";
        wait for 20 ns;
        
        -- Torna a Z=0
        Z <= '0';
        wait for 20 ns;
        
        wait;
    end process;
    
end BEHAVIORAL;
