SHELL := /bin/bash

TAG=dev

.PHONY: build help test run

build:
	sudo docker build -t ${TAG} .

help:
	-@echo 'You must log in with:'
	-@echo '    docker login --username=yourhubusername --email=youremail@company.com'
	-@echo 'Then run:'
	-@echo '    docker images'
	-@echo 'Pick the correct ID and then:'
	-@echo '    docker tag ID yourhubusername/dev:latest'
	-@echo 'Finally:'
	-@echo '    docker push yourhubusername/dev'

test:
	make build
	sudo docker run -it --rm --network host -v $(shell pwd):/mounted ${TAG}

# This spins up a container with all ports exposed, mounted on the current directory
run:
	sudo docker run -it --rm --network host -v $(shell pwd):/home josephthomashines/${TAG}

