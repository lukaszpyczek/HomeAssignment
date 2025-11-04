SHELL := /bin/bash
ENV ?= dev

pre-commit:
	pre-commit run --all-files
