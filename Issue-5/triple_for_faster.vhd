library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity triple_for_faster is
    Generic ( width : integer := 12);

    Port ( reset : in STD_LOGIC;
           clock : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : out STD_LOGIC);

end triple_for_faster;

architecture Behavioral of triple_for_faster is

    type stateT is (rst, modExp, montMult, add, rdy);
    signal state : stateT;
    signal modCnt, mltCnt, addCnt : std_logic_vector(width downto 0);

begin

    process(clock) begin
        if rising_edge(clock) then
            if reset = '1' then
                ready <= '1';
                state <= rst;
                modCnt <= (others => '0');
                mltCnt <= (others => '0');
                addCnt <= (others => '0');
            else
                case state is
                    when rst =>
                        ready <= '0';
                        if start = '1' then
                            state <= modExp;
                        end if;
                    
                    when modExp =>
                        modCnt <= modCnt + '1';
                        --do not reset counters in several states
                        if modCnt(modCnt'high) = '1' then
                            state <= rdy;
                            modCnt <= (others => '0');
                        else
                            state <= montMult;
                        end if;
                    
                    when montMult =>
                        mltCnt <= mltCnt + '1';
                        --do not reset counters in several states
                        if mltCnt(mltCnt'high) = '1' then
                            state <= modExp;
                            mltCnt <= (others => '0');
                        else
                            state <= add;
                        end if;

                    when add =>
                        addCnt <= addCnt + '1';
                        if addCnt(addCnt'high) = '1' then
                            state <= montMult;
                            addCnt <= (others => '0');
                        end if;

                    when others =>
                        --do not reset counters in several states
                        ready <= '1';
                end case;
            end if;
        end if;
    end process;
    
end Behavioral;
