library IEEE;
use IEEE.std_logic_1164.all;

entity E is
  port(g   : in  std_logic;
       x   : in  std_logic;
       sum : out std_logic);
end;

architecture rtl of E is
begin
  sum <= x xor g;
end;
