-------------------------------------------------------------------------------
-- Engineer Name: Joseph Rondinelli
-- Creation Date: 2/2/2020
-- File Name: pwm_module.vhd
-- Module Name:  pwm_module
-- Project Name: N/A
-- Tool Versions: 
--    Vivado HLx 2019.1.3
--    ModelSim PE Student Edition 10.4a
 
-- Description:
--    This modules primary purpose is to act as pulse width 
--  modulator. This module takes in raw period and duty vectors
--  and generates a std_logic '1' or '0' pwm.
-------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- LIBRARYS
--------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;      
  use ieee.numeric_std.all; 
  use IEEE.STD_LOGIC_ARITH.ALL;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pwm_module is
  port (
    clk             : in  std_logic; 
    reset           : in  std_logic;
    enable          : in  std_logic;
    output          : out std_logic;
    period          : in  std_logic_vector(26 downto 0);
    duty            : in  std_logic_vector(26 downto 0)  
  );  
end pwm_module;  

architecture beh of pwm_module  is

--------------------------------------------------------------------------------
-- SIGNALS
--------------------------------------------------------------------------------

signal count_sig             : std_logic_vector(26 downto 0) := (others => '0');
signal pwm_out               : std_logic                     := '0';
signal ris_edge,ris_edge2,
       enable_z1,enable_z2   : std_logic                     := '0';

begin

--------------------------------------------------------------------------------
-- SYNC PROCESSES
--------------------------------------------------------------------------------

--------------------------------------------
-- resync_enable:
-- This will synchronize any input signals 
-- to the rising edge of the source clk
---------------------------------------
resync_enable: process(
    reset,
    clk,
    enable
  )
  begin
  
    if (reset = '1') then
      ris_edge    <= '0';
      ris_edge2   <= '0';
      enable_z1   <= '0';
      enable_z2   <= '0';
    elsif (rising_edge(clk)) then
      enable_z1   <= enable;
      enable_z2   <= enable_z1;
      ris_edge    <= (enable xor enable_z1) and enable;
      ris_edge2   <= (enable_z1 xor enable_z2) and enable_z1;
    end if;
end process resync_enable;  


--------------------------------------------
-- pwm_Gen:
-- This will generate a pwm signal based on
-- the provided period and duty parameters.
-- Any invalid inputs will be ignored and treated
-- as a '0' or '1' depending on their circumstance.
---------------------------------------------------
pwm_Gen: process(
    clk,
    reset,
    enable_z1,
    enable_z2,
    ris_edge,
    ris_edge2
  )
  begin
  
    if (reset = '1') then 
      count_sig <= (others => '0');
      pwm_out <= '0';
    elsif (rising_edge(clk)) then
      if (ris_edge = '1') then
        -- set on startup
        pwm_out <= '1';
      elsif (ris_edge2 ='1') then
        -- increment on startup
        count_sig <= count_sig + x"1";
      elsif (enable_z2 = '1') then -- after enable is synchronized
        if(period = 0 or duty = 0) then
          pwm_out <= '0';
          count_sig <= (others => '0');
        else
          -- IF the duty is reach and no inputs are invalid
          if (count_sig = (duty-1) and (duty /= period) and not(period < duty)) then
              pwm_out <= '0';
              count_sig <= count_sig + x"1";
              
          -- IF the pwm period is reached
          elsif (count_sig = (period-1)) then
            count_sig <= (others => '0');
            pwm_out <= '1';
            
          -- otherwise increment  
          else
            count_sig <= count_sig + x"1";
          end if;
        end if;
      else
        pwm_out <= '0';
        count_sig <= (others => '0');
      end if;
    end if;
  end process pwm_Gen;
  
--------------------------------------------------------------------------------
-- OUTPUT SIGNALS
--------------------------------------------------------------------------------
output <= pwm_out and enable;
  
  
end beh;
