# MQTTtool

This repository offers a docker container that can be used to publish, receive, relay and filter MQTT messages using the command line tool
[mqttcat](https://github.com/martinvirtel/python-mqttcat).

## Requirements

Docker and Make

## Walk-through

Please see the Makefile for how this works behind the scenes. Here's the walk-through:

1) `make build` - builds the MQTTtool container. 

2) `make mosquitto` - starts MQTT server on your host - the server can be reached from the docker host as `localhost` and 
from all other containers that share the network `mqtt-test-network` (defined in the `Makefile`) as `mosquitto`.


3) `make monitor` starts a MQTT monitoring process that subscribes to all topics on the MQTT server started in step 2) and echos them
to the console. 

4) Now you should start another terminal window, so you can look at the monitor process started in step 3)

5) In the new terminal, enter `make heartbeat` - it starts a process that publishes messages in regular intervals to the topic "/heartbeat".
The monitor process from step 3) should begin to show some activity.

6) In a third terminal window, you can now enter `make relay` - which starts a process that listens to the topic "/heartbeat" and forwards
some of the messages to the topic "/tock"

## How it works

Centerpiece of MQTTtool is the application of the Unix pipeline paradigm to MQTT messages. 

## Credits

This work is part of the [Smartorchestra](http://smartorchestra.de/) project, co-financed by the [Federal Ministery of Economics and Technology](https://www.bmwi.de/).

