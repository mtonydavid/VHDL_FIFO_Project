library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_COUNTER_UD is
end TB_COUNTER_UD;

architecture BEHAVIORAL of TB_COUNTER_UD is
    
    component COUNTER_UD is
        port(CLK, RST, STEP, DECR, CLEAR : in std_logic;
             COUNT : out std_logic_vector(3 downto 0));
    end component;
    
    signal CLK : std_logic := '0';
    signal RST, STEP, DECR, CLEAR : std_logic := '0';
    signal COUNT : std_logic_vector(3 downto 0);
    
begin
    
    UUT: COUNTER_UD port map(
        CLK => CLK, RST => RST, STEP => STEP, 
        DECR => DECR, CLEAR => CLEAR, COUNT => COUNT
    );
    
    CLK <= not CLK after 5 ns;
    
    process
    begin
        -- Reset
        RST <= '1';
        wait for 20 ns;
        RST <= '0';
        wait for 10 ns;
        
        -- Incrementa 5 volte (DECR=0)
        for i in 1 to 5 loop
            STEP <= '1';
            DECR <= '0';
            wait for 10 ns;
            STEP <= '0';
            wait for 10 ns;
        end loop;
        
        wait for 20 ns;
        
        -- Decrementa 3 volte (DECR=1)
        for i in 1 to 3 loop
            STEP <= '1';
            DECR <= '1';
            wait for 10 ns;
            STEP <= '0';
            DECR <= '0'; 
            wait for 10 ns;
        end loop;
        
        wait for 20 ns;
        
        -- Test CLEAR
        CLEAR <= '1';
        wait for 10 ns;
        CLEAR <= '0';
        wait for 10 ns;
        
        wait;
    end process;
    
end BEHAVIORAL;