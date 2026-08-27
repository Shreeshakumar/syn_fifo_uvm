QUESTA := /home/share/questa.csh
SHELL := /bin/csh
TEST ?= fifo_test
T ?= test1
V ?= UVM_DEBUG

# ANSI Colors
RED     := \033[1;31m
GREEN   := \033[1;32m
YELLOW  := \033[1;33m
BLUE    := \033[1;34m
MAGENTA := \033[1;35m
CYAN    := \033[1;36m
RESET   := \033[0m

COLORIZE = perl -pe '\
s/Error/\e[1;31m$$&\e[0m/g; \
s/ERROR/\e[1;31m$$&\e[0m/g; \
s/RESULT/\e[1;31m$$&\e[0m/g; \
s/Warning/\e[1;33m$$&\e[0m/g; \
s/WARNING/\e[1;33m$$&\e[0m/g; \
s/Fatal/\e[1;35m$$&\e[0m/g; \
s/FATAL/\e[1;35m$$&\e[0m/g; \
s/fifo_driver/\e[1;32m$$&\e[0m/g; \
s/fifo_input_monitor/\e[1;36m$$&\e[0m/g; \
s/fifo_output_monitor/\e[1;34m$$&\e[0m/g; \
s/fifo_scoreboard/\e[1;95m$$&\e[0m/g; \
s/shreeshakumar/\e[1;97m$$&\e[0m/g; \
s/\bMATCH\b/\e[1;92m$$&\e[0m/g; \
s/\bMISMATCH\b/\e[1;91m$$&\e[0m/g; '

.ONESHELL:	
all:
	make com
	make sim
	make cov
	make pu
	
cc:
	make com T=$(T) V=$(V)
	make sim T=$(T) V=$(V)

com:
	@echo "\t\t\t\t$(RED)........................................................ COMPILING CODE .........................................................$(RESET)"
	source $(QUESTA)
	vlog -sv +acc +cover +fcover -l src/simulation/log_file.log src/verification/fifo_top.sv |& $(COLORIZE)
	
sim:
	@echo "\t\t\t\t$(CYAN)................................................... SIMULATING TEST = $(TEST) ...................................................$(RESET)"
	source $(QUESTA)
	vsim -vopt work.fifo_top -voptargs=+acc=npr +UVM_TESTNAME=$(T) +UVM_VERBOSITY=$(V) -assertdebug -l src/simulation/log_file.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll src/simulation/ucdb_file.ucdb; run -all; exit" |& $(COLORIZE)

cov:
	@echo "\t\t\t\t$(MAGENTA).................................................... CREATING COVERAGE REPORT ...................................................$(RESET)"
	source $(QUESTA)
	vcover report -html src/simulation/ucdb_file.ucdb -htmldir src/simulation/covReport -details |& $(COLORIZE)
	
pu:
	@echo "\t\t\t\t$(GREEN)....................................................... PUSHING TO GIT REPO ......................................................$(RESET)"
	git add --all
	git commit -m 'commiting'
	git push |& $(COLORIZE)

check:
	@echo "\t\t\t\t$(CYAN)........................................................ CHECKING SERVER USERS .....................................................$(RESET)"
	source $(QUESTA)
	lmstat -A |& $(COLORIZE)
