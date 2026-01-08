from vunit import VUnit

ui = VUnit.from_argv()

lib = ui.add_library("lib")
lib.add_source_files("src/*.vhd")
lib.add_source_files("tb/*.vhd")

# Enable waveform dumping for GHDL - Useful for debugging and visual verification.
ui.set_sim_option("ghdl.elab_flags", ["--std=08"])
ui.set_sim_option("ghdl.sim_flags", ["--wave=wave.ghw"])

ui.main()
