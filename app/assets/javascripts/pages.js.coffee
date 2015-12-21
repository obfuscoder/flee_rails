# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  if $('#items_per_category[data-url]').length
    $.get $('#items_per_category').attr('data-url'), (data) ->
      new d3pie("items_per_category", {
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
            "format": "value"
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
          "string": "{label}: {percentage}%"
        },
        "effects": {
          "pullOutSegmentOnClick": {
            "effect": "linear",
            "speed": 400,
            "size": 8
          }
        },
      });

  if $('#canvas_items_per_day[data-url]').length
    new BarChart().create '#canvas_items_per_day'
  if $('#canvas_sellers_per_day[data-url]').length
    new BarChart().create '#canvas_sellers_per_day'
