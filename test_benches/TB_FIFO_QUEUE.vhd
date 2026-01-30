library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_FIFO_QUEUE is
end TB_FIFO_QUEUE;

architecture BEHAVIORAL of TB_FIFO_QUEUE is

    component FIFO_QUEUE
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
    end component;

    -- Segnali
    signal CLK   : std_logic := '0';
    signal RST   : std_logic := '0';
    signal DIN   : std_logic_vector(7 downto 0) := x"00";
    signal PUSH  : std_logic := '0';
    signal POP   : std_logic := '0';
    signal CLEAR : std_logic := '0';

    signal DOUT      : std_logic_vector(7 downto 0);
    signal ISFULL    : std_logic;
    signal ISEMPTY   : std_logic;
    signal PUSHERROR : std_logic;
    signal POPERROR  : std_logic;

begin

    UUT: FIFO_QUEUE port map(
        CLK => CLK, RST => RST, DIN => DIN, 
        PUSH => PUSH, POP => POP, CLEAR => CLEAR,
        DOUT => DOUT, ISFULL => ISFULL, ISEMPTY => ISEMPTY,
        PUSHERROR => PUSHERROR, POPERROR => POPERROR
    );

    -- Clock 40 MHz (25ns)
    CLK <= not CLK after 12.5 ns;

    process
    begin
        -- ============================================================
        -- RESET
        -- ============================================================
        RST <= '1';
        wait for 100 ns;
        RST <= '0';
        wait for 50 ns;

        -- ============================================================
        -- TEST 1: 4 PUSH
        -- ============================================================
        
        -- PUSH 1
        DIN <= x"01";
        PUSH <= '1';
        wait for 25 ns;
        PUSH <= '0';
        wait for 50 ns;
        
        -- PUSH 2
        DIN <= x"02";
        PUSH <= '1';
        wait for 25 ns;
        PUSH <= '0';
        wait for 50 ns;
        
        -- PUSH 3
        DIN <= x"04";
        PUSH <= '1';
        wait for 25 ns;
        PUSH <= '0';
        wait for 50 ns;
        
        -- PUSH 4
        DIN <= x"08";
        PUSH <= '1';
        wait for 25 ns;
        PUSH <= '0';
        wait for 50 ns;

        -- ============================================================
        -- TEST 2: 4 POP
        -- ============================================================
        
        -- POP 1
        POP <= '1';
        wait for 25 ns;
        POP <= '0';
        wait for 75 ns;  -- Aspetta pipeline
        
        -- POP 2
        POP <= '1';
        wait for 25 ns;
        POP <= '0';
        wait for 75 ns;
        
        -- POP 3
        POP <= '1';
        wait for 25 ns;
        POP <= '0';
        wait for 75 ns;
        
        -- POP 4
        POP <= '1';
        wait for 25 ns;
        POP <= '0';
        wait for 75 ns;

        -- ============================================================
        -- TEST 3: POPERROR (POP su coda vuota)
        -- ============================================================
        
        POP <= '1';
        wait for 25 ns;
        POP <= '0';
        wait for 100 ns;

        -- ============================================================
        -- TEST 4: Riempi FIFO (8 PUSH)
        -- ============================================================
        
        -- PUSH 1/8
        DIN <= x"10";
        PUSH <= '1';
        wait for 25 ns;
        PUSH <= '0';
        wait for 50 ns;
        
        -- PUSH 2/8
        DIN <= x"11";
        PUSH <= '1';
        wait for 25 ns;
        PUSH <= '0';
        wait for 50 ns;
        
        -- PUSH 3/8
        DIN <= x"12";
        PUSH <= '1';
        wait for 25 ns;
        PUSH <= '0';
        wait for 50 ns;
        
        -- PUSH 4/8
        DIN <= x"13";
        PUSH <= '1';
        wait for 25 ns;
        PUSH <= '0';
        wait for 50 ns;
        
        -- PUSH 5/8
        DIN <= x"14";
        PUSH <= '1';
        wait for 25 ns;
        PUSH <= '0';
        wait for 50 ns;
        
        -- PUSH 6/8
        DIN <= x"15";
        PUSH <= '1';
        wait for 25 ns;
        PUSH <= '0';
        wait for 50 ns;
        
        -- PUSH 7/8
        DIN <= x"16";
        PUSH <= '1';
        wait for 25 ns;
        PUSH <= '0';
        wait for 50 ns;
        
        -- PUSH 8/8
        DIN <= x"17";
        PUSH <= '1';
        wait for 25 ns;
        PUSH <= '0';
        wait for 100 ns;  -- Attesa per vedere ISFULL

        -- ============================================================
        -- TEST 5: PUSHERROR (9° PUSH su coda piena)
        -- ============================================================
        
        DIN <= x"FF";
        PUSH <= '1';
        wait for 25 ns;
        PUSH <= '0';
        wait for 100 ns;

        -- ============================================================
        -- TEST 6: CLEAR
        -- ============================================================
        
        CLEAR <= '1';
        wait for 25 ns;
        CLEAR <= '0';
        wait for 100 ns;

        -- FINE
        wait;
    end process;

end BEHAVIORAL;