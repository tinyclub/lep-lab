# Makefile for lep-lab

LEP=$(CURDIR)/lep.sh

help:
	@echo "Usage:"
	@echo
	@echo "init  -- download or update lepd and lepv (1)"
	@echo "_lepd -- compile and restart lepd (2)"
	@echo "_lepv -- restart the lepv backend (3)"
	@echo "view  -- start the lepv frontend (4)"
	@echo "all   -- do (1) (2) (3) one by one"
	@echo

all:
	$(LEP)

init:
	git submodule update --init --remote .

_lepd:
	$(LEP) lepd

_lepv:
	$(LEP) lepv

view:
	$(LEP) view
