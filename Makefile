ex00-common-target:
	@echo "Common Makefile target invoked"

ex01-invoke-another-target:
	@echo "Example 01: Invoke another target"
	$(MAKE) ex00-common-target

