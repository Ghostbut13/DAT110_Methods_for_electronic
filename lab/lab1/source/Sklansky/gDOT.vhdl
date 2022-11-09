library IEEE;
use IEEE.std_logic_1164.all;

entity gDOT is
  port(p1 : in  std_logic;
       g1 : in  std_logic;
       g2 : in  std_logic;
       g  : out std_logic);
end;

architecture rtl of gDOT is
begin
  g <= g1 or (g2 and p1);
end;
