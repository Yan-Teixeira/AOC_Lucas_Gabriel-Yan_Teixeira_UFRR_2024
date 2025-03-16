library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ULA is
    Port(
        A      : in  std_logic_vector(7 downto 0);
        B      : in  std_logic_vector(7 downto 0);
        AluOp  : in  std_logic_vector(1 downto 0);  -- 2 bits de controle
        result : out std_logic_vector(7 downto 0);
        zero   : out std_logic
    );
end ULA;

architecture Behavioral of ULA is
    signal res : unsigned(7 downto 0);
begin
    process(A, B, AluOp)
    begin
        case AlUOp is
            when "00" =>  -- ADD
                res <= unsigned(A) + unsigned(B);
            when "01" =>  -- SUB
                res <= unsigned(A) - unsigned(B);
            when "10" =>  -- AND
                res <= unsigned(A and B);
            when "11" =>  -- OR
                res <= unsigned(A or B);
            when others =>
                res <= (others => '0');
        end case;
    end process;

    result <= std_logic_vector(res);
    zero   <= '1' when res = 0 else '0';
end Behavioral;

