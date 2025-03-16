library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--somador de 8 bits
entity Somador is
    Port (
        A     : in  std_logic_vector(7 downto 0);
        B     : in  std_logic_vector(7 downto 0);
        Sum   : out std_logic_vector(7 downto 0);
        Carry : out std_logic
    );
end Somador;

architecture Behavioral of Somador is
    signal A_unsigned, B_unsigned : unsigned(7 downto 0);
    signal result : unsigned(8 downto 0);
begin
    -- Converte as entradas para o tipo unsigned para operações aritméticas.
    A_unsigned <= unsigned(A);
    B_unsigned <= unsigned(B);
    
    -- Soma as entradas; concatenamos '0' para gerar um vetor de 9 bits que captura o carry.
    result <= ('0' & A_unsigned) + ('0' & B_unsigned);
    
    -- Atribui a parte menos significativa como resultado e o bit mais significativo como Carry.
    Sum   <= std_logic_vector(result(7 downto 0));
    Carry <= result(8);
end Behavioral;
