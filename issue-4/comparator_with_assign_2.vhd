--@100MHz on an Artix device, WNS is 5.133ns, data path delay 4.733ns, fan out is still 1024, levels of logic still 23

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_with_assign_2 is
    Generic( comp_width : integer := 256; -- influences comparator's complexity
             data_width : integer := 1024); -- influences fan out of enable register
    Port ( clock : in STD_LOGIC;
           compA : in STD_LOGIC_VECTOR (comp_width-1 downto 0);
           compB : in STD_LOGIC_VECTOR (comp_width-1 downto 0);
           data_in : in STD_LOGIC_VECTOR(data_width-1 downto 0);
           data_out : out STD_LOGIC_VECTOR(data_width-1 downto 0));
end comparator_with_assign_2;

architecture Behavioral of comparator_with_assign_2 is

    signal compA_reg, compB_reg : STD_LOGIC_VECTOR (comp_width-1 downto 0);
    signal equal : STD_LOGIC;
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

--example: (3) only if the problem to be solved enables the early evaluation of
--the comparison, the possibly high fan out may be driven with an additional register
process(clock) begin
    if rising_edge(clock) then
        if compA_reg = compB_reg then
            equal <= '1'; --(3)
        else
            equal <= '0'; --(3)
        end if;
        if equal = '1' then --(3)
            data_out_reg <= data_in_reg;
        end if;        
    end if;
end process;

end Behavioral;
