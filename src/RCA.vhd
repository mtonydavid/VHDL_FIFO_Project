library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCA is
  generic(
    N : integer := 8
  );
  port(
    X    : in  std_logic_vector(N-1 downto 0);
    Y    : in  std_logic_vector(N-1 downto 0);
    CIN  : in  std_logic;
    S    : out std_logic_vector(N-1 downto 0);
    COUT : out std_logic
  );
end RCA;

architecture STRUCTURAL of RCA is
  
  component FA is
    port(X, Y, CIN : in std_logic; S, COUT : out std_logic);
  end component;
  
  signal carry : std_logic_vector(N downto 0);
  
begin
  
  carry(0) <= CIN;
  
  gen_fa: for i in 0 to N-1 generate
    FAi: FA port map(
      X    => X(i),
      Y    => Y(i),
      CIN  => carry(i),
      S    => S(i),
      COUT => carry(i+1)
    );
  end generate;
  
  COUT <= carry(N);
  
end STRUCTURAL;