library ieee;
use ieee.std_logic_1164.all;

entity timer_psl_top is
end entity;

architecture rtl of timer_psl_top is
  signal clk_i   : std_ulogic := '0';
  signal arst_i  : std_ulogic := '1';
  signal start_i : std_ulogic := '0';
  signal done_o  : std_ulogic;
  signal start_d     : std_ulogic := '0';  -- previous value
  signal start_pulse : std_ulogic := '0';  -- rising-edge detect

begin

  clk_i <= not clk_i after 5 ns;

  dut : entity work.timer
    generic map (
      clk_freq_hz_g => 100_000_000,
      delay_g       => 50 ns
    )
    port map (
      clk_i   => clk_i,
      arst_i  => arst_i,
      start_i => start_i,
      done_o  => done_o
    );

  process
  begin
    wait for 20 ns;
    arst_i <= '0';

    wait for 20 ns;
    start_i <= '1';
    wait for 10 ns;
    start_i <= '0';
    wait for 10 ns;
    start_i <= '1';

    wait;
  end process;

    process(clk_i)
    begin
        if rising_edge(clk_i) then
            start_d <= start_i;
        end if;
    end process;
    start_pulse <= start_i and not start_d;



    -- psl default clock is (rising_edge(clk_i));

    -- Reset accepted: Whenever a reset signal is asserted, done must go high on the next cycle while waiting for start_i
    -- psl assert always (arst_i = '1' -> next(done_o = '1'));

    -- Start accepted: if idle and start asserted, done must go low next cycle
    -- psl assert always ((arst_i = '0' and start_pulse = '1' and done_o = '1') -> next(done_o = '0'));

    -- No early done: cycles 2..5 after acceptance must still be low (pre-update sampling)
    -- psl assert always ((arst_i = '0' and start_pulse = '1' and done_o = '1') -> next[2](done_o = '0'));
    -- psl assert always ((arst_i = '0' and start_pulse = '1' and done_o = '1') -> next[3](done_o = '0'));
    -- psl assert always ((arst_i = '0' and start_pulse = '1' and done_o = '1') -> next[4](done_o = '0'));

    -- Completion at cycle 5 (post-update sampling at that edge)
    -- psl assert always ((arst_i = '0' and start_pulse = '1' and done_o = '1') -> next[5](next(done_o = '1')));

    -- Idle stability: if idle and no start, stay idle
    -- psl assert always ((arst_i = '0' and done_o = '1' and start_i = '0') -> next(done_o = '1'));

end architecture;
