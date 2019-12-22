library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity triple_for_tb is
--  Port ( );
end triple_for_tb;

architecture Behavioral of triple_for_tb is

component triple_for_slower is
    Generic ( width : integer);

    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : out STD_LOGIC);

end component;
component triple_for_faster is
    Generic ( width : integer);

    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : out STD_LOGIC);

end component;

constant width : integer := 2;

signal reset : std_logic := '0';
signal clock : std_logic := '1';
signal start : std_logic := '0';
signal ready_slower, ready_faster : std_logic; --out

begin

dut0 : triple_for_slower generic map(width) port map(reset, clock, start, ready_slower);
dut1 : triple_for_faster generic map(width) port map(reset, clock, start, ready_faster);

clocking : process begin
    wait for 5ns;
    clock <= not clock;
end process;

resetting : process begin
    wait for 5ns;
    reset <= '1';    
    wait for 100ns;
    reset <= '0';    
    wait;
end process;

stimulus : process begin
    wait for 115ns;
    start <= '1';    
    wait for 10ns;
    start <= '0';    
    wait;
end process;

end Behavioral;
