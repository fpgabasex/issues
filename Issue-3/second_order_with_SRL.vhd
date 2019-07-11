library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity second_order_with_SRL is

    -- (1) because of carry, a 16 bit wide signal already results in 3 multipliers and speed changes
    -- due to granurality, however under 16 bits all registers get mapped into the DSP slices' inner ones
    -- and no SRL extraction takes place 
    Generic(width : integer := 16);
    
    Port ( clock : in std_logic;
           a_in : in std_logic_vector (width-1 downto 0);
           b_in : in std_logic_vector (width-1 downto 0);
           c_in : in std_logic_vector (width-1 downto 0);
           x_in : in std_logic_vector (width-1 downto 0);
           y_out : out std_logic_vector (3*width-1 downto 0));

end second_order_with_SRL;

architecture Behavioral of second_order_with_SRL is

    signal a,b,x : std_logic_vector(width-1 downto 0);
    type c_srl_T is array (3 downto 0) of std_logic_vector(width-1 downto 0);
    signal c_srl : c_srl_T;
    signal y : std_logic_vector(3*width-1 downto 0);
    signal multAX : std_logic_vector(2*width-1 downto 0);
    signal b1 : std_logic_vector(width-1 downto 0);
    signal sumB : std_logic_vector(2*width-1 downto 0);
    signal multBX : std_logic_vector(3*width-1 downto 0);

begin

  process(clock)
  begin
      if rising_edge(clock) then
            a <= a_in;
            b <= b_in;
            c_srl <= c_srl(2 downto 0) & c_in;
            x <= x_in;
            y_out <= y;
      end if;
  end process;

    process(clock)
    begin
        if rising_edge(clock) then

            -- (2) y = x*(a*x+b)+c requires a latency of 3 clock cycles in the signal path of "c"
            -- which  may be extracted into SRL implemented in LUT
            -- the difference between extracte SRL and DFF based consistency pipe can be seen with
            -- adjusting bus width to 16 and setting your syntheser's minimum shift register size to
            -- be extracted higher than 4
            multAX <= a * x;
            b1 <= b;
            sumB <= multAX + b1;
            multBX <= sumB * x;
            y <= multBX + c_srl(3);

       end if;
    end process;

end Behavioral;
