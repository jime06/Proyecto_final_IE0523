dut1:
	iverilog -o tb.vvp testbench_dut1.v
	vvp tb.vvp
	gtkwave tb.vcd
clean: rm -rf tb.vcd tb.vvp