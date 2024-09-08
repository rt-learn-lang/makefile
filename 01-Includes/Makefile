# Makefile
# Created: Tue, Jul 16, 2024 at 9:45:40 AM

ifdef GLOBAL
	include Makefile.global
else ifdef TEST
	include Makefile.test
else
	include Makefile.user
endif

main_ex1:
	@echo "Built-in variables"
	@echo "$(USER)"
	@echo "$(HOME)"


main_error:
	$(info     Error log demo)
	$(error    Execution breaks here)
	$(info     This will not be executed)
