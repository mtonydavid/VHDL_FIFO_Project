library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCAS is
  generic(
    N : integer := 4
  );
  port(
    X    : in  std_logic_vector(N-1 downto 0);
    Y    : in  std_logic_vector(N-1 downto 0);
    UD   : in  std_logic;  -- 0=add, 1=subtract
    S    : out std_logic_vector(N-1 downto 0);
    COUT : out std_logic
  );
end RCAS;

architecture STRUCTURAL of RCAS is
  
  component FA is
    port(X, Y, CIN : in std_logic; S, COUT : out std_logic);
  end component;
  
  signal y_xor : std_logic_vector(N-1 downto 0);
  signal carry : std_logic_vector(N downto 0);
  
begin
  
  -- Per sottrazione: complementa Y e aggiungi 1 tramite carry iniziale
  gen_xor: for i in 0 to N-1 generate
    y_xor(i) <= Y(i) xor UD;
  end generate;
  
  carry(0) <= UD;  -- CIN = UD (per complemento a 2)
  
  gen_fa: for i in 0 to N-1 generate
    FAi: FA port map(
      X    => X(i),
      Y    => y_xor(i),
      CIN  => carry(i),
      S    => S(i),
      COUT => carry(i+1)
    );
  end generate;
  
  COUT <= carry(N);
  
end STRUCTURAL;