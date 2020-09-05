# Slackube

Slackube is a project to update Slack status using the Xiaomi Aqara Magic Cube.

Slackube it allows you to customise which status do you want to show depending on the side of the cube you select.

![Slackube](https://github.com/jesuslg123/slackube/blob/master/slackube_demo.gif)

## Features

- Flip the cube, 90 or 180 degrees, to change the status.
- Shake the cube to reset the status. You could also customise this action status.

## Requirements

- [Aqara Magic Cube](https://www.aqara.com/us/cube.html)
- Zigbee [CC2531 usb sniffer](https://www.ti.com/product/CC2531) and its debugger to [load the firmware](https://www.zigbee2mqtt.io/getting_started/flashing_the_cc2531.html)
- Slack App with scope `users.profile:write`
    - Scope: `users.profile:write`
    - Generate a OAuth token
- Zigbee2mqtt to manage the USB sniffer
- Mosquitto as MQTT broker
- Coordinator app, a simple Ruby app I built to connect the whole flow with Slack API.


## Zigbee2mqtt

This software will manage all the work that need to be done to translate all the zigbee raw data to json information and it will be propagate to MQTT broker.

### Setup

This process could be replaced with a Docker image if you are running on Windows or Linux, on Mac OS X there is a [limitation](https://docs.docker.com/docker-for-mac/faqs/#can-i-pass-through-a-usb-device-to-a-container) that make it more difficult.

So for now we will install it [locally](https://www.zigbee2mqtt.io/getting_started/running_zigbee2mqtt.html) as they show.

- Clone the repo 

        git clone https://github.com/Koenkk/zigbee2mqtt.git

- Install dependencies

        npm ci

- Config your port

        nano data/configuration.yaml

    - Change the port device to your USB port name (under /dev/xxx.xxxxx)
    - Keep `permit_join` to `true` untill the cube is paired.
    - Change mqtt broker information if need it  

            permit_join: true

            mqtt:
                base_topic: zigbee2mqtt
                server: 'mqtt://localhost'
                # MQTT server authentication, uncomment if required:
                # user: my_user
                # password: my_password

            # Serial settings
            serial:
                # Location of CC2531 USB sniffer
                port: /dev/tty.usbmodem14101 

### Run

    npm start


### Pair the Cube

In order to use the Cube you first need to pair it.

- Open the cube case
- Hold the pairing button for at least 3-5 seconds untill the light flash
- Press the pairing button every second untill the pairing is done
    - The pairing is done when you see on the console the message

            Successfully interviewed '0x00158d00027d770c', device has successfully been paired
            Device '0x00158d00027d770c' is supported, identified as: Xiaomi Mi/Aqara smart home cube (MFKZQ01LM)
            MQTT publish: topic 'zigbee2mqtt/bridge/log', payload '{"message":"interview_successful","meta":{"description":"Mi/Aqara smart home cube","friendly_name":"0x00158d00027d770c","model":"MFKZQ01LM","supported":true,"vendor":"Xiaomi"},"type":"pairing"}'
    
    - Now your cube is paired and ready to use, if you move it, you will see more events.
    - Save the device identifier, in this sample is: `0x00158d00027d770c`

## MQTT Broker

MQTT Broker is the system in charge of move the message along the USB integration to the coordinator app.
We are using Mosquitto implementation for this guide, but you could use any other one if you want.

### Run

    docker run -it -p 1883:1883 -p 9001:9001 eclipse-mosquitto

## Coordinator

The coordinator is a simple ruby app which listen for the MQTT broker messages, parse them and make the requests to the Slack API.

### Configuration

- Open `config.yaml` with your favorite tool
- Change the default sample placeholder settings
    - `slack: token:`
    - `mqtt: topic:` Set `zigbee2mqtt/YOUR_CUBE_IDENTIFIER`
    - `status:` Change every side and shake status information as you desire
    
### Run

    ruby coordinator.rb