library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Unidade_de_controle is
    Port (
        opcode   : in  std_logic_vector(3 downto 0);  -- Opcode extraído dos 4 bits mais significativos da instrução
        RegWrite : out std_logic;                     -- Habilita escrita no banco de registradores
        ALUSrc   : out std_logic;                     -- Seleciona se a segunda entrada da ALU vem do imediato (1) ou do registrador (0)
        MemRead  : out std_logic;                     -- Habilita leitura da memória (para LW)
        MemWrite : out std_logic;                     -- Habilita escrita na memória (para SW)
        Branch   : out std_logic;                     -- Indica branch (para BEQ)
        Jump     : out std_logic;                     -- Indica salto incondicional (JUMP)
        MemToReg : out std_logic;                     -- Seleciona entre o resultado da ALU e o dado lido da memória para escrita no registrador
        ALUOp    : out std_logic_vector(1 downto 0)     -- Código de operação para a ALU
    );
end Unidade_de_controle;

architecture Behavioral of Unidade_de_controle is
begin
    process(opcode)
    begin
        -- Inicializações padrão
        RegWrite <= '0';
        ALUSrc   <= '0';
        MemRead  <= '0';
        MemWrite <= '0';
        Branch   <= '0';
        Jump     <= '0';
        MemToReg <= '0';
        ALUOp    <= "00";  -- Padrão: ADD

        case opcode is
            when "0000" =>  -- ADD
                RegWrite <= '1';
                ALUSrc   <= '0';
                MemToReg <= '0';
                ALUOp    <= "00";
            when "0001" =>  -- SUB
                RegWrite <= '1';
                ALUSrc   <= '0';
                MemToReg <= '0';
                ALUOp    <= "01";
            when "0010" =>  -- AND
                RegWrite <= '1';
                ALUSrc   <= '0';
                MemToReg <= '0';
                ALUOp    <= "10";
            when "0011" =>  -- OR
                RegWrite <= '1';
                ALUSrc   <= '0';
                MemToReg <= '0';
                ALUOp    <= "11";
            when "0100" =>  -- LW
                RegWrite <= '1';
                ALUSrc   <= '1';  -- Usa imediato para cálculo do endereço
                MemRead  <= '1';
                MemToReg <= '1';
                ALUOp    <= "00"; -- ADD para calcular endereço
            when "0101" =>  -- SW
                RegWrite <= '0';
                ALUSrc   <= '1';
                MemWrite <= '1';
                ALUOp    <= "00"; -- ADD para calcular endereço
            when "0110" =>  -- BEQ
                RegWrite <= '0';
                ALUSrc   <= '0';
                Branch   <= '1';
                ALUOp    <= "01"; -- SUB para comparação
            when "0111" =>  -- JUMP
                RegWrite <= '0';
                Jump     <= '1';
            when others =>
                null;
        end case;
    end process;
end Behavioral;
