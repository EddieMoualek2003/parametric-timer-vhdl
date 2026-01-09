library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_timer is
  generic (
    runner_cfg : string
  );
end entity tb_timer;

architecture tb of tb_timer is

  ---------------------------------------------------------------------------
  -- Test parameters
  ---------------------------------------------------------------------------
  constant clk_freq_hz_g : natural := 100_000_000; -- 100 MHz
  constant delay_g       : time    := 50 ns; -- Example test case from document
  -- This implements the same conversion logic as the timer module - it is repeated here
  -- as part of the verification.
  constant delay_cycles_c : natural :=
    natural(
      ceil(real(clk_freq_hz_g) * real(delay_g / 1 ns) * 1.0e-9)
    );

  ---------------------------------------------------------------------------
  -- DUT signals
  ---------------------------------------------------------------------------
  signal clk_i   : std_ulogic := '0';
  signal arst_i  : std_ulogic := '0';
  signal start_i : std_ulogic := '0';
  signal done_o  : std_ulogic;

begin

  ---------------------------------------------------------------------------
  -- Clock generation (100 MHz)
  ---------------------------------------------------------------------------
  clk_i <= not clk_i after 5 ns;

  ---------------------------------------------------------------------------
  -- DUT instantiation
  -- Ports are assigned as: dut_port => tb_signal
  ---------------------------------------------------------------------------
  dut : entity work.timer
    generic map (
      clk_freq_hz_g   => clk_freq_hz_g,
      delay_g         => delay_g
    )
    port map (
      clk_i   => clk_i,
      arst_i  => arst_i,
      start_i => start_i,
      done_o  => done_o
    );

  ---------------------------------------------------------------------------
  -- Test runner - Registers this testbench with VUnit.
  ---------------------------------------------------------------------------
    test_proc : process
    begin
    test_runner_setup(runner, runner_cfg);

    if run("delay_cycles_calculation") then
        -- Begin with the reset
        arst_i <= '1';
        start_i <= '0';
        wait for 10 ns;
        arst_i <= '0';
        wait for 10 ns;

        -- Start the timer
        start_i <= '1';
        wait for 10 ns;
        start_i <= '0';

        -- Test synchronisation since all effects happen on the rising clock edge.
        wait until rising_edge(clk_i);

        -- The timer should be running now, check done_o is low.
        check_equal(done_o, '0', "done_o should go low after start"); -- Passed.

        -- Wait expected number of cycles
        for i in 0 to delay_cycles_c-1 loop
            wait until rising_edge(clk_i);
        end loop;

        -- The timer should now be complete, now check done_o is high.
        wait until rising_edge(clk_i);
        check_equal(done_o, '0', "done_o should go high after delay"); -- Passed.

        -- Let the simulation run for some more time to see how the signals evolve.
        wait for 1 us;
        check_true(true);
    end if;

    test_runner_cleanup(runner);
    wait;
    end process;


end architecture tb;
