# Platform can be overwritten, the platform type arm64 is used for M1 silicon chips
# of apple
PLATFORM?=linux/arm64/v8

# GIT branch name
GIT_VERSION ?= $(shell git rev-parse --abbrev-ref HEAD)

# Version definitions, project is our version, dbt is version of dbt to use
PROJECT_NAME?=snow
DBT_VERSION?=1.4.1
PROJECT_VERSION?=0.0.1
VERSION=${DBT_VERSION}_${PROJECT_VERSION}

HUB?=docker.for.mac.localhost:5001
REPO?=snowboard

IMAGE?=${HUB}/${REPO}

VOLUME_PROFILE?=~/.dbt/profiles.yml:/root/.dbt/profiles.yml
VOLUME_PROJECT?=$(PWD)/${PROJECT_NAME}:/usr/app/${PROJECT_NAME}
VOLUMES?=-v ${VOLUME_PROFILE} -v ${VOLUME_PROJECT}

.PHONY: build
build:
	docker build --build-arg PROJECT_NAME=${PROJECT_NAME} --build-arg DBT_VERSION=${DBT_VERSION} --platform ${PLATFORM} -t ${IMAGE}:${VERSION} .

.PHONY: login
login:
	aws ecr get-login-password --region ${AWS_REGION} --profile ${AWS_PROFILE} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com

.PHONY: push
push:
	docker push ${IMAGE}:${VERSION}

.PHONY: dbt-deps
dbt-deps:
	docker run --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:${VERSION} ${DEBUG_LOG_ARGS} deps

.PHONY: dbt-compile
dbt-compile:
	docker run --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:${VERSION} ${DEBUG_LOG_ARGS} compile

.PHONY: dbt-clean
dbt-clean:
	docker run --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:${VERSION} ${DEBUG_LOG_ARGS} clean

.PHONY: dbt-run
dbt-run:
	docker run --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:${VERSION} ${DEBUG_LOG_ARGS} run

.PHONY: dbt-generate
dbt-generate:
	docker run --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:${VERSION} docs generate

.PHONY: dbt-serve
dbt-serve:
	docker run -p 8082:8082 --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:${VERSION} docs serve --port 8082
