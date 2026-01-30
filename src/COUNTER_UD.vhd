library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity COUNTER_UD is
  port(
    CLK   : in  std_logic;
    RST   : in  std_logic;
    STEP  : in  std_logic;  -- Enable increment/decrement
    DECR  : in  std_logic;  -- 0=increment, 1=decrement
    CLEAR : in  std_logic;
    COUNT : out std_logic_vector(3 downto 0)
  );
end COUNTER_UD;

architecture STRUCTURAL of COUNTER_UD is
  
  component REG_PP is
    generic(N : integer := 4);
    port(CLK, RST, CE : in std_logic;
         D : in std_logic_vector(N-1 downto 0);
         Q : out std_logic_vector(N-1 downto 0));
  end component;
  
  component RCAS is
    generic(N : integer := 4);
    port(X, Y : in std_logic_vector(N-1 downto 0);
         UD : in std_logic;
         S : out std_logic_vector(N-1 downto 0);
         COUT : out std_logic);
  end component;
  
  signal count_reg : std_logic_vector(3 downto 0);
  signal count_next : std_logic_vector(3 downto 0);
  signal count_mod : std_logic_vector(3 downto 0);
  signal ce : std_logic;
  signal cout_dummy : std_logic;
  
begin
  
  -- CE = CLEAR OR STEP
  ce <= CLEAR or STEP;
  
  -- Ripple Carry Adder/Subtractor: count_reg +/- 1
  ADDSUB: RCAS
    generic map(N => 4)
    port map(
      X    => count_reg,
      Y    => "0001",  -- +1 o -1
      UD   => DECR,    -- 0=add, 1=subtract
      S    => count_mod,
      COUT => cout_dummy
    );
  
  -- MUX: se CLEAR azzera, altrimenti incrementa/decrementa
  count_next <= (others => '0') when CLEAR = '1' else count_mod;
  
  -- Registro
  REG: REG_PP
    generic map(N => 4)
    port map(
      CLK => CLK,
      RST => RST,
      CE  => ce,
      D   => count_next,
      Q   => count_reg
    );
  
  COUNT <= count_reg;
  
end STRUCTURAL;