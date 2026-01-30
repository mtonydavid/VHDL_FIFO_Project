library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COUNTER_MOD8 is
  port(
    CLK   : in  std_logic;
    RST   : in  std_logic;
    INCR  : in  std_logic;
    CLEAR : in  std_logic;
    COUNT : out std_logic_vector(2 downto 0)
  );
end COUNTER_MOD8;

architecture STRUCTURAL of COUNTER_MOD8 is
  
  component REG_PP is
    generic(N : integer := 3);
    port(CLK, RST, CE : in std_logic;
         D : in std_logic_vector(N-1 downto 0);
         Q : out std_logic_vector(N-1 downto 0));
  end component;
  
  component RCA is
    generic(N : integer := 3);
    port(X, Y : in std_logic_vector(N-1 downto 0);
         CIN : in std_logic;
         S : out std_logic_vector(N-1 downto 0);
         COUT : out std_logic);
  end component;
  
  signal count_reg : std_logic_vector(2 downto 0);
  signal count_next : std_logic_vector(2 downto 0);
  signal count_incr : std_logic_vector(2 downto 0);
  signal ce : std_logic;
  signal cout_dummy : std_logic;
  
begin
  
  -- CE = CLEAR OR INCR
  ce <= CLEAR or INCR;
  
  -- Ripple Carry Adder: count_reg + 001
  ADDER: RCA
    generic map(N => 3)
    port map(
      X    => count_reg,
      Y    => "001",  -- +1
      CIN  => '0',
      S    => count_incr,
      COUT => cout_dummy
    );
  
  -- MUX: se CLEAR azzera, altrimenti incrementa
  count_next <= "000" when CLEAR = '1' else count_incr;
  
  -- Registro
  REG: REG_PP
    generic map(N => 3)
    port map(
      CLK => CLK,
      RST => RST,
      CE  => ce,
      D   => count_next,
      Q   => count_reg
    );
  
  COUNT <= count_reg;
  

end STRUCTURAL;
