library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_MUX_8TO1 is
end TB_MUX_8TO1;

architecture BEHAVIORAL of TB_MUX_8TO1 is
    
    component MUX_8TO1 is
        generic(N : integer := 8);
        port(X0, X1, X2, X3, X4, X5, X6, X7 : in std_logic_vector(N-1 downto 0);
             S : in std_logic_vector(2 downto 0);
             Z : out std_logic_vector(N-1 downto 0));
    end component;
    
    signal X0, X1, X2, X3, X4, X5, X6, X7 : std_logic_vector(7 downto 0);
    signal S : std_logic_vector(2 downto 0) := "000";
    signal Z : std_logic_vector(7 downto 0);
    
begin

    UUT: MUX_8TO1 
        generic map(N => 8)
        port map(
            X0 => X0, X1 => X1, X2 => X2, X3 => X3,
            X4 => X4, X5 => X5, X6 => X6, X7 => X7,
            S => S, Z => Z
        );
    
    process
    begin
        X0 <= x"00";
        X1 <= x"11";
        X2 <= x"22";
        X3 <= x"33"; 
        X4 <= x"44";
        X5 <= x"55";
        X6 <= x"66";
        X7 <= x"77";
        
        -- Attendi un attimo che i segnali si stabilizzino
        wait for 10 ns;

        -- 2. TEST SEQUENZA SELEZIONE
        
        -- Seleziona X0 (Atteso: 00)
        S <= "000";
        wait for 20 ns;
        
        -- Seleziona X1 (Atteso: 11)
        S <= "001";
        wait for 20 ns;
        
        -- Seleziona X2 (Atteso: 22)
        S <= "010";
        wait for 20 ns;
        
        -- Seleziona X3 (Atteso: 33)
        S <= "011";
        wait for 20 ns;
        
        -- Seleziona X4 (Atteso: 44)
        S <= "100";
        wait for 20 ns;
        
        -- Seleziona X5 (Atteso: 55)
        S <= "101";
        wait for 20 ns;
        
        -- Seleziona X6 (Atteso: 66)
        S <= "110";
        wait for 20 ns;
        
        -- Seleziona X7 (Atteso: 77)
        S <= "111";
        wait for 20 ns;
       
        -- Torna a X0
        S <= "000";
        wait for 20 ns;
        
        -- Cambia valore di X3 e riselezionalo
        X3 <= x"FF"; 
        S <= "011";
        wait for 20 ns;
        
        wait;
    end process;
    
end BEHAVIORAL;