library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Registradores is
    Port (
        clk       : in  std_logic;                         -- Clock
        regWrite  : in  std_logic;                         -- Habilita escrita
        readAddr1 : in  std_logic_vector(2 downto 0);        -- Endereço para leitura 1 (3 bits, 8 registros)
        readAddr2 : in  std_logic_vector(2 downto 0);        -- Endereço para leitura 2
        writeAddr : in  std_logic_vector(2 downto 0);        -- Endereço para escrita
        writeData : in  std_logic_vector(7 downto 0);        -- Dados a serem escritos (8 bits)
        readData1 : out std_logic_vector(7 downto 0);        -- Saída da leitura 1
        readData2 : out std_logic_vector(7 downto 0)         -- Saída da leitura 2
    );
end Registradores;

architecture Behavioral of Registradores is
    -- Define um array de 8 registradores, cada um com 8 bits.
    type reg_array is array (0 to 7) of std_logic_vector(7 downto 0);
    signal regs : reg_array := (others => (others => '0'));
begin
    -- Processo de escrita: na borda de subida do clock, se regWrite estiver ativo,
    -- o valor writeData é escrito no registrador especificado por writeAddr.
    process(clk)
    begin
        if rising_edge(clk) then
            if regWrite = '1' then
                regs(to_integer(unsigned(writeAddr))) <= writeData;
            end if;
        end if;
    end process;
    
    -- Leituras combinacionais: os dados dos registradores especificados por readAddr1 e readAddr2
    -- são enviados imediatamente para as saídas readData1 e readData2.
    readData1 <= regs(to_integer(unsigned(readAddr1)));
    readData2 <= regs(to_integer(unsigned(readAddr2)));
    
end Behavioral;
