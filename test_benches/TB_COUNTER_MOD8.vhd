library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_COUNTER_MOD8 is
end TB_COUNTER_MOD8;

architecture BEHAVIORAL of TB_COUNTER_MOD8 is
    
    component COUNTER_MOD8 is
        port(CLK, RST, INCR, CLEAR : in std_logic;
             COUNT : out std_logic_vector(2 downto 0));
    end component;
    
    signal CLK : std_logic := '0';
    signal RST, INCR, CLEAR : std_logic := '0';
    signal COUNT : std_logic_vector(2 downto 0);
    
begin
    
    UUT: COUNTER_MOD8 port map(
        CLK => CLK, RST => RST, INCR => INCR, 
        CLEAR => CLEAR, COUNT => COUNT
    );
    
    CLK <= not CLK after 5 ns;
    
    process
    begin
        -- Reset
        RST <= '1';
        wait for 20 ns;
        RST <= '0';
        wait for 10 ns;
        
        -- Incrementa 10 volte (per vedere wrap-around)
        for i in 1 to 10 loop
            INCR <= '1';
            wait for 10 ns;
            INCR <= '0';
            wait for 10 ns;
        end loop;
        
        -- Test CLEAR
        CLEAR <= '1';
        wait for 10 ns;
        CLEAR <= '0';
        wait for 10 ns;
        
        wait;
    end process;
    
end BEHAVIORAL;