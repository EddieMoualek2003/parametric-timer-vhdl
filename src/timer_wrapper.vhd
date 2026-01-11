library ieee;
use ieee.std_logic_1164.all;

-- ---------------------------------------------------------------------------
-- Timer wrapper for formal verification
--
-- This wrapper instantiates the generic timer with fixed parameters so that
-- its behaviour can be formally verified using PSL and SymbiYosys. The wrapper
-- itself contains no logic; it exists solely to bind concrete generic values
-- and provide a stable top-level for formal tools.
-- ---------------------------------------------------------------------------


entity timer_wrapper is
  port (
    clk_i   : in  std_ulogic;
    arst_i  : in  std_ulogic;
    start_i : in  std_ulogic;
    done_o  : out std_ulogic
  );
end entity;

architecture formal of timer_wrapper is
begin
  ---------------------------------------------------------------------------
  -- Device Under Test (DUT)
  --
  -- The timer is instantiated with:
  --   - clk_freq_hz_g = 100 MHz
  --   - delay_g       = 50 ns
  --
  -- These values correspond to the configuration exercised by the formal
  -- properties and ensure a concrete, deterministic timing model.
  ---------------------------------------------------------------------------

  dut: entity work.timer
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
end architecture;