--without retiming: data path delay 4.733ns, levels of logic 23, highest fan out 1024
--with retiming: data path delay 4.603ns, levels of logic 22 - not much gain, tree comparator is not
-- part of the system, but high fan outs not being present among the slowest routes

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_with_assign_3 is
    Generic( comp_width : integer := 256; -- influences comparator's complexity
             data_width : integer := 1024); -- influences fan out of enable register
    Port ( clock : in STD_LOGIC;
           compA : in STD_LOGIC_VECTOR (comp_width-1 downto 0);
           compB : in STD_LOGIC_VECTOR (comp_width-1 downto 0);
           data_in : in STD_LOGIC_VECTOR(data_width-1 downto 0);
           data_out : out STD_LOGIC_VECTOR(data_width-1 downto 0));
end comparator_with_assign_3;

architecture Behavioral of comparator_with_assign_3 is

    signal compA_reg, compB_reg : STD_LOGIC_VECTOR (comp_width-1 downto 0);
    signal equal0, equal1, equal2, equal3 : STD_LOGIC;
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

--example: (4) let's try adding a pipieline in place of th eenable signal and configure retiming (switch off SRL extraction!)
process(clock) begin
    if rising_edge(clock) then
        if compA_reg = compB_reg then
            equal0 <= '1';
        else
            equal0 <= '0';
        end if;
        equal1 <= equal0; --(4)
        equal2 <= equal1; --(4)
        equal3 <= equal2; --(4)
        if equal3 = '1' then
            data_out_reg <= data_in_reg;
        end if;        
    end if;
end process;

end Behavioral;

