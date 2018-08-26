ifneq (,)
This makefile requires GNU Make.
endif

PROJECT:=dockup
VERSION?=latest
OWNER:=tareksamni
DOCKER_IMAGE?=$(OWNER)/$(PROJECT):$(VERSION)
DOCKER:=$(shell which docker)

# target: help - display this help.
.PHONY: help
help:
	@egrep '^# target' [Mm]akefile

# target: build-docker
.PHONY: build-docker
build-docker: Dockerfile
	$(DOCKER) build --pull -t $(DOCKER_IMAGE) .

# target: push-docker
.PHONY: push-docker
push-docker:
	$(DOCKER) push $(DOCKER_IMAGE)

# target: run-docker
.PHONY: run-docker
run-docker: build-docker
	$(DOCKER) push $(DOCKER_IMAGE)
	$(DOCKER) run \
	--env-file test.env \
	--env CODECLIMATE_REPO_TOKEN=$(CODECLIMATE_REPO_TOKEN) \
	$(DOCKER_IMAGE)

# target: test-docker
.PHONY: test-docker
test-docker: build-docker
	$(DOCKER) push $(DOCKER_IMAGE)
	$(DOCKER) run \
	--env-file test.env \
	--env CODECLIMATE_REPO_TOKEN=$(CODECLIMATE_REPO_TOKEN) \
	$(DOCKER_IMAGE) \
	/bin/bash -c "bundle exec rspec; bundle exec codeclimate-test-reporter"
