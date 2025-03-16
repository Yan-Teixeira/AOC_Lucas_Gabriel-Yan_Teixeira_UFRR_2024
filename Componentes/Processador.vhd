library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Processador is
    Port (
        Clock : in  std_logic;
        Reset : in  std_logic
    );
end Processador;

architecture Behavioral of Processador is

    --------------------------------------------------------------------------
    -- Sinais do Datapath
    --------------------------------------------------------------------------
    signal PC         : std_logic_vector(7 downto 0);  -- Program Counter
    signal Instr      : std_logic_vector(7 downto 0);  -- Instrução lida da ROM
    signal Opcode     : std_logic_vector(3 downto 0);  -- 4 bits de opcode
    signal Imm4       : std_logic_vector(3 downto 0);  -- Imediato de 4 bits
    signal Imm8       : std_logic_vector(7 downto 0);  -- Imediato estendido para 8 bits

    -- Sinais de controle gerados pela Unidade de Controle
    signal RegWrite, ALUSrc, MemRead, MemWrite, Branch, Jump, MemToReg : std_logic;
    signal ALUOp      : std_logic_vector(1 downto 0);

    -- Sinais do banco de registradores
    signal RegData1, RegData2 : std_logic_vector(7 downto 0);
    signal WriteData          : std_logic_vector(7 downto 0);

    -- Sinais da ALU
    signal ALUResult : std_logic_vector(7 downto 0);
    signal Zero      : std_logic;

    -- Sinal para seleção da segunda entrada da ALU (MUX entre regData2 e Imm8)
    signal ALUB_in   : std_logic_vector(7 downto 0);

    -- Sinais para acesso à RAM
    signal MemReadData : std_logic_vector(7 downto 0);

    -- Sinal para PC+1 (calculado pelo Somador)
    signal PC_next : std_logic_vector(7 downto 0);

begin

    --------------------------------------------------------------------------
    -- Contator de Programa (PC)
    --------------------------------------------------------------------------
    PC_inst: entity work.ContadorPrograma
        port map (
            clk    => Clock,
            reset    => Reset,
            jump     => Jump,         -- Se jump for '1', o PC carrega nextPC
            nextPC   => PC_next,      -- PC+1 (ou endereço de salto, conforme controlado internamente)
            PC       => PC
        );

    --------------------------------------------------------------------------
    -- Somador: PC + 1
    --------------------------------------------------------------------------
    Somador_inst: entity work.Somador
        port map (
            A     => PC,
            B     => "00000001",
            Sum   => PC_next,
            Carry => open   -- Ignoramos o Carry
        );

    --------------------------------------------------------------------------
    -- ROM: Busca a instrução usando o PC
    --------------------------------------------------------------------------
    ROM_inst: entity work.Rom
        port map (
            addr  => PC,
            instr => Instr
        );

    --------------------------------------------------------------------------
    -- Extração dos Campos da Instrução
    -- Supomos: bits 7 a 4 = opcode; bits 3 a 0 = imediato
    --------------------------------------------------------------------------
    process(Instr)
    begin
        Opcode <= Instr(7 downto 4);
        Imm4   <= Instr(3 downto 0);
    end process;

    --------------------------------------------------------------------------
    -- Unidade de Controle
    --------------------------------------------------------------------------
    UC_inst: entity work.Unidade_de_controle
        port map (
            opcode   => Opcode,
            RegWrite => RegWrite,
            ALUSrc   => ALUSrc,
            MemRead  => MemRead,
            MemWrite => MemWrite,
            Branch   => Branch,
            Jump     => Jump,
            MemToReg => MemToReg,
            ALUOp    => ALUOp
        );

    --------------------------------------------------------------------------
    -- Extensor: Estende o imediato de 4 bits para 8 bits
    --------------------------------------------------------------------------
    Extensor_inst: entity work.Extensor_4x8
        port map (
            in4  => Imm4,
            out8 => Imm8
        );

    --------------------------------------------------------------------------
    -- Multiplexador para a entrada B da ALU
    -- Se ALUSrc = '0' => usa RegData2; se '1' => usa Imm8
    --------------------------------------------------------------------------
    Mux_ALU_inst: entity work.Multiplexador
        port map (
            sel => ALUSrc,
            d0  => RegData2,
            d1  => Imm8,
            y   => ALUB_in
        );

    --------------------------------------------------------------------------
    -- Banco de Registradores
    -- Supondo que os endereços para leitura e escrita sejam extraídos de campos da instrução.
    -- Aqui, por exemplo, usamos os bits [3:1] da instrução para endereçar (3 bits = 8 registradores).
    --------------------------------------------------------------------------
    Registradores_inst: entity work.Registradores
        port map (
            clk       => Clock,
            regWrite  => RegWrite,
            readAddr1 => Instr(3 downto 1),  -- Exemplo: bits 3 a 1
            readAddr2 => "000",              -- Pode ser ajustado conforme a sua ISA
            writeAddr => Instr(3 downto 1),  -- Exemplo: mesmo campo
            writeData => WriteData,
            readData1 => RegData1,
            readData2 => RegData2
        );

    --------------------------------------------------------------------------
    -- ULA (Unidade Lógica e Aritmética)
    --------------------------------------------------------------------------
    ULA_inst: entity work.ULA
    port map (
        A     => RegData1,
        B     => ALUB_in,
        AluOp => ALuOp,   -- Conecte o sinal de controle da UC ao port AluOp da ULA
        result=> ALUResult,
        zero  => Zero
    );


    --------------------------------------------------------------------------
    -- RAM: Memória de Dados
    -- Assume que a RAM é acessada usando o resultado da ALU como endereço.
    --------------------------------------------------------------------------
    RAM_inst: entity work.RAM
        port map (
            clk       => Clock,
            we        => MemWrite,
            addr      => ALUResult,    -- Endereço para acesso à RAM
            din       => RegData2,     -- Dados a serem escritos (para SW)
            dout      => MemReadData   -- Dados lidos (para LW)
        );

    --------------------------------------------------------------------------
    -- Multiplexador de Write Back:
    -- Se MemToReg = '0', o dado vem da ALU; se '1', vem da RAM.
    --------------------------------------------------------------------------
    Mux_WB_inst: entity work.Multiplexador
        port map (
            sel => MemToReg,
            d0  => ALUResult,
            d1  => MemReadData,
            y   => WriteData
        );

end Behavioral;
