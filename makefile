ifeq ($(OS),Windows_NT)
    # Configuraciones para Windows
    COMPILE_CMD = iverilog -o tb.vvp .\testbench.v
	VPP = vvp .\tb.vvp
    GTKWAVE_CMD = gtkwave tb.vcd
	RM = del
	
else
    # Configuraciones para Linux
    COMPILE_CMD = iverilog -o tb.vvp .\testbench.v
	VPP = vvp tb.vvp
    GTKWAVE_CMD = gtkwave tb.vcd
	RM = rm

endif

all: compile run view clean

compile:
	$(COMPILE_CMD)		
run:
	$(VPP)
view:
	$(GTKWAVE_CMD)
.PHONY: all clean compile view run