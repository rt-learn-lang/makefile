ex00-common-target:
	@echo "Common Makefile target invoked"

ex01-invoke-another-target:
	@echo "Example 01: Invoke another target"
	$(MAKE) ex00-common-target

# Directory containing the files
DIR = ./csource

# Get all the .txt files in the directory
FILES = $(wildcard $(DIR)/*.cpp)

# Target that processes all the files
ex-02-print-directory-files:
	@for file in $(FILES); do \
		echo "Processing $$file"; \
	done

# Target that processes all the files
ex-03-print-directory-files-sans-ext:
	@for file in $(FILES); do \
		no_ext=$${file%.cpp}; \
		echo "Processing $$no_ext"; \
	done


