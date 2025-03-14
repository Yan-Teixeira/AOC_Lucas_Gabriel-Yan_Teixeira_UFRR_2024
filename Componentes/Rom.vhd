library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ROM is
    Port (
        addr  : in  std_logic_vector(7 downto 0);  -- Endereço de 8 bits (0 a 255)
        instr : out std_logic_vector(7 downto 0)   -- Instrução de 8 bits
    );
end ROM;

architecture Behavioral of ROM is
    -- Define um array com 256 posições, cada uma com 8 bits.
    type rom_array is array (0 to 255) of std_logic_vector(7 downto 0);
    constant ROM_Content : rom_array := (
	 
	 --Teste do fatorial
        0 => "00010011",  -- LI S0, 3   (opcode "0001", S0="00", imm="11")
        1 => "00010101",  -- LI S1, 1   (opcode "0001", S1="01", imm="01")
        2 => "00011001",  -- LI S2, 1   (opcode "0001", S2="10", imm="01")
        3 => "01100010",  -- IF S0,S2  (opcode "0110", S0="00", S2="10")
        4 => "01000111",  -- BEQ 7     (opcode "0100", endereço "0111")
        5 => "00110110",  -- MULT S1,S1,S2 (opcode "0011", S1="01", S2="10")
        6 => "00101001",  -- ADDI S2,S2,1 (opcode "0010", S2="10", imm="01")
        7 => "01010011",  -- JUMP 3    (opcode "0101", endereço "0011")
		  
        others => "00000000"
    );
begin
    -- A saída 'instr' é atualizada combinacionalmente, indexando a ROM pelo endereço convertido para inteiro.
    instr <= ROM_Content(to_integer(unsigned(addr)));
end Behavioral;
