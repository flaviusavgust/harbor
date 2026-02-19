current_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
TPUT := $(shell command -v tput 2> /dev/null)
SHELL = /bin/sh
.DEFAULT_GOAL := help

define print_title
	if [ "${TPUT}" = "" ]; then echo $1; else tput bold; tput setaf 7; echo $1; tput sgr0; fi
endef

define print_info
	if [ "${TPUT}" = "" ]; then echo $1; else tput setaf 7; echo $1; tput sgr0; fi
endef

define print_success
	if [ "${TPUT}" = "" ]; then echo $1; else tput setaf 34; echo $1; echo ""; tput sgr0; fi
endef

define print_error
	if [ "${TPUT}" = "" ]; then echo $1; else tput setaf 1; echo $1; tput sgr0; fi
endef

define print_help
	if [ "${TPUT}" = "" ]; then echo $1; else tput setaf 6; echo $1; tput sgr0; fi
endef

deps: deps/git-chglog deps/git-hooks deps/python deps/python/tests ## Get project dependencies.

.PHONY: tests
tests: ansible/tests ## Run the entire application tests and linters.

clean: ## Clean temporary, unused or generated files.
	@$(call print_title, "Cleaning files:")
	@rm -rf .venv/*
	@if [ "$$?" = "0" ]; then $(call print_success, "Files cleaned successfully!"); fi

changelog:
	@$(call print_title, "Generating CHANGELOG:")
	@./bin/git-chglog --silent --config .chglog/config.yml --output CHANGELOG.md
	@if [ "$$?" = "0" ]; then $(call print_success, "File generated successfully!"); fi

deps/git-chglog:
	@$(call print_title, "Getting git-chglog binary:")
	@curl -sf https://gobinaries.com/git-chglog/git-chglog/cmd/git-chglog | PREFIX=bin sh
	@if [ "$$?" = "0" ]; then $(call print_success, "Git-chglog downloaded successfully!"); fi

deps/git-hooks:
	@$(call print_title, "Getting git-hooks binary:")
	@curl -sf https://gobinaries.com/git-hooks/git-hooks | PREFIX=bin sh
	@if [ "$$?" = "0" ]; then $(call print_success, "Git-hooks downloaded successfully!"); fi
	@$(call print_title, "Initializing git-hooks:")
	@if [ -d .git/hooks.old ]; then \
		$(call print_success, "Git-hooks already initialized"); \
	else \
		./bin/git-hooks install; \
		if [ "$$?" != "0" ]; then exit 1; fi; \
		$(call print_success, "Git-hooks initialized successfully!"); \
	fi
	@sed -i.bak 's/^git-hooks/\.\/bin\/git-hooks/g' .git/hooks/*; rm -f .git/hooks/*.bak

check-virtualenv:
	@$(call print_title, "Checking virtualenv:")
	@if [ "$${VIRTUAL_ENV}" = "" ]; then \
		$(call print_error, "You are NOT in a Python Virtualenv. Init/activate a virtualenv and try again."); \
		$(call print_info, "Try: python3 -m venv .venv && source .venv/bin/activate\n"); \
		exit 1; \
	fi
	@$(call print_success, "Virtualenv activated!");

deps/python: check-virtualenv
	@$(call print_title, "Getting project dependencies:")
	@pip install --ignore-installed -r requirements.txt
	@if [ "$$?" = "0" ]; then $(call print_success, "Dependencies downloaded successfully!"); fi

deps/python/tests: check-virtualenv
	@$(call print_title, "Getting tests dependencies:")
	@pip install --ignore-installed -r requirements-tests.txt
	@if [ "$$?" = "0" ]; then $(call print_success, "Tests dependencies downloaded successfully!"); fi

ansible/tests: check-virtualenv
	@$(call print_title, "Running Molecule tests:")
	@molecule test
	@if [ "$$?" = "0" ]; then $(call print_success, "Molecule tests executed successfully!"); fi

help: ## Prints this help.
	@$(call print_title, "Useful targets:")
	@awk 'BEGIN {FS = ":.*?##"} /^[a-zA-Z_-]+:.*?##/ { printf "  %-10s %s\n", $$1, $$2 } /^##@/ { printf "%-15s  %s\n", $$1, $$2}' $(MAKEFILE_LIST)
