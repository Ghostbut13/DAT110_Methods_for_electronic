library IEEE;
use IEEE.std_logic_1164.all;

entity adder is
  generic (WL : positive);
  port(a    : in  std_logic_vector(WL-1 downto 0);
       b    : in  std_logic_vector(WL-1 downto 0);
       cin  : in  std_logic;
       cout : out std_logic;
       sum  : out std_logic_vector(WL-1 downto 0));
end entity adder;

architecture rtl of adder is

  -----------------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------------
  component FA
    port (a    : in  std_logic;
          b    : in  std_logic;
          cin  : in  std_logic;
          cout : out std_logic;
          sum  : out std_logic);
  end component;

  -----------------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------------
  signal fa_cout : std_logic_vector(WL-1 downto 0);

begin
  cout <= fa_cout(WL-1);

  FA0_inst : FA
    port map (
      a    => a(0),
      b    => b(0),
      cin  => cin,
      cout => fa_cout(0),
      sum  => sum(0));

  FAG : for j in 1 to WL-1 generate
    FA_inst : FA
      port map (
        a    => a(j),
        b    => b(j),
        cin  => fa_cout(j-1),
        cout => fa_cout(j),
        sum  => sum(j));
  end generate FAG;
  
end architecture rtl;
