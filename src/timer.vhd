library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity timer is
  generic (
    clk_freq_hz_g   : natural;
    delay_g         : time;
    expose_cycles_g : boolean := true
  );
  port (
    clk_i   : in  std_ulogic;
    arst_i  : in  std_ulogic;
    start_i : in  std_ulogic;
    done_o  : out std_ulogic
  );
end entity timer;

architecture rtl of timer is

  ---------------------------------------------------------------------------
  -- Number of clock cycles corresponding to delay_g.
  -- Calculated as ceil(delay_g * clk_freq_hz_g).
  -- This ensures the timer does not expire earlier than the requested delay.
  ---------------------------------------------------------------------------
  constant delay_cycles_c : natural :=
    natural(
      ceil(real(clk_freq_hz_g) * real(delay_g / 1 ns) * 1.0e-9)
    );
    -- 1 ns is used as the normalisation unit, aligning with the default
    -- simulation time resolution used by tools such as Vivado xsim.


  -- Register holding the number of elapsed clock cycles
  signal count_r : natural := 0;

begin

  ---------------------------------------------------------------------------
  -- Clocked process (timer behaviour to be implemented later)
  ---------------------------------------------------------------------------
  process (clk_i)
  begin
    if rising_edge(clk_i) then
      if arst_i = '1' then  -- When the reset signal is high
        count_r <= 0;       -- Reset the internal counter
        done_o  <= '1';     -- The system is not counting, so set done_o to high
      else
        -- Placeholder behaviour
        done_o <= '1';
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- Optional Debugging - Verification of delay_cycles_c
  -- This allows us to check if the computation of the elaboration-time constant is correct.
  ---------------------------------------------------------------------------
  debug_gen : if expose_cycles_g generate
  begin
    assert false
      report "delay_cycles_c = " &
             integer'image(integer(delay_cycles_c))
      severity note;
  end generate;

end architecture rtl;
