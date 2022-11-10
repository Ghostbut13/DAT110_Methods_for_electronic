library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;

-- entity declaration
entity TB_skeleton is
-- architecture start
end TB_skeleton;

architecture arch_TB_skeleton of TB_skeleton is
  
  -- constant and type declarations, for example
  constant clktime      : time := 100 ns; -- half clk cycle 
  constant cycletime    : time := clktime *2; -- one clk cycle
  constant pushstart    : time := clktime / 10;
  constant comparestart : time := cycletime *2 + pushstart;
  constant WL           : positive := 16;
  -- adder wordlength
  constant CYCLES     : positive := 1000+1;
  -- number of test vectors to load
  type word_array is array (0 to CYCLES-1) of std_logic_vector(WL-1 downto 0);
  -- type used to store WL-bit test vectors for CYCLES cycles
  file LOG : text open write_mode is "E:\CTH-EESD\Q2\DAT110_Methods_for_electronic\lab\lab1\doc\mylog.log";
  -- file to which you can write information
  constant  file_A : string :=  "E:/CTH-EESD/Q2/DAT110_Methods_for_electronic/lab/lab1/sim/random/A.tv";
  constant  file_B: string :=  "E:/CTH-EESD/Q2/DAT110_Methods_for_electronic/lab/lab1/sim/random/B.tv";
  constant  file_ExpectedOutput: string := "E:/CTH-EESD/Q2/DAT110_Methods_for_electronic/lab/lab1/sim/random/ExpectedOutput.tv";
  
  

-- component declarations, for example
  component wrapper is
    generic (WL : positive);
    port(
      clk  : in  std_logic;
      a    : in  std_logic_vector(WL-1 downto 0);
      b    : in  std_logic_vector(WL-1 downto 0);
      cin  : in  std_logic;
      cout : out std_logic;
      sum  : out std_logic_vector(WL-1 downto 0));
  end component;
  
  signal mem_CYCLES_WL_A : word_array;  -- store the summand---A
  signal mem_CYCLES_WL_B : word_array;  -- store the summand---B
  signal mem_ExpectedOutput : word_array;
  signal mem_RealOutput : word_array;
  signal a_tb3_signal: std_logic_vector(WL-1 downto 0);
  signal b_tb3_signal : std_logic_vector(WL-1 downto 0);
  signal sum_tb3_signal : std_logic_vector(WL-1 downto 0);
  signal cin_tb3_signal : std_logic := '0';
  signal cout_tb3_signal : std_logic;
  signal clk_tb3_signal : std_logic := '0';
  signal wait_1cy : integer := 0;
  
  -- functions
  function to_std_logic (char : character) return std_logic is
    variable result : std_logic;
  begin
    case char is
      when '0'    => result := '0';
      when '1'    => result := '1';
      when 'x'    => result := '0';
      when others => assert (false) report "no valid binary character read" severity failure;
    end case;
    return result;
  end to_std_logic;

  impure function load_words (file_name : string) return word_array is
    file object_file : text open read_mode is file_name;
    variable memory  : word_array;
    variable L       : line;
    variable index   : natural := 0;
    variable char    : character;
  begin
    while not endfile(object_file) loop
      readline(object_file, L);
      for i in WL-1 downto 0 loop
        read(L, char);
        -- report integer'image(i);
        report integer'image(index);
        memory(index)(i) := to_std_logic(char);
      end loop;
      index := index + 1;
    end loop;
    return memory;
  end load_words;


  -- testbench code

begin
-- component inst
  adder_inst : wrapper
    generic map( WL => WL)
    port map (
      clk  => clk_tb3_signal,
      a    => a_tb3_signal,
      b    => b_tb3_signal,
      cin  => cin_tb3_signal,
      cout => cout_tb3_signal,
      sum  => sum_tb3_signal);

  proc_clk : 
  process
  begin
    wait for clktime;
    clk_tb3_signal <= not(clk_tb3_signal) ;
  end process proc_clk;

  mem_CYCLES_WL_A <=  load_words("E:/CTH-EESD/Q2/DAT110_Methods_for_electronic/lab/lab1/sim/regular/A.tv");
  mem_CYCLES_WL_B <=  load_words("E:/CTH-EESD/Q2/DAT110_Methods_for_electronic/lab/lab1/sim/regular/B.tv");
  mem_ExpectedOutput <= load_words("E:/CTH-EESD/Q2/DAT110_Methods_for_electronic/lab/lab1/sim/regular/ExpectedOutput.tv");

  verification_process : process 
    variable index : natural := 0;
    variable L     : line;
  begin
    if index=0 then
      wait for pushstart;
    else
      wait for cycletime;
    end if;
    -- wait for clktime;
    -- clk_tb3_signal <= not(clk_tb3_signal) ;
    -- read the A.tv -----> mem_A
    -- read the B.tv -----> mem_B
    -- read the ExpectedOutput------> mem_expected    
    -- mem_CYCLES_WL_A <=  load_words("E:/CTH-EESD/Q2/DAT110_Methods_for_electronic/lab/lab1/sim/random/A.tv");
    -- mem_CYCLES_WL_B <=  load_words("E:/CTH-EESD/Q2/DAT110_Methods_for_electronic/lab/lab1/sim/random/B.tv");
    -- mem_ExpectedOutput <= load_words("E:/CTH-EESD/Q2/DAT110_Methods_for_electronic/lab/lab1/sim/random/ExpectedOutput.tv");
    a_tb3_signal <= mem_CYCLES_WL_A(index);
    b_tb3_signal <= mem_CYCLES_WL_B(index);
    mem_RealOutput(index) <= sum_tb3_signal;
    if index <= cycles-2 then 
      index:=index+1;
    end if;
  --wait for 10 ns;      
  -- wait for delaytime ;
  end process verification_process;

  verification_process_2 : process 
    variable index : natural := 0;
    variable L     : line;
  begin
      if index=0 then
        wait for comparestart;
      else
        wait for cycletime;
      end if;
       --mem_RealOutput(index) <= sum_tb3_signal;
      assert sum_tb3_signal = mem_ExpectedOutput(index) report "error my friend" severity error;
      -- write something to my_log
      if sum_tb3_signal /= mem_ExpectedOutput(index) then
        write(L, string'("index = "));
        write(L, index);
        write(L, string'("FALSE"));
        writeline(LOG, L);
      else
        write(L, string'("index = "));
        write(L, index);
        write(L, string'("correct"));
        writeline(LOG, L);
      end if;
    --end loop;
    if index <= cycles-2 then 
      index:=index+1;
    end if;
    -- if index=cycles-1 then
    --   exit;
    -- end if;

    
    -- for index in 0 to cycles-1 loop
    --   -- push the stimuli into component
    --   --if index<=cycles-2 then

    --   --wait for clktime;
    --     a_tb3_signal <= mem_CYCLES_WL_A(index);
    --     b_tb3_signal <= mem_CYCLES_WL_B(index);
    --   --end if;
    
    --   --wait for delaytime ;
    
    --   --mem_RealOutput(index) <= sum_tb3_signal;
    --   --if index >=1 then
    --     mem_RealOutput(index) <= sum_tb3_signal;
    --     assert sum_tb3_signal = mem_ExpectedOutput(index) report "error my friend" severity error;
    --     -- write something to my_log
    --     if sum_tb3_signal /= mem_ExpectedOutput(index) then
    --       write(L, string'("index = "));
    --       write(L, index);
    --       write(L, string'("FALSE"));
    --       writeline(LOG, L);
    --     else
    --       write(L, string'("index = "));
    --       write(L, index);
    --       write(L, string'("correct"));
    --       writeline(LOG, L);
    --     end if;
    --     -- if index=cycles-1 then
    --     --   exit;
    --     -- end if;

    --   --end if;
    
    -- end loop;  -- i


  end process verification_process_2;
  
end architecture arch_TB_skeleton;
