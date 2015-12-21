class @DonatChart
  create: (element_id) ->
    if $('#' + element_id + '[data-url]').length
      $.get $('#' + element_id).attr('data-url'), (data) ->
        new d3pie(element_id, {
          "size": {
            "canvasWidth": 590,
            "pieOuterRadius": "90%",
            "pieInnerRadius": "50%"
          },
          "data": {
            "sortOrder": "value-desc",
            "content": $.map data, (value, key) ->
              {
              "label": key,
              "value": value,
              }
          },
          "labels": {
            "outer": {
              "pieDistance": 32
            },
            "inner": {
              "format": "value",
              "hideWhenLessThanPercentage": 3
            },
            "mainLabel": {
              "fontSize": 11
            },
            "percentage": {
              "color": "#ffffff",
              "decimalPlaces": 0
            },
            "value": {
              "color": "#ffffff",
              "fontSize": 11
            },
            "lines": {
              "enabled": true
            },
            "truncation": {
              "enabled": true
            }
          },
          "tooltips": {
            "enabled": true,
            "type": "placeholder",
            "string": "{label}: {value} ({percentage}%)"
          },
          "effects": {
            "pullOutSegmentOnClick": {
              "effect": "linear",
              "speed": 400,
              "size": 8
            }
          },
        })
