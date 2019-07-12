library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library UNISIM;
use UNISIM.VComponents.all;

entity cascaded_SRLs_2 is
    -- have to be between 0 and 31 in order work
    Generic(tap_1 : integer := 5;
            tap_2 : integer := 37-32;
            tap_3 : integer := 94-64);

    Port ( clock : in STD_LOGIC;
           d_in : in STD_LOGIC;
           q_1 : out STD_LOGIC;
           q_2 : out STD_LOGIC;
           q_3 : out STD_LOGIC;
           q : out STD_LOGIC);
end cascaded_SRLs_2;

architecture Behavioral of cascaded_SRLs_2 is
    signal inner_q0, inner_q1 : std_logic;
begin
   
   SRLC32E_inst_0 : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => q_1,                     -- SRL data output
      Q31 =>  inner_q0,             -- SRL cascade output pin
      A => std_logic_vector(to_unsigned(tap_1,5)), -- 5-bit shift depth select input
      CE => '1',                    -- Clock enable input
      CLK => clock,                   -- Clock input
      D => d_in                     -- SRL data input
   );
   
   SRLC32E_inst_1 : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => q_2,                     -- SRL data output
      Q31 => inner_q1,              -- SRL cascade output pin
      A => std_logic_vector(to_unsigned(tap_2,5)), -- 5-bit shift depth select input
      CE => '1',                    -- Clock enable input
      CLK => clock,                   -- Clock input
      D => inner_q0                 -- SRL data input
   );
   
   SRLC32E_inst_2 : SRLC32E
   generic map (
      INIT => X"00000000")
   port map (
      Q => q_3,                     -- SRL data output
      Q31 => q,                     -- SRL cascade output pin
      A => std_logic_vector(to_unsigned(tap_3,5)), -- 5-bit shift depth select input
      CE => '1',                    -- Clock enable input
      CLK => clock,                 -- Clock input
      D => inner_q1                 -- SRL data input
   );

end Behavioral;
