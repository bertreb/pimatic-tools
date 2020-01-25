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
If you want to delay a variable for 7 hours and want a refresh rate of 15 minutes, you need to configure the following
```
sampleRate: 15
delay: 420 
```
The delay is 7 hours times 60 minutes per hour is total 420 minutes.
The refreshrate is the rate the variable is sampled very 15 minutes and emitted evry 15 minutes with a 7 hours delay.


The plugin is in development. You could backup Pimatic before you are using this plugin!
