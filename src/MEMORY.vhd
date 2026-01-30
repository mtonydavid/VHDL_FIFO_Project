library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MEMORY is
  port(
    CLK      : in  std_logic;
    RST      : in  std_logic;
    PUSH_BUF : in  std_logic;  -- Segnale di write enable bufferizzato
    DIN      : in  std_logic_vector(7 downto 0);
    WP       : in  std_logic_vector(2 downto 0);  -- Write pointer
    RP       : in  std_logic_vector(2 downto 0);  -- Read pointer
    DOUT     : out std_logic_vector(7 downto 0)
  );
end MEMORY;

architecture STRUCTURAL of MEMORY is
  
  component DEMUX_1TO8 is
    port(Z : in std_logic; 
         S : in std_logic_vector(2 downto 0);
         X : out std_logic_vector(7 downto 0));
  end component;
  
  component REG_PP is
    generic(N : integer := 8);
    port(CLK, RST, CE : in std_logic;
         D : in std_logic_vector(N-1 downto 0);
         Q : out std_logic_vector(N-1 downto 0));
  end component;
  
  component MUX_8TO1 is
    generic(N : integer := 8);
    port(X0, X1, X2, X3, X4, X5, X6, X7 : in std_logic_vector(N-1 downto 0);
         S : in std_logic_vector(2 downto 0);
         Z : out std_logic_vector(N-1 downto 0));
  end component;
  
  -- Array di uscite dei registri
  type mem_array_type is array (0 to 7) of std_logic_vector(7 downto 0);
  signal mem_array : mem_array_type;
  
  -- Segnali di Clock Enable per i registri
  signal ce_array : std_logic_vector(7 downto 0);
  
begin
  
  -- DEMUX: WP seleziona quale registro abilitare alla scrittura
  DEMUX_WRITE: DEMUX_1TO8 port map(
    Z => PUSH_BUF,
    S => WP,
    X => ce_array
  );
  
  -- Array di 8 registri P/P
  GEN_REGS: for i in 0 to 7 generate
    REGi: REG_PP
      generic map(N => 8)
      port map(
        CLK => CLK,
        RST => RST,
        CE  => ce_array(i),
        D   => DIN,
        Q   => mem_array(i)
      );
  end generate;
  
  -- MUX: RP seleziona quale registro leggere
  MUX_READ: MUX_8TO1
    generic map(N => 8)
    port map(
      X0 => mem_array(0),
      X1 => mem_array(1),
      X2 => mem_array(2),
      X3 => mem_array(3),
      X4 => mem_array(4),
      X5 => mem_array(5),
      X6 => mem_array(6),
      X7 => mem_array(7),
      S  => RP,
      Z  => DOUT
    );
  
end STRUCTURAL;