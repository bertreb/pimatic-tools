# pimatic-tools
Plugin to provide some extra tools for variable manipulation.
The first tool is the VariableDelay device.

### VariableDelayDevice

The VariableDelay device will give you the possibility to delay one or more existing variables in time.
In the GUI a timestamp is placed in front of the delayed variables. The timestamp is the moment the value was actual/sampled. The timestamp is updated together with the variables in the pace of the sampleRate. On start of the plugin or after update of the device config, the delay restarts and the timestamp stays on the same time until the delay time is reached. After that it will follow the sampleRate update.

The config of the device.
```
variables:
  "list of variables to be delayed"
    variable:
      name: "the delayed variable name"
      variable: "the input Pimatic variable 'device-id.attribute-name'"
sampleRate:
  "number of minutes between samples and the minutes between the delayed variable is updated/emitted to the GUI"
  minimum value is 1
delay:
  "total number of minutes the variable value is delayed"
  minimum value is 0
```
A sampleRate of 1 or delay of 0 means that the delayed value is not delayed and has the same value as the used variables

#### Example
If you want to delay the variable $weather.temperature for 7 hours and want a sampleRate of 15 minutes.
The config of the device:

```
{
  "id": "<device-id>",
  "name": "<device-name>",
  "class": "VariableDelayDevice",
  "sampleRate": 15,
  "delay": 420
  "variables": [
    {
      "name": "delayed-temperature",
      "variable": "$weather.temperature"
    }
  ],
  "xAttributeOptions": [],
}
```

The delay is 7 hours times 60 minutes per hour is total 420 minutes.
The 15 minutes sampleRate is the rate the variable is sampled (every 15 minutes) and emitted (also every 15 minutes) with a 7 hours delay.

The "name" is the delayed attribute that can be used as variable $\<device-id\>.delayed-temperature


The plugin is in development. You could backup Pimatic before you are using this plugin!
