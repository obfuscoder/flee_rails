# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

createBarChart = (canvas_selector) ->
  if $(canvas_selector + '[data-url]').length
    $.get $(canvas_selector).attr('data-url'), (json) ->
      values = $.map json, (value) -> value
      data =
        labels: Object.keys(json)
        datasets: [
          label: 'hae'
          fillColor: 'rgba(20,80,255,1)'
          data: values
        ]
      new Chart($(canvas_selector).get(0).getContext('2d')).Bar(data)

$(document).on 'ready page:load', ->
  if $('#canvas_items_per_category[data-url]').length
    $.get $('#canvas_items_per_category').attr('data-url'), (data) ->
      steps = Object.keys(data).length
      i = 0
      data = $.map data, (value, key) ->
        alpha = 1 - i/steps
        i += 1
        base = 'rgba(20,80,255,'
        [ value: value, label: key, color: base + alpha + ')', highlight: base + alpha*0.8 + ')' ]
      chart = new Chart($('#canvas_items_per_category').get(0).getContext('2d')).Pie(data)
  createBarChart '#canvas_items_per_day'
  createBarChart '#canvas_sellers_per_day'
