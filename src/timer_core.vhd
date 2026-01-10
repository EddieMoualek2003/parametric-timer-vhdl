library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer_core is
  generic (
    DELAY_CYCLES_G : natural
  );
  port (
    clk_i   : in  std_ulogic;
    arst_i  : in  std_ulogic;
    start_i : in  std_ulogic;
    done_o  : out std_ulogic
  );
end entity timer_core;

architecture rtl of timer_core is

  signal count_r : natural := 0;
  type state_type is (IDLE, COUNT, DONE);
  signal state : state_type := IDLE;

begin

  process(clk_i)
  begin
    if rising_edge(clk_i) then
      if arst_i = '1' then
        state   <= IDLE;
        count_r <= 0;
        done_o  <= '1';
      else
        case state is

          when IDLE =>
            done_o  <= '1';
            count_r <= 0;
            if start_i = '1' then
              state  <= COUNT;
              done_o <= '0';
            end if;

          when COUNT =>
            if DELAY_CYCLES_G = 0 then
              state  <= DONE;
              done_o <= '1';
            elsif count_r = DELAY_CYCLES_G - 1 then
              state  <= DONE;
              done_o <= '1';
            else
              count_r <= count_r + 1;
              done_o  <= '0';
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

end architecture rtl;
