library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_DFF is
end TB_DFF;

architecture BEHAVIORAL of TB_DFF is
    
    component DFF is
        port(CLK, RST, D : in std_logic; Q : out std_logic);
    end component;
    
    signal CLK : std_logic := '0';
    signal RST, D : std_logic := '0';
    signal Q : std_logic;
    
begin
    
    UUT: DFF port map(CLK => CLK, RST => RST, D => D, Q => Q);
    
    -- Clock 100 MHz
    CLK <= not CLK after 5 ns;
    
    process
    begin
        -- Reset
        RST <= '1';
        D <= '1';
        wait for 30 ns;
        
        -- Togli reset, prova D=1
        RST <= '0';
        D <= '1';
        wait for 20 ns;
        
        -- D=0
        D <= '0';
        wait for 30 ns;
        
        -- D=1 di nuovo
        D <= '1';
        wait for 40 ns;
        
        wait;
    end process;
    
end BEHAVIORAL;