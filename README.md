# pimatic-tools
Plugin to provide some extra tools for variable manipulation.
This plugin supports 1 device; the VariableDelay device.

### VariableDelayDevice

The VariableDelay device will give you the possibility to delay one or more existing variables in time.

The config of the device.
```
variables:
  "list of variables to be delayed"
    variable:
      name: "the delayed variable name"
      variable: "the input pimatic variable 'device-id.attribute-name'"
sampleRate:
  "number of samples per minute and the minute rate the delayed variable update is updated and emitted to the GUI"
delay:
  "number of minutes the variable value is delayed"
```

#### Example
If you want to delay the variable $weather.temperature for 7 hours and want a refresh rate of 15 minutes.
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
The sampleRate is the rate the variable is sampled very 15 minutes and emitted every 15 minutes with a 7 hours delay.

The "name" is the delayed attribute that can be used as variable $<device-id>.delayed-temperature


The plugin is in development. You could backup Pimatic before you are using this plugin!
