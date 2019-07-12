library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cascaded_SRLs_1 is
    Generic(length : integer := 96; -- assuming LUT size of 2^5
            tap_1 : integer := 5;   -- has to be between 0 and 31 in order to extract SRL
            tap_2 : integer := 37;  -- has to be between 32 and 63 in order to extract SRL
            tap_3 : integer := 94); -- has to be between 64 and 95 in order to extract SRL
    -- apparently my synthesis tool is not capable of recognizing, that the taps fit into
    -- 3 consecutive SRLs, but instead synthesizes every shifter between taps distinctly,
    -- resuluting in more than 3 LUTs bein used

    Port ( clock : in STD_LOGIC;
           d_in : in STD_LOGIC;
           q_1 : out STD_LOGIC;
           q_2 : out STD_LOGIC;
           q_3 : out STD_LOGIC;
           q : out STD_LOGIC);
end cascaded_SRLs_1;

architecture Behavioral of cascaded_SRLs_1 is
    signal shift_register :std_logic_vector(length-1 downto 0);
begin

    process(clock) begin
        if rising_edge(clock) then
            shift_register <= shift_register(length-2 downto 0) & d_in;
        end if;
    end process;
    q_1 <= shift_register(tap_1-1);
    q_2 <= shift_register(tap_2-1);
    q_3 <= shift_register(tap_3-1);
    q   <= shift_register(length-1);

end Behavioral;
