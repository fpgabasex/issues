--Speed Results:
--(1) WNS = 1,324ns @ 100MHz clock (TNS fails)
--(2) WNS = 1,324ns @ 100MHz clock (TNS fails)
--(3) WNS = 1,238ns @ 100MHz clock
--(4) WNS = 3,095ns @ 100MHz clock
--(5) WNS = 3,095ns @ 100MHz clock

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity second_order is
    Port ( clock : in std_logic; --uncomment for synthesis
           a_in : in std_logic_vector (15 downto 0);-- := x"1003"; --do comment initial values for synthesis
           b_in : in std_logic_vector (15 downto 0);-- := x"10f3";
           c_in : in std_logic_vector (15 downto 0);-- := x"1005";
           x_in : in std_logic_vector (15 downto 0);-- := x"1014";
           y_out : out std_logic_vector (47 downto 0)); --should evaluate to x"00102c3117b1"
end second_order;

architecture Behavioral of second_order is
    --signal clock : std_logic; --only for simulation
    signal a,b,c,x : std_logic_vector(15 downto 0);
    signal y : std_logic_vector(47 downto 0);
    signal multA : std_logic_vector(47 downto 0);
    signal multB : std_logic_vector(31 downto 0);
    signal multC : std_logic_vector(15 downto 0);
    signal square : std_logic_vector(31 downto 0);
    signal a_reg,b_reg,c_reg,x_reg : std_logic_vector(15 downto 0);
    signal sum : std_logic_vector(31 downto 0);
begin

--simulation construct, can not be synthesized, comment it for synthesis
--    process begin
--        clock <= '0';
--        wait for 5 ns;
--        clock <= '1';
--        wait for 5 ns;
--    end process;

--  registering inputs and output is needed for synthesis to show valid timing results even in case (1)
  process(clock)
  begin
      if rising_edge(clock) then
            a <= a_in;
            b <= b_in;
            c <= c_in;
            x <= x_in;
            y_out <= y;
      end if;
  end process;

--  y <= a*x*x+b*x+c; --(1) asynchronous calculation: no delay

    process(clock)
    begin
        if rising_edge(clock) then

--          y <= a*x*x+b*x+c; --(2) synchronous calculation: 1 cycle delay

--          multA <= a*x*x; --(3) adding pipline layer for multiplication: 2 cycles delay
--          multB <= b*x;
--          multC <= c;
--          y <= multA + multB + multC;
            
--          square <= x*x; --(4) introducing one more pipeline layer: 3 cycles delay
--          a_reg <= a;
--          b_reg <= b;
--          c_reg <= c;
--          x_reg <= x;
--          multA <= a_reg*square;
--          multB <= b_reg*x_reg;
--          multC <= c_reg;
--          y <= multA + multB + multC;

--          square <= x*x; --(5) using data with various latencies: less registers and still 3 cycles delay
--          a_reg <= a;
--          multA <= a_reg*square;
--          multB <= b*x;
--          multC <= c;
--          sum <= multB + multC;
--          y <= multA + sum;

--          (6) homework:
--          y = x*(a*x+b)+c
--          calculate by using only 2 multipliers!

       end if;
    end process;

end Behavioral;
