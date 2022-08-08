GLOBAL_PYTHON_PATH = /usr/bin
GLOBAL_PYTHON = $(GLOBAL_PYTHON_PATH)/python3

POETRY = $(GLOBAL_PYTHON) -m poetry

VENV_PATH = .venv
VENV_PYTHON = $(VENV_PATH)/bin/python

PRE_COMMIT = $(VENV_PATH)/bin/pre-commit
PRE_COMMIT_RUN_ARGS = --all-files
PRE_COMMIT_INSTALL_ARGS = --install-hooks

BUMP_BY = patch

.PHONY: help
help:
	@echo hello

.PHONY: install-pre-requests
install-pre-requests:
	$(GLOBAL_PYTHON) -m pip install poetry==1.1.13

.PHONY: poetry-config
poetry-config:
	$(POETRY) config virtualenvs.in-project true

.PHONY: poetry-install
poetry-install:
	$(POETRY) install 

.PHONY: poetry-lock
poetry-lock:
	$(POETRY) lock

.PHONY: lint
lint:
	$(PRE_COMMIT) run $(PRE_COMMIT_RUN_ARGS)

.PHONY: pre-commit-install
pre-commit-install:
	$(PRE_COMMIT) install $(PRE_COMMIT_INSTALL_ARGS)

.PHONY: bump
bump:
	$(POETRY) run bump2version $(BUMP_BY)
.PHONY: start
start: install-pre-requests poetry-config poetry-install pre-commit-install
	@echo We are ready to go! =]
