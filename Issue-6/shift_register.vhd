LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity shift_register is
    Port ( --clock : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (3 downto 0) := x"3";
           dataOut : out STD_LOGIC_VECTOR (3 downto 0));
end shift_register;

architecture Behavioral of shift_register is

    type shifterT is array(7 downto 0) of std_logic_vector(3 downto 0);
    signal shifter : shifterT := (x"0",x"0",x"0",x"0",x"0",x"0",x"0",x"0");
    signal sum : std_logic_vector(3 downto 0);
    
    signal clock : std_logic := '0';
    
begin

    process begin
        wait for 5 ns;
        clock <= not clock;
    end process;

    process(clock)
    begin
        if rising_edge(clock) then
            shifter <= shifter(shifter'high-1 downto 0) & sum;
        end if;
    end process;
    
    sum <= shifter(shifter'high) + shifter(shifter'low) + dataIn;
    
    dataOut <= shifter(shifter'high);

end Behavioral;
