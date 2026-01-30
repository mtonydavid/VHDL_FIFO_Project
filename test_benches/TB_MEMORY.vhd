library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_MEMORY is
end TB_MEMORY;

architecture BEHAVIORAL of TB_MEMORY is
    
    component MEMORY is
        port(CLK, RST, PUSH_BUF : in std_logic;
             DIN : in std_logic_vector(7 downto 0);
             WP, RP : in std_logic_vector(2 downto 0);
             DOUT : out std_logic_vector(7 downto 0));
    end component;
    
    signal CLK : std_logic := '0';
    signal RST, PUSH_BUF : std_logic := '0';
    signal DIN : std_logic_vector(7 downto 0) := x"00";
    signal WP, RP : std_logic_vector(2 downto 0) := "000";
    signal DOUT : std_logic_vector(7 downto 0);
    
begin
    
    UUT: MEMORY port map(
        CLK => CLK, RST => RST, PUSH_BUF => PUSH_BUF,
        DIN => DIN, WP => WP, RP => RP, DOUT => DOUT
    );
    
    CLK <= not CLK after 5 ns;
    
    process
    begin
        -- Reset
        RST <= '1';
        wait for 20 ns;
        RST <= '0';
        wait for 10 ns;
        
        -- Scrivi in posizione 0
        WP <= "000";
        DIN <= x"AA";
        PUSH_BUF <= '1';
        wait for 10 ns;
        PUSH_BUF <= '0';
        wait for 20 ns;
        
        -- Scrivi in posizione 1
        WP <= "001";
        DIN <= x"BB";
        PUSH_BUF <= '1';
        wait for 10 ns;
        PUSH_BUF <= '0';
        wait for 20 ns;
        
        -- Scrivi in posizione 2
        WP <= "010";
        DIN <= x"CC";
        PUSH_BUF <= '1';
        wait for 10 ns;
        PUSH_BUF <= '0';
        wait for 20 ns;
        
        -- Leggi da posizione 0
        RP <= "000";
        wait for 20 ns;
        
        -- Leggi da posizione 1
        RP <= "001";
        wait for 20 ns;
        
        -- Leggi da posizione 2
        RP <= "010";
        wait for 20 ns;
        
        wait;
    end process;
    
end BEHAVIORAL;