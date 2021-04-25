library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity state_machine_v3 is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           control : in STD_LOGIC_VECTOR (7 downto 0);
           state_out : out STD_LOGIC_VECTOR (2 downto 0));
end state_machine_v3;

architecture Behavioral of state_machine_v3 is
    
    signal counter : std_logic_vector(7 downto 0);
    type state_switchersT is array (0 to 7) of std_logic_vector(7 downto 0);
    constant state_switchers : state_switchersT := (x"03", x"08", x"a1", x"73", x"b7", x"ec", x"af", x"32");
    type stateT is (one, two, three, four, five, six, seven, eight);
    signal state : stateT;
    signal condition : std_logic_vector(2 downto 0);
    signal more_conditions : std_logic_vector(4 downto 0);
    
begin

    process(clock) begin
        if rising_edge(clock) then
            if reset = '1' then
                state <= one;
                counter <= (others => '0');
            else
                counter <= counter + '1';
                
                --state four's conditions:
                if counter + '1' = state_switchers(3) then
                    condition(0) <= '1';
                else
                    condition(0) <= '0';
                end if;          
                if counter + '1' = state_switchers(4) then
                    condition(1) <= '1';
                else
                    condition(1) <= '0';
                end if;          
                if counter + '1' = state_switchers(5) then
                    condition(2) <= '1';
                else
                    condition(2) <= '0';
                end if;          
                
                --rest of the forecastable  conditions
                if counter + '1' = state_switchers(0) then
                    more_conditions(0) <= '1';
                else
                    more_conditions(0) <= '0';
                end if;          
                if counter + '1' = state_switchers(1) then
                    more_conditions(1) <= '1';
                else
                    more_conditions(1) <= '0';
                end if;          
                if counter + '1' = state_switchers(2) then
                    more_conditions(2) <= '1';
                else
                    more_conditions(2) <= '0';
                end if;          
                if counter + '1' = state_switchers(6)then
                    more_conditions(3) <= '1';
                else
                    more_conditions(3) <= '0';
                end if;          
                if counter + '1' = state_switchers(7) then
                    more_conditions(4) <= '1';
                else
                    more_conditions(4) <= '0';
                end if;          

                case state is
                     when one =>
                        --if counter = state_switchers(0) then
                        if more_conditions(0) = '1' then
                            if control(0) = '1' then
                                state <= two;
                            end if;
                        end if;
                     when two =>
                        --if counter = state_switchers(1) then
                        if more_conditions(1) = '1' then
                            if control(1) = '1' then
                                state <= three;
                            end if;
                        end if;
                     when three =>
                        --if counter = state_switchers(2) then
                        if more_conditions(2) = '1' then
                            if control(2) = '1' then
                                state <= four;
                            end if;
                        end if;
                        --this is an interesting state, it has 6 conditions, just like inputs of a LUT
                        --and although the conditions are very complex, they wouuld all fit into a single
                        --look-up-table if implemented as registered versions of the constantly monotonously
                        --increasing oounter's appropriately adjusted value!                     when four =>
                        --if counter = state_switchers(3) then
                        if condition(0) = '1' then
                            if control(3) = '1' then
                                state <= five;
                            elsif control(4) = '1' then
                                state <= six;
                            end if;
                        --elsif counter = state_switchers(4) then
                        elsif condition(1) = '1' then

                            if control(5) = '1' then
                                state <= seven;
                            end if;
                        --elsif counter = state_switchers(5) then
                        elsif condition(2) = '1' then
                            state <= eight;    
                        end if;
                     when five =>
                        state <= eight;
                     when six =>
                        state <= seven;
                     when seven =>
                        --if counter = state_switchers(6) then
                        if more_conditions(3) = '1' then
                            if control(6) = '1' then
                                state <= one;
                            end if;
                        end if;
                     when others =>
                        --if counter = state_switchers(7) then
                        if more_conditions(4) = '1' then
                            if control(7) = '1' then
                                state <= one;
                            end if;
                        end if;
                end case;
            end if;
        end if;
    end process;

    state_out <= "000" when state = one else
                 "001" when state = two else
                 "010" when state = three else
                 "011" when state = four else
                 "100" when state = five else
                 "101" when state = six else
                 "110" when state = seven else
                 "111";
                 
end Behavioral;

