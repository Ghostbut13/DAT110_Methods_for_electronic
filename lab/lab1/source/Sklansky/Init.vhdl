library IEEE;
use IEEE.std_logic_1164.all;

entity Init is
  port(a : in  std_logic;
       b : in  std_logic;
       g : out std_logic;
       p : out std_logic);
end;

architecture rtl of Init is
begin
  g <= a and b;
  p <= a xor b;
end;
