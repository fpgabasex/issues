LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity circular_buffer is
    Port ( --clock : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (3 downto 0) := x"3";
           dataOut : out STD_LOGIC_VECTOR (3 downto 0));
end circular_buffer;

architecture Behavioral of circular_buffer is

    type ramT is array(0 to 7) of std_logic_vector(3 downto 0);
    signal ram : ramT  := (x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0");
    signal state0 : std_logic_vector(2 downto 0) := "000";
    signal state1 : std_logic_vector(2 downto 0) := "001";
    signal reg0, reg1, sum : std_logic_vector(3 downto 0) := x"0";

    signal clock : std_logic := '0';
    
begin

    process begin
        wait for 5 ns;
        clock <= not clock;
    end process;

    process(clock)
    begin
        if rising_edge(clock) then
            state0 <= state0 + '1';
            state1 <= state1 + '1';
            ram(conv_integer(state0)) <= sum;
            reg0 <= sum;
            reg1 <= ram(conv_integer(state1));
        end if;
    end process;

    sum <= reg0 + reg1 + dataIn;

    dataOut <= reg1;

end Behavioral;
