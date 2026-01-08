from vunit import VUnit

# Create VUnit instance (disable deprecated builtin auto-compile)
vu = VUnit.from_argv(compile_builtins=False)

# Explicitly add VHDL builtins
vu.add_vhdl_builtins()

# Create library
lib = vu.add_library("lib")

# Add RTL and testbench source files
lib.add_source_files("src/*.vhd")
lib.add_source_files("tb/*.vhd")

# Run all tests
vu.main()
