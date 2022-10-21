.PHONY:sim clear sim_gdb

STUID := ysyx_040066
CSRC_DIR := $(NPC_HOME)/csrc/src/
CSRC_FILES := $(shell find $(CSRC_DIR) -name "*.cpp")
CSRC_INCLUDE_DIR := $(NPC_HOME)/csrc/include/
CSRC_INCLUDE := $(shell find $(CSRC_INCLUDE) -name "*.h")
VSRC_DIR := $(NPC_HOME)/vsrc
VSRC_FILES := $(shell find $(VSRC_DIR) -name "*.v")
VSRC_MERGE := $(NPC_HOME)/$(STUID).v
EMU_DIR := $(NPC_HOME)/emu
EMU_TOP_MODULE :=$(STUID)
EMU_TARGET := emu
INSTR = #-DINSTR #-DR_W -Dfully_info
CFLAGS_NPC = -I$(CSRC_INCLUDE_DIR) -O3 $(INSTR) #-DMTRACE
VFLAGS = $(INSTR) -O3 -DWORKBENCH -DEMU_MUTLI
LDFLAGS =-lSDL2 
CPPFLAGS += #-DVL_DEBUG
Verilatorflags =--x-assign fast --x-initial fast --build -j 4 --clk clock --threads-max-mtasks 4

DIFF = --diff=$(NEMU_HOME)/build/riscv64-nemu-interpreter-so
IMG ?= 
ARGS ?= --log=$(NPC_HOME)/emu/log.txt

$(EMU_DIR)/$(EMU_TARGET): $(VSRC_MERGE) $(CSRC_FILES) $(CSRC_INCLUDE)

$(VSRC_MERGE):$(VSRC_FILES)
	@cat $(VSRC_FILES) > $(VSRC_MERGE)

$(EMU_DIR)/$(EMU_TARGET): $(VSRC_MERGE) $(CSRC_FILES) $(CSRC_INCLUDE)
	@echo "Verilator VSRC_FILES > EMU_DIR"
	@verilator --cc $(addprefix -CFLAGS , $(CFLAGS_NPC)) $(addprefix -LDFLAGS , $(LDFLAGS))\
		-Mdir $(@D)\
		--top-module $(EMU_TOP_MODULE)\
		--prefix $(EMU_TARGET)\
		--exe $(CSRC_FILES)\
		$(Verilatorflags) $(VFLAGS)\
		$(VSRC_MERGE)

sim: $(EMU_DIR)/$(EMU_TARGET)
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	$< $(ARGS) $(DIFF) $(IMG)

sim_gdb: $(EMU_DIR)/$(EMU_TARGET)
	$(call git_commit, "sim_gdb RTL")
	gdb -s $< --args $< $(ARGS) $(DIFF) $(IMG)

clear:
	rm -rf $(EMU_DIR) $(VSRC_MERGE)

include ../Makefile
