library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity timer is
  generic (
    clk_freq_hz_g : natural;
    delay_g       : time
  );
  port (
    clk_i   : in  std_ulogic;
    arst_i  : in  std_ulogic;
    start_i : in  std_ulogic;
    done_o  : out std_ulogic
  );
end entity timer;


architecture rtl of timer is

  -- Number of clock cycles corresponding to delay_g
  -- This will be computed from clk_freq_hz_g and delay_g.
  constant delay_cycles_c : natural := 0;

  -- Counter to keep track of the elapsed clock cycles.
  signal count_r : natural := 0;

begin

  -- Synchronous process for implementing the timer.
  process (clk_i)
  begin
    if rising_edge(clk_i) then
      -- Synchronous active-high reset
      if arst_i = '1' then
        count_r <= 0;
        done_o  <= '1';
      else
        -- For now, no logic is needed, as the timer behaviour will be implemented later.
        -- For safety, still assign the outputs to make sure the design is fully specified.
        done_o  <= '1'; 
      end if;
    end if;
  end process;

end architecture rtl;
