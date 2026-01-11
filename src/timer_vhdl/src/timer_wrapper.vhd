library ieee;
use ieee.std_logic_1164.all;

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
  -- Instantiate with hardcoded time values
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