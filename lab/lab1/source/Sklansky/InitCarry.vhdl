library IEEE;
use IEEE.std_logic_1164.all;

entity InitCarry is
  port(a : in  std_logic;
       b : in  std_logic;
       c : in  std_logic;
       g : out std_logic;
       p : out std_logic);
end;

architecture rtl of InitCarry is
begin
  g <= (a and b) or (a and c) or (b and c);
  p <= a xor b xor c;
end;
