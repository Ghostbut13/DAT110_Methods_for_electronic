library IEEE;
use IEEE.std_logic_1164.all;

entity DOT is
  port(p1 : in  std_logic;
       g1 : in  std_logic;
       p2 : in  std_logic;
       g2 : in  std_logic;
       p  : out std_logic;
       g  : out std_logic);
end;

architecture rtl of DOT is
begin
  g <= g1 or (g2 and p1);
  p <= p1 and p2;
end;
