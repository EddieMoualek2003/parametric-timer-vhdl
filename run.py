# This will serve as a minimal VUnit runner stub.
from vunit import VUnit

# Module install verification
print(vunit.__version__)

vu = VUnit.from_argv()
vu.main()
