library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ContadorPrograma is
    Port (
        clk    : in  std_logic;                         -- Clock
        reset  : in  std_logic;                         -- Reset síncrono (ativo em '1')
        jump   : in  std_logic;                         -- Sinal de salto; quando '1', carrega nextPC
        nextPC : in  std_logic_vector(7 downto 0);        -- Valor de PC a ser carregado se jump = '1'
        PC     : out std_logic_vector(7 downto 0)         -- Valor atual do PC
    );
end ContadorPrograma;

architecture Behavioral of ContadorPrograma is
    signal pc_reg : unsigned(7 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');   -- Reinicia o PC para 0
        elsif rising_edge(clk) then
            if jump = '1' then
                pc_reg <= unsigned(nextPC);  -- Carrega o novo endereço (jump ou branch)
            else
                pc_reg <= pc_reg + 1;         -- Incrementa o PC em 1
            end if;
        end if;
    end process;
    
    -- Converte o valor interno para std_logic_vector para a saída
    PC <= std_logic_vector(pc_reg);
end Behavioral;
