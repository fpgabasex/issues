--@100MHz on an Artix device, WNS is 4.201ns, data path delay 5.209ns, fan out is 1024, levels of logic 23

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_with_assign_1 is
    Generic( comp_width : integer := 256; --(1) influences comparator's complexity
             data_width : integer := 1024); --(2) influences fan out of comparator
    Port ( clock : in STD_LOGIC;
           compA : in STD_LOGIC_VECTOR (comp_width-1 downto 0);
           compB : in STD_LOGIC_VECTOR (comp_width-1 downto 0);
           data_in : in STD_LOGIC_VECTOR(data_width-1 downto 0);
           data_out : out STD_LOGIC_VECTOR(data_width-1 downto 0));
end comparator_with_assign_1;

architecture Behavioral of comparator_with_assign_1 is

    signal compA_reg, compB_reg : STD_LOGIC_VECTOR (comp_width-1 downto 0);
    signal data_in_reg, data_out_reg : STD_LOGIC_VECTOR(data_width-1 downto 0);

begin

--registering inputs and outputs to ease timig measurement
process(clock) begin
    if rising_edge(clock) then
        compA_reg <= compA;
        compB_reg <= compB;
        data_in_reg <= data_in;
        data_out <= data_out_reg;
    end if;
end process;

--example: showcase how speed dpeend on (1) input signal width and (2) fan out
process(clock) begin
    if rising_edge(clock) then
        if compA_reg = compB_reg then --(1)
            data_out_reg <= data_in_reg; --(2)
        end if;
    end if;
end process;

end Behavioral;
