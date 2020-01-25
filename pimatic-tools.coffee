module.exports = (env) ->
  Promise = env.require 'bluebird'
  assert = env.require 'cassert'
  dateFormat = require('dateformat')
  _ = require('lodash')


  class ToolsPlugin extends env.plugins.Plugin
    init: (app, @framework, @config) =>

      pluginConfigDef = require './pimatic-tools-config-schema'
      @configProperties = pluginConfigDef.properties

      deviceConfigDef = require("./device-config-schema")
      @framework.deviceManager.registerDeviceClass('VariableDelayDevice', {
        configDef: deviceConfigDef.VariableDelayDevice,
        createCallback: (config, lastState) => new VariableDelayDevice(config, lastState, @framework)
      })

  class VariableDelayDevice extends env.devices.Device

    constructor: (@config, lastState, @framework) ->
      @id = @config.id
      @name = @config.name
      @attributes = {}
      @attributeValues = {}
      @_vars = @framework.variableManager

      @sampleRate = @config.sampleRate ? 15
      @delay = @config.delay ? 0

      @bufferSize = @sampleRate * @delay

      @_test = 10
      @delayedAttributes = {}
      @delayedAttributeValues = {}
      @pimaticDevices = []
      d = new Date()
      @_timestamp = dateFormat(d,"yyyy-mm-dd HH:MM:ss")

      #create timestamp attribute
      @attributes["timestamp"] =
        description: "the timestamp of the value"
        type: "string"
        label: "timestamp"
        acronym: "timestamp"
      @_createGetter("timestamp", =>
        return Promise.resolve @_timestamp
      )

      for _attr in @config.variables
        do(_attr) =>
          _variable = _attr.variable.trim()
          _variable = if _variable.startsWith("$") then _variable.substring(1) else _variable
          @delayedAttributeValues[_attr.name] = new DelayBuffer(@bufferSize)
          _val = @_vars.getVariableByName(_variable)
          unless _val?
            throw new Error ("Pimatic variable #{_variable} does not exsist")

          _deviceId = _variable.split(".")[0]
          _attributeId = _variable.split(".")[1]
          _device = @framework.deviceManager.getDeviceById(_deviceId)
          if _device?
            for i, _a of _device.attributes
              if i is _attributeId
                @attributes[_attr.name] = 
                  description: _a.description ? _attr.name
                  type: _a.type ? "number"
                  label: _a.label ? _val.name
                  acronym: _a.acronym ? _val.name       
                  unit: _a.unit ? ""       
          
          @_createGetter(_attr.name, =>
            return Promise.resolve @delayedAttributeValues[_attr.name].getValue()
          )
      
      updateDelayedVariables = () =>
        try
          for _attr in @config.variables
            do(_attr) =>              
              _variable = _attr.variable.trim()
              _variable = if _variable.startsWith("$") then _variable.substring(1) else _variable
              @_vars.getVariableUpdatedValue(_variable)
              .then((val)=>
                _delayedValue = @delayedAttributeValues[_attr.name].addValue(val)
                @emit _attr.name, _delayedValue.value
                @_timestamp = _delayedValue.timestamp
                @emit "timestamp", @_timestamp
              )
        catch err 
          env.logger.error "error " + err
        @sampler = setTimeout(updateDelayedVariables, @sampleRate * 60000 )

      @_vars.waitForInit().then(() =>
        updateDelayedVariables()
      )

      super()

    destroy: ->
      clearTimeout(@sampler)
      super()


  class DelayBuffer

    constructor: (size)->
      @buffer = []
      @bufferSize = size
      env.logger.debug "DelayBuffer created"

    addValue: (val) ->
      if _.size(@buffer) >= @bufferSize
        env.logger.debug "Buffer complete, delay active"
        _updatedBuffer = _.drop(@buffer)
        @buffer = _updatedBuffer
      d = new Date()
      ts = dateFormat(d,"yyyy-mm-dd HH:MM:ss")  
      _val = 
        value: val
        timestamp: ts
      @buffer.push _val
      _returnValue = _.head(@buffer)
      env.logger.debug "Value to be added: " + JSON.stringify(_val) + ", return value: " + JSON.stringify(_returnValue)
      return _returnValue

    getValue: () ->
      return _.head(@buffer)

    #getTimestamp: () =>
    #  _oldestValue = _.head(@buffer)
    #  return _oldestValue.timestamp


  plugin = new ToolsPlugin
  return plugin
