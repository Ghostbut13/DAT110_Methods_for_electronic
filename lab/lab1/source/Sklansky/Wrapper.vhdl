library IEEE;
use IEEE.std_logic_1164.all;

entity wrapper is
  generic (WL : positive := 16);
  port (
    clk  : in  std_logic;
    a    : in  std_logic_vector(WL-1 downto 0);
    b    : in  std_logic_vector(WL-1 downto 0);
    cin  : in  std_logic;
    cout : out std_logic;
    sum  : out std_logic_vector(WL-1 downto 0));

end entity wrapper;

architecture rtl of wrapper is

  -----------------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------------
  component adder
    generic (WL : positive);
    port(a    : in  std_logic_vector(WL-1 downto 0);
         b    : in  std_logic_vector(WL-1 downto 0);
         cin  : in  std_logic;
         cout : out std_logic;
         sum  : out std_logic_vector(WL-1 downto 0));
  end component;

  -----------------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------------
  signal a_reg     : std_logic_vector(WL-1 downto 0);
  signal b_reg     : std_logic_vector(WL-1 downto 0);
  signal cin_reg   : std_logic;
  signal cout_comb : std_logic;
  signal sum_comb  : std_logic_vector(WL-1 downto 0);
  
begin
  seq : process (clk)
  begin
    if rising_edge(clk) then
      a_reg   <= a;
      b_reg   <= b;
      cin_reg <= cin;
      cout    <= cout_comb;
      sum     <= sum_comb;
    end if;
  end process;

  -----------------------------------------------------------------------------
  -- Instances
  -----------------------------------------------------------------------------
  add_inst : adder
    generic map (WL)
    port map (
      a    => a_reg,
      b    => b_reg,
      cin  => cin_reg,
      cout => cout_comb,
      sum  => sum_comb);

end architecture rtl;
