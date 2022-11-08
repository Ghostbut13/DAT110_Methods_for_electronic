library IEEE;
use IEEE.std_logic_1164.all;

entity FA is
  
  port (
    a    : in  std_logic;
    b    : in  std_logic;
    cin  : in  std_logic;
    cout : out std_logic;
    sum  : out std_logic);

end entity FA;

architecture rtl of FA is

begin
  sum  <= (a xor b) xor cin;
  cout <= (a and b) or (cin and a) or (cin and b);

end architecture rtl;
