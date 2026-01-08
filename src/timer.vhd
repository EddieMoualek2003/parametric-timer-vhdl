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
  type state_type is (IDLE, COUNT, DONE);
  signal state : state_type := IDLE;

  begin
  process (clk_i)
  begin
    if rising_edge(clk_i) then
      if arst_i = '1' then
        state   <= IDLE;
        count_r <= 0;
        done_o  <= '1';
      else
        -- Default assignments (stay in current state)
        state  <= state;
        done_o <= done_o;
        count_r <= count_r;

        case state is

          when IDLE =>
            done_o <= '1';
            count_r <= 0;
            if start_i = '1' then
              state <= COUNT;
            end if;

          when COUNT =>
            done_o <= '0';
            if count_r = delay_cycles_c - 1 then
              state <= DONE;
            else
              count_r <= count_r + 1;
            end if;
            

          when DONE =>
            done_o <= '1';
            if start_i = '0' then
              state <= IDLE;
            end if;

        end case;
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
