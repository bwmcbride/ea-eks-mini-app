# Makefile for ea-eks-mini-app

NAME:=mini-app

BRANCH:=$(shell git rev-parse --abbrev-ref HEAD)

DOCKER_REGISTRY:=293385631482.dkr.ecr.eu-west-1.amazonaws.com

CONTEXT:=epimorphics/ea-eks

BRANCH_REPO=$(DOCKER_REGISTRY)/$(CONTEXT)/$(BRANCH)

# controlling the release tag of an app depends on the build process for the app
# here it is simply read from a file.

APP_VERSION:=$(shell cat VERSION)

GIT_COMMIT:=$(shell git describe --dirty --always)

GIT_SHORT_HASH:=$(shell git rev-parse --short HEAD )

.PHONY: build-image

build-image:
	docker build -t $(NAME):$(shell git describe --abbrev=0 ) .
	
.PHONY: publish-image

publish-image:
	git fetch --tags origin
	VERSION=$$( git describe --abbrev=0 ) && \
	docker build \
	  -t $(NAME):$${VERSION} \
	  --build-arg "image_name=$(NAME)" \
	  --build-arg "build_date=$(shell date "+%Y-%m-%dT%H:%M:%S%z")" \
	  --build-arg "git_commit_hash=$(shell git rev-parse HEAD)" \
	  . && \
	docker tag $(NAME):$${VERSION} $(BRANCH_REPO)/$(NAME):$${VERSION}_$(GIT_SHORT_HASH) && \
	docker push $(BRANCH_REPO)/$(NAME):$${VERSION}_$(GIT_SHORT_HASH) 

release:
	echo $(APP_VERSION)
	git tag -a -m "" -f $(APP_VERSION)
	git push origin --force $(APP_VERSION)
	git push origin $(BRANCH)
	
# flop
