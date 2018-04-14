SHELL := /bin/bash


TESTNETWORK := mqtt-test-network


network: 
	test "$(TESTNETWORK)" = "$$(docker network ls --filter name=$(TESTNETWORK) --format '{{.Name}}')" || docker network create $(TESTNETWORK)

mosquitto : network
	docker run --rm --name mosquitto --network=$(TESTNETWORK) --network-alias=mosquitto -ti -p 1883:1883 -p 9001:9001 \
			toke/mosquitto

build: 
	docker build -t mqtttols .
