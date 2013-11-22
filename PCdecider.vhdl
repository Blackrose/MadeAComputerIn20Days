library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity PCdecider is
  port (
    clock: in std_logic;
    reset: in std_logic;

    JUMP_true: in std_logic;
    JUMP_addr: in std_logic_vector(31 downto 0);

    PC: out std_logic_vector(31 downto 0)
  ) ;
end entity ; -- PCdecider

architecture arch of PCdecider is

    constant BEGIN_PC: std_logic_vector(31 downto 0) := (others => '0');
    signal state: std_logic := '0';
    signal s_pc: std_logic_vector(31 downto 0) := BEGIN_PC;

begin

  process(clock, reset)
  begin
    if reset = '1' then
      state <= '0';
      s_pc <= BEGIN_PC;
      PC <= BEGIN_PC;
    elsif rising_edge(clock) then
      case( state ) is
      
        when '0' =>
          if JUMP_true = '1' then -- jump!
            s_pc <= JUMP_addr;
          else
            s_pc <= std_logic_vector(unsigned(s_pc)+4);
          end if;

          state <= '1';
      
        when others =>
          PC <= s_pc;

          state <= '0';
      
      end case ;
    end if;
  end process;

end architecture ; -- arch