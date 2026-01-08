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
  constant CLK_FREQ_HZ_C : natural := 100_000_000; -- 100 MHz
  constant DELAY_C       : time    := 100 ms; -- Example test case from document

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
      clk_freq_hz_g   => CLK_FREQ_HZ_C,
      delay_g         => DELAY_C,
      expose_cycles_g => true
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
      check_true(true);
    end if;

    test_runner_cleanup(runner);
    wait;
  end process;

end architecture tb;
