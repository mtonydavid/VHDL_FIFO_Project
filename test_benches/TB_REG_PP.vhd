library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_REG_PP is
end TB_REG_PP;

architecture BEHAVIORAL of TB_REG_PP is
    
    component REG_PP is
        generic(N : integer := 8);
        port(CLK, RST, CE : in std_logic;
             D : in std_logic_vector(N-1 downto 0);
             Q : out std_logic_vector(N-1 downto 0));
    end component;
    
    signal CLK : std_logic := '0';
    signal RST, CE : std_logic := '0';
    signal D, Q : std_logic_vector(7 downto 0) := x"00";
    
begin
    
    UUT: REG_PP 
        generic map(N => 8)
        port map(CLK => CLK, RST => RST, CE => CE, D => D, Q => Q);
    
    CLK <= not CLK after 5 ns;
    
    process
    begin
        -- Reset
        RST <= '1';
        D <= x"FF";
        CE <= '1';
        wait for 20 ns;
        
        RST <= '0';
        wait for 10 ns;
        
        -- Scrivi 0xAA con CE=1
        D <= x"AA";
        CE <= '1';
        wait for 20 ns;
        
        -- Prova cambiare D con CE=0 (dovrebbe mantenere 0xAA)
        D <= x"BB";
        CE <= '0';
        wait for 30 ns;
        
        -- Scrivi 0xCC con CE=1
        D <= x"CC";
        CE <= '1';
        wait for 20 ns;
        
        wait;
    end process;
    
end BEHAVIORAL;