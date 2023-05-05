# Platform can be overwritten, the platform type arm64 is used for M1 silicon chips
# of apple
PLATFORM?=linux/amd64
DBT_VERSION?=1.5.0
IMAGE?=bjornmooijekind/dbt-snowboard

# AWS configuration,
AWS_REGION?=eu-central-1
AWS_ACCOUNT?=$(shell aws sts get-caller-identity --query "Account" --output text)
AWS_ACCESS_KEY_ID?=$(shell aws configure get aws_access_key_id)
AWS_SECRET_ACCESS_KEY?=$(shell aws configure get aws_secret_access_key)
AWS_SESSION_TOKEN?=${shell aws configure get aws_session_token}

AWS_ENVS?= -e AWS_REGION=${AWS_REGION} \
	-e AWS_ACCOUNT=${AWS_ACCOUNT} \
	-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	-e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	-e AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}

VOLUME_DBT?=${PWD}/my_project:/usr/app/my_project

.PHONY: build
build:
	docker build --build-arg DBT_VERSION=${DBT_VERSION} --platform ${PLATFORM} -t ${IMAGE}:${DBT_VERSION} .

.PHONY: tag-latest
tag-latest:
	docker tag ${IMAGE}:${VERSION} ${IMAGE}:latest

.PHONY: push
push:
	docker push ${IMAGE}:${DBT_VERSION} && \
	docker push ${IMAGE}:latest

.PHONY: run
run:
	docker run --rm -it -v ${VOLUME_DBT}  ${IMAGE} dbt run --profiles-dir=.

.PHONY: test
test:
	docker run --rm -it -v ${VOLUME_DBT} ${IMAGE} dbt test --profiles-dir=.

.PHONY: docs-generate
docs-generate:
	docker run --rm -it  -v ${VOLUME_DBT} -p 8080:8080 ${IMAGE} dbt docs generate --profiles-dir=.

.PHONY: docs-serve
docs-serve:
	docker run --rm -it  -v ${VOLUME_DBT} -p 8080:8080 ${IMAGE} dbt docs serve --port=8080 --profiles-dir=.

.PHONY: run-deps
run-deps:
	docker run --rm  -v ${VOLUME_DBT} -it ${IMAGE} dbt deps --profiles-dir=.