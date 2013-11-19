# Makefile automatically generated by ghdl
# Version: GHDL 0.29 (20100109) [Sokcho edition] - mcode code generator
# Command used to generate this makefile:
# ghdl --gen-makefile --ieee=synopsys -fexplicit ALUTestbench

GHDL=ghdl
GHDLFLAGS= -fexplicit
GHDLRUNFLAGS= --vcd=alu.vcd

# Default target : elaborate
all : elab

# Elaborate target.  Almost useless
elab : force
	$(GHDL) -c $(GHDLFLAGS) -e alutestbench

# Run target
run : force
	$(GHDL) -c $(GHDLFLAGS) -r alutestbench $(GHDLRUNFLAGS)

# Targets to analyze libraries
init: force
	# /usr/local/ghdl/translate/lib//v93/synopsys/../../../../libraries/ieee/std_logic_1164.v93
	# /usr/local/ghdl/translate/lib//v93/synopsys/../../../../libraries/ieee/std_logic_1164_body.v93
	# /usr/local/ghdl/translate/lib//v93/synopsys/../../../../libraries/ieee/numeric_std.v93
	# /usr/local/ghdl/translate/lib//v93/synopsys/../../../../libraries/ieee/numeric_std-body.v93
	$(GHDL) -a $(GHDLFLAGS) ALUTestbench.vhdl
	# /usr/local/ghdl/translate/lib//v93/synopsys/../../../../libraries/synopsys/std_logic_arith.vhdl
	# /usr/local/ghdl/translate/lib//v93/synopsys/../../../../libraries/synopsys/std_logic_unsigned.vhdl
	$(GHDL) -a $(GHDLFLAGS) ALU.vhd

force:
