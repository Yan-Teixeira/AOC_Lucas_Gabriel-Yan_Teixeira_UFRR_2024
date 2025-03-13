LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity Ula is
PORT(
    Clock     : in  std_logic;
    AluOp     : in  std_logic_vector(3 downto 0);
    rs, rd    : in  std_logic_vector(7 downto 0);
    resultado : out std_logic_vector(7 downto 0);
    z         : out std_logic
);
end entity;

architecture Behavior of Ula is
    signal in_branch_helper, out_branch_helper: std_logic;
    
    component Branch_helper is
        port(
            A: in std_logic;
            S: out std_logic
        );
    end component;
    
begin

    Bh: Branch_helper port map(
        A => in_branch_helper,
        S => out_branch_helper
    );
    
    process (Clock, AluOp, rs, rd, in_branch_helper, out_branch_helper)
    begin
        case AluOp is
            
            when "0000" | "0001" => -- ADD
                resultado <= std_logic_vector(unsigned(rs) + unsigned(rd));
            
            when "0010" | "0011" => -- SUB
                resultado <= std_logic_vector(unsigned(rs) - unsigned(rd));
            
            when "0100" => -- LW (load word)
                resultado <= rs;
            
            when "0101" => -- SW (store word)
                resultado <= rs;
            
            when "0110" => -- LI (load immediate)
                resultado <= rd;
            
            when "0111" => -- BEQ (branch equal)
                if out_branch_helper = '1' then
                    z <= '1';
                else
                    z <= '0';
                end if;
                resultado <= (others => '0');
            
            when "1000" => -- IF (comparação)
                if rs = rd then
                    in_branch_helper <= '1';
                else
                    in_branch_helper <= '0';
                end if;
                resultado <= (others => '0');
                
            when "1010" | "1011" => -- MULT (multiplicação)
                resultado <= std_logic_vector(resize(unsigned(rs) * unsigned(rd), 8));
                
            when others =>
                resultado <= (others => '0');
        end case;
    end process;
    
end architecture;
