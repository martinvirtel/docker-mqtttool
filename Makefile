SHELL := /bin/bash


TESTNETWORK := mqtt-test-network

PWD := $(shell pwd)

network: 
	test "$(TESTNETWORK)" = "$$(docker network ls --filter name=$(TESTNETWORK) --format '{{.Name}}')" || docker network create $(TESTNETWORK)

mosquitto : network
	mkdir -p $(PWD)/mqtt ;\
	test "$@" = "$$(docker ps --filter name='$@' --format '{{.Names}}')" || \
	docker run --restart=unless-stopped -d --name '$@' \
	       --network=$(TESTNETWORK) --network-alias='$@' \
		   --volume $(PWD)/mqtt:/mqtt/data/ \
	-p 1883:1883 -p 9001:9001 toke/mosquitto

MONITOR := cat - 
monitor: mosquitto  
	echo MONITOR := '$(MONITOR)' ;\
	docker run --rm --network=$(TESTNETWORK) -it --name=$@ mqtttool 'mqttcat mqtt://mosquitto/%23 | $(MONITOR)'

heartbeat: mosquitto 
	docker run --rm --network=$(TESTNETWORK) -it --name=$@ mqtttool 'printf "tick\ntock\n" | mqttcat mqtt://mosquitto/heartbeat --loop --wait=1'

relay:
	docker run --rm --network=$(TESTNETWORK) -it --name=$@ mqtttool 'mqttcat mqtt://mosquitto/heartbeat | unbuffer -p grep "tock" | mqttcat --follow mqtt://mosquitto/tock'

build: 
	docker build -t mqtttool .



