.PHONY: clean all how spike run_modelsim

all: TARGET_ASSEMBLY_CODE = ./testcode/mp3_full_test.s
all: run_modelsim

comp1: TARGET_ASSEMBLY_CODE = ./testcode/comp1_im.s
comp1: run_modelsim

comp1_i: TARGET_ASSEMBLY_CODE = ./testcode/comp1_i.s
comp1_i: run_modelsim

comp2: TARGET_ASSEMBLY_CODE = ./testcode/comp2_im.s
comp2: run_modelsim

comp2_i: TARGET_ASSEMBLY_CODE = ./testcode/comp2_i.s
comp2_i: run_modelsim

comp3: TARGET_ASSEMBLY_CODE = ./testcode/comp3_im.s
comp3: run_modelsim

comp3_i: TARGET_ASSEMBLY_CODE = ./testcode/comp3_i.s
comp3_i: run_modelsim

final: TARGET_ASSEMBLY_CODE = ./testcode/mp3-final.s
final: run_modelsim

spike:
	cp /class/ece411/software/scripts/baremetal_link.ld ./
	./bin/compile.sh ./testcode/to_run.s
	spike --isa=rv32im -d riscv_test_bin

run_modelsim:
	python3 fill_magic_count.py ${TARGET_ASSEMBLY_CODE} ./testcode/tempasdf.s
	cpp ./testcode/tempasdf.s > ./testcode/to_run.s
	./bin/rv_load_memory.sh ./testcode/to_run.s ./simulation/modelsim/memory.lst
	cd simulation/modelsim && vsim -c -do "do ./mp3_run_msim_rtl_verilog.do; q"
	cd ../..
	@echo "To verify correctness, run make spike now to compare register values"

# Rules to clean
clean:
	rm ./testcode/tempasdf.s
	rm ./testcode/to_run.s
	rm ./simulation/modelsim/memory.lst
	rm ./riscv_test_bin

# Rules to display helper
how:
	@echo "Usage: make + option"
