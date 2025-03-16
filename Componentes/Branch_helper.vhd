LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity Branch_helper is
    Port(
         A : in std_logic;
         S : out std_logic
    );
end Branch_helper;

architecture Behavioral of Branch_helper is
begin
    -- Simples passagem: a saída recebe o valor da entrada
    S <= A;
end Behavioral;
