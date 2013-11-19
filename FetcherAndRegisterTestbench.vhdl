library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity FetcherAndRegisterTestbench is

end entity ; -- FetcherAndRegisterTestbench


architecture arch of FetcherAndRegisterTestbench is

component FetcherAndRegister port (
    PC: in std_logic_vector(31 downto 0);
    clock: in std_logic;
    reset: in std_logic;

    BACK_REG_write: in std_logic;
    BACK_REG_write_addr: in std_logic_vector(4 downto 0);
    BACK_REG_write_data: in std_logic_vector(31 downto 0);

    BASERAM_CE : out  STD_LOGIC;
    BASERAM_OE : out  STD_LOGIC;
    BASERAM_WE : out  STD_LOGIC; -- base ram stores instructions
    BASERAM_addr: out std_logic_vector(19 downto 0);
    BASERAM_data: inout std_logic_vector(31 downto 0);

    ALU_operator: out std_logic_vector(3 downto 0);
    ALU_numA: out std_logic_vector(31 downto 0);
    ALU_numB: out std_logic_vector(31 downto 0);

    JUMP_true: out std_logic;
    JUMP_use_alu: out std_logic;
    JUMP_true_if_alu_out_true: out std_logic;
    JUMP_addr: out std_logic_vector(31 downto 0);

    MEM_read: out std_logic;
    MEM_write: out std_logic;
    MEM_addr_or_data: out std_logic_vector(31 downto 0);
    MEM_use_aluout_as_addr: out std_logic;
    -- if it's set to 0: MEM use MEM_addr_or_data as addr, use ALU output as data
    -- else: MEM use MEM_addr_or_data as data, use ALU output as addr

    REG_write: out std_logic;
    REG_write_addr: out std_logic_vector(4 downto 0)  -- we have 32 registers
  ) ;
 end component ; -- FetcherAndRegister 

  signal clock: std_logic := '0';

  signal ALU_operator:  std_logic_vector(3 downto 0);
  signal ALU_numA:  std_logic_vector(31 downto 0);
  signal ALU_numB:  std_logic_vector(31 downto 0);

  signal JUMP_true:  std_logic;
  signal JUMP_use_alu:  std_logic;
  signal JUMP_true_if_alu_out_true:  std_logic;
  signal JUMP_addr:  std_logic_vector(31 downto 0);

  signal MEM_read:  std_logic;
  signal MEM_write:  std_logic;
  signal MEM_addr_or_data:  std_logic_vector(31 downto 0);
  signal MEM_use_aluout_as_addr:  std_logic;

  signal REG_write:  std_logic;
  signal REG_write_addr:  std_logic_vector(4 downto 0);  -- we have 32 registers

  constant clk_period :time :=20 ns;
  signal data: std_logic_vector(31 downto 0);

begin

    instance: FetcherAndRegister port map (
        PC => (others => '0'), 
        clock => clock, 
        reset => '0',

        BACK_REG_write => '0',
        BACK_REG_write_addr => (others => '0'),
        BACK_REG_write_data => (others => '0'),

        BASERAM_CE  => open,
        BASERAM_OE  => open,
        BASERAM_WE  => open,
        BASERAM_addr => open,
        BASERAM_data => data, -- instruction

        ALU_operator => ALU_operator,
        ALU_numA => ALU_numA,
        ALU_numB => ALU_numB,

        JUMP_true => JUMP_true,
        JUMP_use_alu => JUMP_use_alu,
        JUMP_true_if_alu_out_true => JUMP_true_if_alu_out_true,
        JUMP_addr => JUMP_addr,

        MEM_read => MEM_read,
        MEM_write => MEM_write,
        MEM_addr_or_data => MEM_addr_or_data,
        MEM_use_aluout_as_addr => MEM_use_aluout_as_addr,

        REG_write => REG_write,
        REG_write_addr => REG_write_addr

        );

    process begin
        data(31 downto 26) <= "000100";
        data(25 downto 21) <= "00001";
        data(20 downto 16) <= "00011";
        data(15 downto 0) <= "0000000000001111";
        wait for clk_period/2;
        clock <= '1';
        wait for clk_period/2;
        clock <= '0';
        wait for clk_period/2;
        clock <= '1';
        wait for clk_period/2;
        clock <= '0';
        wait for clk_period/2;
        wait;
    end process;

end architecture ; -- arch