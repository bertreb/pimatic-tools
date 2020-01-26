module.exports = {
  title: "pimatic-tools device config schemas"
  VariableDelayDevice: {
    title: "Tools config options"
    type: "object"
    extensions: ["xLink", "xAttributeOptions"]
    properties:
      variables:
        description: "list of variables to be delayed"
        format: "table"
        type: "array"
        default: []
        items:
          type: "object"
          properties:
            name:
              descpription: "the delayed variable name"
              type: "string"
              required: true
            variable:
              descpription: "the input pimatic device <device-id>"
              type: "string"
              required: true
      sampleRate:
        description: "number of minutes between samples and the minutes between the delayed variable is updated/emitted"
        type: "number"
        default: 1
      delay:
        description: "total number of minutes the variable value is delayed"
        type: "number"
        default: 0
  }
}
