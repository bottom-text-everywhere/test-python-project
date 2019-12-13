SHELL := $(shell command -v bash)

GIT_REMOTE_URL := $(shell git config --get remote.origin.url)
GIT_ORG := $(shell sed -E 's/^.*[:\/]([^:\/]+)\/.*$$/\1/' <<<"$(GIT_REMOTE_URL)")
GIT_REPO := $(shell sed -E 's/^.*\/([^:\/]+)$$/\1/ ; s/\.git$$//' <<<"$(GIT_REMOTE_URL)")

DOCKER_IMAGE_TAG ?= $(shell git log --pretty=format:'%H' -n 1 2>/dev/null || echo latest)

.PHONY: build
build:
	docker build -t "$(GIT_ORG)/$(GIT_REPO):$(DOCKER_IMAGE_TAG)" .

.PHONY: shell
shell: build
	mkdir -p .shell-files
	touch .shell-files/.bashrc
	touch .shell-files/.bash_history
	docker run \
		--rm -it \
		\
		-v "${PWD}/.shell-files/.bashrc:/root/.bashrc" \
		-v "${PWD}/.shell-files/.bash_history:/root/.bash_history" \
		\
		$(shell test ! -f "${PWD}/.shell-files/.gitconfig" || printf '%s' '-v ${PWD}/.shell-files/.gitconfig:/root/.gitconfig:ro') \
		$(shell test ! -f "${PWD}/.shell-files/.gitconfig.local" || printf '%s' '-v ${PWD}/.shell-files/.gitconfig.local:/root/.gitconfig.local:ro') \
		\
		-v "${PWD}:/workspace" \
		\
		-w /workspace \
		--entrypoint bash \
		\
		"$(GIT_ORG)/$(GIT_REPO):$(DOCKER_IMAGE_TAG)"
