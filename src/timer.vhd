library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity timer is
  generic (
    clk_freq_hz_g   : natural;  -- Input clock frequency in Hz
    delay_g         : time      -- Requested delay duration
  );
  port (
    clk_i   : in  std_ulogic;
    arst_i  : in  std_ulogic;   -- Active-high synchronous reset
    start_i : in  std_ulogic;
    done_o  : out std_ulogic
  );
end entity timer;

architecture rtl of timer is

  ---------------------------------------------------------------------------
  -- Number of clock cycles corresponding to delay_g.
  -- This is calculated at elaboration time using ceiling to ensure the timer
  -- never expires earlier than the requested delay.
  ---------------------------------------------------------------------------
  constant delay_cycles_c : natural :=
    natural(
      ceil(real(clk_freq_hz_g) * real(delay_g / 1 ns) * 1.0e-9)
    );
    -- 1 ns is used as a normalisation unit, consistent with common
    -- simulator time resolutions (e.g. Vivado xsim).


  ---------------------------------------------------------------------------
  -- Internal state
  ---------------------------------------------------------------------------
  signal count_r : natural := 0;
  type state_type is (IDLE, COUNT, DONE);
  signal state : state_type := IDLE;

  begin

  ---------------------------------------------------------------------------
  -- Timer state machine
  ---------------------------------------------------------------------------
  process (clk_i)
  begin
    if rising_edge(clk_i) then
      if arst_i = '1' then
        state   <= IDLE;
        count_r <= 0;
        done_o  <= '1';
      
      else
        case state is

          -- IDLE: Waiting for start request.
          when IDLE =>
            done_o <= '1';
            count_r <= 0;
            if start_i = '1' then
              state <= COUNT;
              done_o <= '0';
            end if;

          -- COUNT: Count clock cycles until delay expires.
          when COUNT =>
            if count_r = delay_cycles_c - 1 then
              state <= DONE;
              done_o <= '1';
            else
              count_r <= count_r + 1;
            end if;
            
          -- Done: Wait for start to deassert before re-arming.
          when DONE =>
            if start_i = '0' then
              state <= IDLE;
            end if;

        end case;
      end if;
    end if;
  end process;

end architecture rtl;
