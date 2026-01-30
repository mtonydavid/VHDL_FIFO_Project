library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FIFO_QUEUE is
  port(
    CLK        : in  std_logic;
    RST        : in  std_logic;
    DIN        : in  std_logic_vector(7 downto 0);
    PUSH       : in  std_logic;
    POP        : in  std_logic;
    CLEAR      : in  std_logic;
    DOUT       : out std_logic_vector(7 downto 0);
    ISFULL     : out std_logic;
    ISEMPTY    : out std_logic;
    PUSHERROR  : out std_logic;
    POPERROR   : out std_logic
  );
end FIFO_QUEUE;

architecture STRUCTURAL of FIFO_QUEUE is

  component DFF is
    port(CLK, RST, D : in std_logic; 
         Q : out std_logic);
  end component;
  
  component REG_PP is
    generic(N : integer := 8);
    port(CLK, RST, CE : in std_logic;
         D : in std_logic_vector(N-1 downto 0);
         Q : out std_logic_vector(N-1 downto 0));
  end component;
  
  component COUNTER_MOD8 is
    port(CLK, RST, INCR, CLEAR : in std_logic;
         COUNT : out std_logic_vector(2 downto 0));
  end component;
  
  component COUNTER_UD is
    port(CLK, RST, STEP, DECR, CLEAR : in std_logic;
         COUNT : out std_logic_vector(3 downto 0));
  end component;
  
  component MEMORY is
    port(CLK, RST, PUSH_BUF : in std_logic;
         DIN : in std_logic_vector(7 downto 0);
         WP, RP : in std_logic_vector(2 downto 0);
         DOUT : out std_logic_vector(7 downto 0));
  end component;

  -- Segnali bufferizzati (P/P §)
  signal din_buf : std_logic_vector(7 downto 0);
  signal push_buf : std_logic;
  signal pop_buf : std_logic;
  signal clear_buf : std_logic;
  
  -- Puntatori
  signal wp : std_logic_vector(2 downto 0);  -- Write pointer
  signal rp : std_logic_vector(2 downto 0);  -- Read pointer
  
  -- Contatore elementi
  signal ud_count : std_logic_vector(3 downto 0);
  
  -- Segnali unbuffered
  signal is_full_unbuf : std_logic;
  signal is_empty_unbuf : std_logic;
  
  -- Segnali checked
  signal push_checked : std_logic;
  signal pop_checked : std_logic;
  
  -- Segnale STEP per counter U/D
  signal step_signal : std_logic;
  
  -- Output memory (non bufferizzato)
  signal mem_out : std_logic_vector(7 downto 0);
  
  -- Output bufferizzato DOUT
  signal dout_internal : std_logic_vector(7 downto 0);
  
begin

  -- Buffer DIN (8 bit register)
  BUF_DIN: REG_PP
    generic map(N => 8)
    port map(
      CLK => CLK,
      RST => RST,
      CE  => '1',  -- Sempre abilitato
      D   => DIN,
      Q   => din_buf
    );
  
  -- Buffer PUSH (flip-flop D)
  BUF_PUSH: DFF port map(
    CLK => CLK,
    RST => RST,
    D   => PUSH,
    Q   => push_buf
  );
  
  -- Buffer POP (flip-flop D)
  BUF_POP: DFF port map(
    CLK => CLK,
    RST => RST,
    D   => POP,
    Q   => pop_buf
  );
  
  -- Buffer CLEAR (flip-flop D)
  BUF_CLEAR: DFF port map(
    CLK => CLK,
    RST => RST,
    D   => CLEAR,
    Q   => clear_buf
  );
  
  -- IS_FULL_UNBUF: coda piena quando counter = 8 ("1000")
  is_full_unbuf <= '1' when ud_count = "1000" else '0';
  
  -- IS_EMPTY_UNBUF: coda vuota quando counter = 0 ("0000")
  is_empty_unbuf <= '1' when ud_count = "0000" else '0';

  -- PUSH_CHECKED: PUSH valido solo se coda non piena
  push_checked <= push_buf and (not is_full_unbuf);
  
  -- POP_CHECKED: POP valido solo se coda non vuota
  pop_checked <= pop_buf and (not is_empty_unbuf);
  
  -- STEP: abilitazione modifica counter U/D
  -- STEP = PUSH_CHECKED OR POP_CHECKED
  step_signal <= push_checked or pop_checked;
  
  
  CNT_WP: COUNTER_MOD8 port map(
    CLK   => CLK,
    RST   => RST,
    INCR  => push_checked,  -- Incrementa solo se PUSH valido
    CLEAR => clear_buf,
    COUNT => wp
  );
  
  CNT_RP: COUNTER_MOD8 port map(
    CLK   => CLK,
    RST   => RST,
    INCR  => pop_checked,  -- Incrementa solo se POP valido
    CLEAR => clear_buf,
    COUNT => rp
  );
  
  CNT_UD: COUNTER_UD port map(
    CLK   => CLK,
    RST   => RST,
    STEP  => step_signal,    -- Abilita modifica
    DECR  => pop_checked,    -- 0=incrementa (PUSH), 1=decrementa (POP)
    CLEAR => clear_buf,
    COUNT => ud_count
  );
  
  MEM: MEMORY port map(
    CLK      => CLK,
    RST      => RST,
    PUSH_BUF => push_checked,  -- Write enable
    DIN      => din_buf,
    WP       => wp,
    RP       => rp,
    DOUT     => mem_out
  );
  -- Buffer DOUT: aggiornato solo quando POP valido
  BUF_DOUT: REG_PP
    generic map(N => 8)
    port map(
      CLK => CLK,
      RST => RST,
      CE  => pop_checked,  -- CE = POP_CHECKED
      D   => mem_out,
      Q   => dout_internal
    );
  
  DOUT <= dout_internal;
  
  process(CLK, RST)
  begin
    if RST = '1' then
      ISFULL  <= '0';
      ISEMPTY <= '1';  -- Dopo reset la coda è vuota
    elsif rising_edge(CLK) then
      ISFULL  <= is_full_unbuf;
      ISEMPTY <= is_empty_unbuf;
    end if;
  end process;
    
  process(CLK, RST)
  begin
    if RST = '1' then
      PUSHERROR <= '0';
      POPERROR  <= '0';
    elsif rising_edge(CLK) then
      -- Default: nessun errore
      PUSHERROR <= '0';
      POPERROR  <= '0';
      
      -- PUSHERROR: tentativo PUSH su coda piena
      if push_buf = '1' and is_full_unbuf = '1' then
        PUSHERROR <= '1';
      end if;
      
      -- POPERROR: tentativo POP su coda vuota
      if pop_buf = '1' and is_empty_unbuf = '1' then
        POPERROR <= '1';
      end if;
    end if;
  end process;
  
end STRUCTURAL;