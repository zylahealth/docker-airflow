AIRFLOW_DEPS = $(shell sed -e :a -e '$!N; s/\n/,/; ta' airflow_requirements)
PYTHON_DEPS := $(shell sed -e :a -e '$!N; s/\n/ /; ta' pip_requirements)
OWNER = feature
REPOSITORY = 685249416972.dkr.ecr.ap-south-1.amazonaws.com/$(OWNER)
APP_NAME = airflow
GLOBAL_VERSION = latest
GIT = $(shell which git)
DOCKER := $(shell which docker)
ifeq ($(APP_VERSION),)
	APP_VERSION = $(shell $(GIT) describe --tags --abbrev=0 2>/dev/null)
endif
TAG_VERSION = $(REPOSITORY)/$(APP_NAME):$(APP_VERSION)
TAG_GLOBAL = $(REPOSITORY)/$(APP_NAME):$(GLOBAL_VERSION)


build_docker:
	$(DOCKER) build --build-arg AIRFLOW_DEPS="$(AIRFLOW_DEPS)" --build-arg PYTHON_DEPS="$(PYTHON_DEPS)" -t $(TAG_VERSION) -t $(TAG_GLOBAL) .

run_docker:
	$(DOCKER) run -d -p 8080:8080 --env-file env $(TAG_GLOBAL)

push_docker: build_docker
	$(DOCKER) push $(TAG_VERSION)
	$(DOCKER) push $(TAG_GLOBAL)