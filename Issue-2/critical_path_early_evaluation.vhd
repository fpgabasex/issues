library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity critical_path_early_evaluation is

    --(1)check out the design's schematic, timing and critical path on the schematic while adjusting bus "width"
    Generic( width : integer := 3);

    Port ( clock : in STD_LOGIC;
           x : in STD_LOGIC_VECTOR (width-1 downto 0);
           y : in STD_LOGIC_VECTOR (width-1 downto 0);
           a : in STD_LOGIC_VECTOR (width-1 downto 0);
           b : in STD_LOGIC_VECTOR (width-1 downto 0);
           c : in STD_LOGIC_VECTOR (width-1 downto 0);
           d : in STD_LOGIC_VECTOR (width-1 downto 0);
           selected_sum : out STD_LOGIC_VECTOR (width-1 downto 0));
end critical_path_early_evaluation;

architecture Behavioral of critical_path_early_evaluation is
    
    signal a_reg, b_reg, c_reg, d_reg : std_logic_vector(width-1 downto 0);
    signal enable : std_logic;
    
begin

    process(clock) begin
        if rising_edge(clock) then
            
            a_reg <= a;
            b_reg <= b;
            c_reg <= c;
            d_reg <= d;
            
            --added condtition evaluation a cycle earlier
            if x = y then
                enable <= '1';
            else
                enable <= '0';
            end if;
            
            if enable = '1' then
                selected_sum <= a_reg + b_reg;
            
            --(2)uncomment the following lines for multiplexing  instead of using D-flip-flop chip enable
            --else
            --    selected_sum <= c_reg + d_reg;
            
            end if;
        end if;
    end process;

end Behavioral;
