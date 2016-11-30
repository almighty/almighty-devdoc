SOURCE_DIR := $(shell pwd)/../..
DOCKER_IMAGE_DEVDOC := almighty-devdoc

# The IS_JENKINS will be set depending on if
# make is executed inside of Jenkins or locally not
ifneq ($(BUILD_TAG),)
	IS_JENKINS := "yes"
	# If running in Jenkins we don't allow for interactively running the container
	DOCKER_RUN_INTERACTIVE_SWITCH :=
else 
	IS_JENKINS :=
	# If not running in Jenkins we allow for interactively running the container
	DOCKER_RUN_INTERACTIVE_SWITCH :=  -i
endif

# The BUILD_TAG environment variable will be set by jenkins
# to reflect jenkins-${JOB_NAME}-${BUILD_NUMBER}
BUILD_TAG ?= almighty-devdoc-local-build
DOCKER_CONTAINER_NAME := $(BUILD_TAG)

.PHONY: all
# Triggers the "build" target
all: build

.PHONY: help
# Shows all the commands and their description
help:
	@echo ""
	@echo "Make file commands"
	@echo "------------------"
	@grep -Pzo "(?s)\.PHONY:(\N*)(.*)(^\1)" Makefile | grep -v Makefile | grep -o "\(.PHONY:.*\|^#.*\)" | sed -s 's/.PHONY:\s*/\n- /g' |sed -s 's/#/\t/g'

.PHONY: docker-image-devdoc
# Builds the docker image used to build the software
docker-image-devdoc:
	@echo "Building docker image $(DOCKER_IMAGE_DEVDOC)"
	docker build -t $(DOCKER_IMAGE_DEVDOC) .

.PHONY: clean-docker-container
# Removes any existing container used to build the software (if any)
clean-docker-container:
	@echo "Removing container named \"$(DOCKER_CONTAINER_NAME)\" (if any)"
ifneq ($(strip $(shell docker ps -qa --filter "name=$(DOCKER_CONTAINER_NAME)")),) 
	docker rm -f $(DOCKER_CONTAINER_NAME)
else
	@echo "No container named \"$(DOCKER_CONTAINER_NAME)\" to remove"
endif

.PHONY: clean
# Triggers
#  - clean-docker-container and
#  - clean-build-dir
clean: clean-docker-container clean-build-dir
	
.PHONY: build
# Triggers 
#  - docker-image-devdoc
# and then spawns a docker container to build the software
build: docker-image-devdoc
	@echo "Building with container $(DOCKER_CONTAINER_NAME)"
	docker run \
		-t \
		$(DOCKER_RUN_INTERACTIVE_SWITCH) \
		--rm \
		-u $(shell id -u $(USER)):$(shell id -g $(USER)) \
		-v $(SOURCE_DIR):/tmp/src:rw \
		--name="$(DOCKER_CONTAINER_NAME)" \
		$(DOCKER_IMAGE_DEVDOC) \
		/tmp/src/jenkins/linux/build.sh


