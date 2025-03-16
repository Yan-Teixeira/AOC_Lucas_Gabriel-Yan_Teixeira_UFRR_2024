library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Decodificador is
    Port (
        instr    : in  std_logic_vector(7 downto 0);  -- Instrução de 8 bits
        RegWrite : out std_logic;                     -- Sinal de escrita no registrador
        ALUSrc   : out std_logic;                     -- Seleciona fonte da segunda entrada da ALU
        MemRead  : out std_logic;                     -- Habilita leitura da memória (para LW)
        MemWrite : out std_logic;                     -- Habilita escrita na memória (para SW)
        Branch   : out std_logic;                     -- Sinal de branch (para BEQ)
        Jump     : out std_logic;                     -- Sinal de salto incondicional (para JUMP)
        ALUOp    : out std_logic_vector(1 downto 0)     -- Código de operação para a ALU
    );
end Decodificador;

architecture Behavioral of Decodificador is
    signal opcode : std_logic_vector(3 downto 0);
begin
    -- Extrai o opcode dos 4 bits mais significativos da instrução.
    opcode <= instr(7 downto 4);

    process(opcode)
    begin
        -- Valores padrão para todos os sinais de controle
        RegWrite <= '0';
        ALUSrc   <= '0';
        MemRead  <= '0';
        MemWrite <= '0';
        Branch   <= '0';
        Jump     <= '0';
        ALUOp    <= "00";
        
        case opcode is
            when "0000" =>  -- ADD
                RegWrite <= '1';
                ALUSrc   <= '0';
                ALUOp    <= "00";
            when "0001" =>  -- SUB
                RegWrite <= '1';
                ALUSrc   <= '0';
                ALUOp    <= "01";
            when "0010" =>  -- AND
                RegWrite <= '1';
                ALUSrc   <= '0';
                ALUOp    <= "10";
            when "0011" =>  -- OR
                RegWrite <= '1';
                ALUSrc   <= '0';
                ALUOp    <= "11";
            when "0100" =>  -- LW
                RegWrite <= '1';
                ALUSrc   <= '1';   -- Usa o imediato para cálculo de endereço
                MemRead  <= '1';
                ALUOp    <= "00";  -- Supondo que a ALU faça ADD para calcular endereço
            when "0101" =>  -- SW
                MemWrite <= '1';
                ALUSrc   <= '1';
                ALUOp    <= "00";  -- ADD para cálculo de endereço
            when "0110" =>  -- BEQ
                Branch   <= '1';
                ALUSrc   <= '0';
                ALUOp    <= "01";  -- SUB para comparação (se o resultado for zero, branch)
            when "0111" =>  -- JUMP
                Jump     <= '1';
            when others =>
                -- Instrução desconhecida: mantém sinais inativos
                null;
        end case;
    end process;
end Behavioral;
