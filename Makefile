# Init variables
GIT_VERSION ?= $(shell git describe --tags --always)
GIT_COMMIT ?= $(shell git rev-parse HEAD)
GIT_COMMIT_SHORT ?= $(shell git rev-parse --short HEAD)
BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)

# Platform can be overwritten, the platform type arm64 is used for M1 silicon chips
# of apple
PLATFORM?=linux/amd64

# GIT branch name
GIT_VERSION ?= $(shell git rev-parse --abbrev-ref HEAD)

# Version definitions, project is our version, dbt is version of dbt to use
PROJECT_NAME?=snow
DBT_VERSION?=1.4.4
PROJECT_VERSION?=0.0.1
VERSION=${DBT_VERSION}_${PROJECT_VERSION}

HUB?=bjornmooijekind
REPO?=snowboard

IMAGE?=${HUB}/${REPO}

VOLUME_PROFILE?=~/.dbt/profiles.yml:/root/.dbt/profiles.yml
VOLUME_PROJECT?=$(PWD)/${PROJECT_NAME}:/usr/app/${PROJECT_NAME}
VOLUMES?=-v ${VOLUME_PROFILE} -v ${VOLUME_PROJECT}

DEBUG?=false
ifeq ($(DEBUG), true)
DEBUG_LOG_ARGS := --debug
endif

.PHONY: echo_version
echo_version:
	echo ${VERSION}

.PHONY: build
build:
	docker build --build-arg PROJECT_NAME=${PROJECT_NAME} --build-arg DBT_VERSION=${DBT_VERSION} --platform ${PLATFORM} -t ${IMAGE}:${VERSION} .

.PHONY: tag-latest
tag-latest:
	docker tag ${IMAGE}:${VERSION} ${IMAGE}:latest

.PHONY: push
push:
	docker push ${IMAGE}:${VERSION} && \
	docker push ${IMAGE}:latest

.PHONY: dbt-deps
dbt-deps:
	docker run --pull=always --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:latest ${DEBUG_LOG_ARGS} deps

.PHONY: dbt-compile
dbt-compile:
	docker run --pull=always --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:latest ${DEBUG_LOG_ARGS} compile

.PHONY: dbt-clean
dbt-clean:
	docker run --pull=always --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:latest ${DEBUG_LOG_ARGS} clean

.PHONY: dbt-run
dbt-run:
	docker run --pull=always --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:latest ${DEBUG_LOG_ARGS} run

.PHONY: dbt-generate
dbt-generate:
	docker run --pull=always --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:latest docs generate

.PHONY: dbt-serve
dbt-serve:
	docker run --pull=always -p 8082:8082 --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:latest docs serve --port 8082
