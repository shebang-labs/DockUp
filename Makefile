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

# target: push-docker - publishes API image.
.PHONY: push-docker
push-docker:
	$(DOCKER) push $(DOCKER_IMAGE)

# target: run-docker - publishes API image.
.PHONY: run-docker
run-docker: build-docker
	$(DOCKER) push $(DOCKER_IMAGE)
	$(DOCKER) run \
	-e DockUpStrategy=s3 \
	-e DockUpSrc=. \
	-e AWS_BUCKET=$(AWS_BUCKET) \
	-e AWS_REGION=$(AWS_REGION) \
	-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
	-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
	$(DOCKER_IMAGE)