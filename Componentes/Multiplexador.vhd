library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Multiplexador is
    Port (
	 
	 --Mutiplexador de 2x1 de 8 bits
        sel : in  std_logic;                          -- Sinal de seleção (0 ou 1)
        d0  : in  std_logic_vector(7 downto 0);         -- Entrada 0 (8 bits)
        d1  : in  std_logic_vector(7 downto 0);         -- Entrada 1 (8 bits)
        y   : out std_logic_vector(7 downto 0)          -- Saída (8 bits)
    );
end Multiplexador;

architecture Behavioral of Multiplexador is
begin
    process(sel, d0, d1)
    begin
        if sel = '0' then
            y <= d0;
        else
            y <= d1;
        end if;
    end process;
end Behavioral;
