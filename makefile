# generador
ifeq ($(OS),Windows_NT)
    # Configuraciones para Windows
    COMPILE_CMD1 = iverilog -o mdio.vvp .\tb_mdio.v
	VPP1 = vvp .\mdio.vvp
    GTKWAVE_CMD1 = gtkwave mdio.vcd
	RM1 = del
	
else
    # Configuraciones para Linux
    COMPILE_CMD1 = iverilog -o mdio.vvp .\tb_mdio.v
	VPP1 = vvp mdio.vvp
    GTKWAVE_CMD1 = gtkwave mdio.vcd
	RM1 = rm

endif
# receptor
ifeq ($(OS),Windows_NT)
    # Configuraciones para Windows
    COMPILE_CMD2 = iverilog -o rec.vvp .\receptor_testbench.v
	VPP2 = vvp .\rec.vvp
    GTKWAVE_CMD2 = gtkwave rec.vcd
	RM2 = del
	
else
    # Configuraciones para Linux
    COMPILE_CMD2 = iverilog -o rec.vvp .\receptor_testbench.v
	VPP2 = vvp rec.vvp
    GTKWAVE_CMD2 = gtkwave rec.vcd
	RM2 = rm

endif
generador: compile1 run1 view1
receptor: compile2 run2 view2
compile1:
	$(COMPILE_CMD1)		
run1:
	$(VPP1)
view1:
	$(GTKWAVE_CMD1)
compile2:
	$(COMPILE_CMD2)		
run2:
	$(VPP2)
view2:
	$(GTKWAVE_CMD2)