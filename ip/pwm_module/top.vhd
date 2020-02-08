-------------------------------------------------------------------------------
-- Dr. Kaputa
-- blink top
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity top is
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
    enable          : in  std_logic;
    pwm_out          : out std_logic;
    period          : in  std_logic_vector(26 downto 0);
    duty            : in  std_logic_vector(26 downto 0)  
  );
end top;

architecture beh of top is

--attribute mark_debug : string;
--attribute keep : string;
--attribute mark_debug of  clk: signal is "true";
--attribute mark_debug of  reset: signal is "true";
--attribute mark_debug of  enable: signal is "true";
--attribute mark_debug of  duty: signal is "true";
--attribute mark_debug of  period: signal is "true";
--attribute mark_debug of  pwm_out: signal is "true";

component pwm_module is
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
    enable          : in  std_logic;
    output          : out std_logic;
    period          : in  std_logic_vector(26 downto 0);
    duty            : in  std_logic_vector(26 downto 0)  
  );  
end component;  

begin

uut: pwm_module  
  port map(
    clk       => clk,
    reset     => reset,
    enable    => enable,  
    output    => pwm_out,      
    period    => period,      
    duty      => duty        
  );
end beh;