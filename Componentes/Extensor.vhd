library IEEE;
use IEEE.std_logic_1164.all;

entity Extensor_4x8 is
    Port(
        in4  : in  std_logic_vector(3 downto 0);  -- Valor imediato de 4 bits
        out8 : out std_logic_vector(7 downto 0)     -- Valor estendido para 8 bits
    );
end Extensor_4x8;

architecture Behavioral of Extensor_4x8 is
begin
    -- Extensão com sinal: replica o bit mais significativo (in4(3))
    -- nos 4 bits superiores, seguido pelos 4 bits de entrada.
    out8 <= in4(3) & in4(3) & in4(3) & in4(3) & in4;
end Behavioral;
