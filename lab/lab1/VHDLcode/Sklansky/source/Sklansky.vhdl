library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

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
  -- Constants
  -----------------------------------------------------------------------------
  constant DEPTH : integer := integer(CEIL(LOG2(real(WL))));

  -----------------------------------------------------------------------------
  -- Components
  -----------------------------------------------------------------------------
  component InitCarry
    port(a : in  std_logic;
         b : in  std_logic;
         c : in  std_logic;
         g : out std_logic;
         p : out std_logic);
  end component;

  component Init
    port(a : in  std_logic;
         b : in  std_logic;
         g : out std_logic;
         p : out std_logic);
  end component;

  component DOT
    port(p1 : in  std_logic;
         g1 : in  std_logic;
         p2 : in  std_logic;            -- P signal from the previous stage
         g2 : in  std_logic;            -- G signal from the previous stage
         p  : out std_logic;
         g  : out std_logic);
  end component;

  component gDOT
    port(p1 : in  std_logic;
         g1 : in  std_logic;
         g2 : in  std_logic;            --G signal from the previous stage
         g  : out std_logic);
  end component;

  component E
    port(g   : in  std_logic;
         x   : in  std_logic;
         sum : out std_logic);
  end component;

  -----------------------------------------------------------------------------
  -- Types
  -----------------------------------------------------------------------------
  subtype int_signal is std_logic_vector(WL-1 downto 0);
  type int_signal_vector is array (depth downto 0) of int_signal;

  -----------------------------------------------------------------------------
  -- Signals
  -----------------------------------------------------------------------------
  signal p : int_signal_vector;
  signal g : int_signal_vector;

begin

  -- Bitwise PG logic (generates inital G and P)
  -- Use full adder for LSB, since we have cin as input
  InitCarry_inst : InitCarry
    port map (a => a(0),
              b => b(0),
              c => cin,
              g => g(0)(0),
              p => p(0)(0));

  --   Half adders used for remaining bits    
  init_row : for i in 1 to WL-1 generate
    Init_inst : Init
      port map (a => a(i),
                b => b(i),
                g => g(0)(i),
                p => p(0)(i));
  end generate init_row;

  -- Group PG logic
  rows : for i in 1 to DEPTH generate
    columns : for j in 0 to WL-1 generate
      -- Check if cell should be inserted
      cells : if ((integer(FLOOR(real(j)/real(2**(i-1))))) mod 2) = 1 generate
        -- Insert gray cell at last cell position in column
        gDOTs : if j < 2**(i) generate
          gDOT_inst : gDOT
            port map (p1 => p(i-1)(j),
                      g1 => g(i-1)(j),
                      g2 => g(i-1)(2**(i)-1),--!find the correct description!),
                      g  => g(i)(j));
        end generate gDOTs;

        -- Insert black cells at remaining cell positions
        DOTs : if j >= 2**(i) generate
          DOT_inst : DOT
            port map(p1 => p(i-1)(j),
                     g1 => g(i-1)(j),
                     p2 => p(i-1)(FLOOR(real(j)/real(2**(i-1)))*(2**(i-1))-1),--!find the correct description!),
                     g2 => g(i-1)(FLOOR(real(j)/real(2**(i-1)))*(2**(i-1))-1),--!find the correct description!),
                     p  => p(i)(j),
                     g  => g(i)(j));
        end generate DOTs;
      end generate cells;

      -- If no cell is inserted, propagate signals from previous row
      no_cells : if ((integer(FLOOR(real(j)/real(2**(i-1))))) mod 2) /= 1 generate
        p(i)(j) <= p(i-1)(j);
        g(i)(j) <= g(i-1)(j);
      end generate no_cells;
    end generate columns;
  end generate rows;

  -- Sum logic
  sum(0) <= p(0)(0);
  sum_logic : for j in 1 to WL-1 generate
    E_inst : E
      port map (g   => g(DEPTH)(j-1),
                x   => p(0)(j),
                sum => sum(j));
  end generate sum_logic;

  -- Carry out calculation
  cout <= g(DEPTH)(WL-1);

end architecture rtl;
