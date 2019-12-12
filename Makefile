SHELL := $(shell command -v bash)

.PHONY: build
build:
	docker build -t bottom-text-everywhere/test-python-project:latest .

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
		bottom-text-everywhere/test-python-project:latest
