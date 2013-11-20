library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity Memory is
  port (
    clock: in std_logic;
    reset: in std_logic;

    ALU_output: in std_logic_vector(31 downto 0);
    MEM_read: in std_logic;
    MEM_write: in std_logic;
    MEM_addr_or_data: in std_logic_vector(31 downto 0);
    MEM_use_aluout_as_addr: in std_logic;
    -- if it's set to 0: MEM use MEM_addr_or_data as addr, use ALU output as data
    -- else: MEM use MEM_addr_or_data as data, use ALU output as addr
    MEM_output: out std_logic_vector(31 downto 0) := (others => '0');

    in_REG_write: in std_logic;
    in_REG_write_addr: in std_logic_vector(4 downto 0);
    REG_write: out std_logic := '0';
    REG_write_addr: out std_logic_vector(4 downto 0) := (others => '0');

    EXTRAM_CE : out  STD_LOGIC;
    EXTRAM_OE : out  STD_LOGIC;
    EXTRAM_WE : out  STD_LOGIC; -- base ram stores data
    EXTRAM_addr: out std_logic_vector(19 downto 0);
    EXTRAM_data: inout std_logic_vector(31 downto 0)
  ) ;
end entity ; -- Memory

architecture arch of Memory is
    signal state: std_logic := '0';
    signal s_output: std_logic_vector(31 downto 0);
    signal s_use_me_as_output: std_logic;

    signal s_REG_write: std_logic:= '0';
    signal s_REG_write_addr: std_logic_vector(4 downto 0):= (others => '0');
begin

  EXTRAM_CE <= '0';
  EXTRAM_OE <= '0';

  process(clock, reset)
  begin

    if reset = '1' then
      state <= '0';
      EXTRAM_WE <= '1'; -- disable write
      EXTRAM_data <= (others => 'Z');
      MEM_output <= (others => '0');
      REG_write <= '0';
      REG_write_addr <= (others => '0');
    elsif rising_edge(clock) then
      case( state ) is
      
        when '0' => -- start
          if MEM_read = '1' then 
            if MEM_use_aluout_as_addr = '1' then
              EXTRAM_addr <= ALU_output(19 downto 0);
            else
              EXTRAM_addr <= MEM_addr_or_data(19 downto 0);
            end if;
            EXTRAM_data <= (others => 'Z');
            s_use_me_as_output <= '0'; -- use ram data as output
          elsif MEM_write = '1' then
            if MEM_use_aluout_as_addr = '1' then
              EXTRAM_addr <= ALU_output(19 downto 0);
              EXTRAM_data <= MEM_addr_or_data;
              s_output <= MEM_addr_or_data;
            else
              EXTRAM_addr <= MEM_addr_or_data(19 downto 0);
              EXTRAM_data <= ALU_output;
              s_output <= ALU_output;
            end if;
            s_use_me_as_output <= '1';
            EXTRAM_WE <= '0';
          else
            EXTRAM_data <= (others => 'Z');
            s_use_me_as_output <= '1';
            s_output <= ALU_output;
          end if;

          state <= '1';
          s_REG_write <= in_REG_write;
          s_REG_write_addr <= in_REG_write_addr;
      
        when others =>
          if s_use_me_as_output = '1' then
            MEM_output <= s_output;
          else
            MEM_output <= EXTRAM_data;
          end if;
          EXTRAM_WE <= '1';

          state <= '0';
          REG_write <= s_REG_write;
          REG_write_addr <= s_REG_write_addr;

      end case ;
    end if;

  end process ; 

end architecture ; -- arch