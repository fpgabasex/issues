library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity state_machine is
    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           control : in STD_LOGIC_VECTOR (7 downto 0);
           state_out : out STD_LOGIC_VECTOR (2 downto 0));
end state_machine;

architecture Behavioral of state_machine is
    
    signal counter : std_logic_vector(7 downto 0);
    type state_switchersT is array (0 to 7) of std_logic_vector(7 downto 0);
    constant state_switchers : state_switchersT := (x"03", x"08", x"a1", x"73", x"b7", x"ec", x"af", x"32");
    type stateT is (one, two, three, four, five, six, seven, eight);
    signal state : stateT;
    
begin

    process(clock) begin
        if rising_edge(clock) then
            if reset = '1' then
                state <= one;
                counter <= (others => '0');
            else
                counter <= counter + '1';
                case state is
                     when one =>
                        if counter = state_switchers(0) then
                            if control(0) = '1' then
                                state <= two;
                            end if;
                        end if;
                     when two =>
                        if counter = state_switchers(1) then
                            if control(1) = '1' then
                                state <= three;
                            end if;
                        end if;
                     when three =>
                        if counter = state_switchers(2) then
                            if control(2) = '1' then
                                state <= four;
                            end if;
                        end if;
                     --this is an interesting state, it has 6 conditions, just like inputs of a LUT
                     --and although the conditions are very complex, they wouuld all fit into a single
                     --look-up-table if implemented as registered versions of the constantly monotonously
                     --increasing oounter's appropriately adjusted value!
                     when four =>
                        if counter = state_switchers(3) then
                            if control(3) = '1' then
                                state <= five;
                            elsif control(4) = '1' then
                                state <= six;
                            end if;
                        elsif counter = state_switchers(4) then
                            if control(5) = '1' then
                                state <= seven;
                            end if;
                        elsif counter = state_switchers(5) then
                            state <= eight;    
                        end if;
                     when five =>
                        state <= eight;
                     when six =>
                        state <= seven;
                     when seven =>
                        if counter = state_switchers(6) then
                            if control(6) = '1' then
                                state <= one;
                            end if;
                        end if;
                     when others =>
                        if counter = state_switchers(7) then
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
