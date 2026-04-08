# Runs the last target definition in this Makefile (excluding this rule).
# Append new targets below; keep this block at the end of the file.
.PHONY: latest
latest:
	@tf="$(firstword $(MAKEFILE_LIST))"; \
	LAST=$$(grep -E '^[A-Za-z0-9][A-Za-z0-9_.-]*:' "$$tf" | grep -v '^latest:' | tail -1 | cut -d: -f1); \
	test -n "$$LAST" || { echo 'latest: no target lines found in' "$$tf" 1>&2; exit 1; }; \
	echo "$(MAKE) $$LAST"; \
	$(MAKE) $$LAST


# Make functions --------------------------------------------------------------
_build-folder-lib = \
	@echo "Building $(1) scripts..."; \
	find "$(2)" -maxdepth 1 -type f -name '*.applescript' -print0 \
	| while IFS= read -r -d '' file; do \
		no_ext=$${file%.applescript}; \
		echo "Building $$file ($$no_ext)"; \
	done; \
	echo "Done building $(1) scripts\n"


# Start -----------------------------------------------------------------------

ex00-common-target:
	@echo "Common Makefile target invoked"

ex01-invoke-another-target:
	@echo "Example 01: Invoke another target"
	$(MAKE) ex00-common-target

# Directory containing the files
DIR = ./csource

# Get all the .txt files in the directory. Must not have space in filename or directory.
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


ex-04-check-if-command-exists:
	@if command -v cliclick >/dev/null 2>&1; then \
	    echo "cliclick is installed"; \
	else \
	    echo "Error: cliclick is not installed" >&2; \
	    exit 1; \
	fi


# Heredoc doesn't work with osascript, so we use printf to print the script to the terminal.
ex-05-applescript-multi-line:
	@printf '%s\n' \
		'tell application "Finder"' \
		'	activate' \
		'	display dialog "Hello from Makefile"' \
		'end tell' \
		| osascript


ex-06-directory-exists:
	@if [ -d "/tmp" ]; then \
		echo "Directory EXISTS."; \
	else \
		echo "Directory DOES NOT exist, skipping."; \
	fi


ex-07-build-dir:
	$(call _build-folder-lib,AppleScript,applescripts)


ex-08-check-scpt-exists:
	echo TODO



# ex-09-confirmation:
# 	@printf 'This will remove the app-notes scripts from the system. Proceed? [y/N] '; IFS= read -r reply; reply=$${reply:-n}; \
# 	case "$$reply" in \
# 		[Yy]|[Yy][Ee][Ss]) \
# 			echo "Confirmed."; \
# 			;; \
# 		*) \
# 			echo "Not confirmed (default: no)."; \
# 			exit 0; \
# 			;; \
# 	esac


ex-09-confirmation:
	# Must exit 1 if not confirmed. 0 WILL NOT break the execution.
	@printf 'This will remove the app-notes scripts from the system. Proceed? [y/N] '; IFS= read -r reply; reply=$${reply:-n}; \
	case "$$reply" in \
		[Yy]|[Yy][Ee][Ss]) \
			;; \
		*) \
			echo "Not confirmed (default: no)."; \
			exit 1 ;; \
	esac
	@echo Proceeding...