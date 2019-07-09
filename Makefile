.PHONY: help up down clean

.DEFAULT_GOAL := help

##################################
# Display help for this makefile #
##################################
define PRINT_HELP_PYSCRIPT
import re, sys

print("VIKYNGO Software")
print("--------------------------------")
print("Usage:  make COMMAND")
print("")
print("Commands:")
for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("    %-16s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

##################
# Basic commands #
##################
DOCKER := docker
DC := docker-compose
ECHO := /usr/bin/env echo
SHELL := /bin/bash
HELP := python -c "$$PRINT_HELP_PYSCRIPT"

IS_DOCKER_COMPOSE_INSTALLED := $(shell command -v docker-compose 2> /dev/null)

################
# Main targets #
################
help: ## Show this help
	@$(HELP) < $(MAKEFILE_LIST)

up: check-deps ## Start VIKYNGO
	./clone-all.sh
	@$(DC) up

down: check-deps ## Stop VIKYNGO
	@$(DC) down

clean: clean-build ## Clean repositories
	@$(ECHO) "Cleaning was successful."

###############
# Sub targets #
###############
check-deps:
ifndef IS_DOCKER_COMPOSE_INSTALLED
	@$(ECHO) "Error: docker-compose is not installed"
	@$(ECHO)
	@$(ECHO) "You need docker-compose to run this command. Check out the official docs on how to install it in your system:"
	@$(ECHO) "- https://docs.docker.com/compose/install/"
	@$(ECHO)
	@$(DC) # docker-compose is not installed, so we call it to generate an error and exit
endif

clean-build: # Remove build artifacts
	@rm -fr server/
	@rm -fr web-app/
