# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if $('#canvas_items_per_category[data-url]').length
    $.get $('#canvas_items_per_category').attr('data-url'), (data) ->
      steps = Object.keys(data).length
      i = 0
      data = $.map data, (value, key) ->
        alpha = 1 - i/steps
        i += 1
        base = 'rgba(20,80,255,'
        console.log alpha
        [ value: value, label: key, color: base + alpha + ')', highlight: base + alpha*0.8 + ')' ]
      console.log data
      chart = new Chart($('#canvas_items_per_category').get(0).getContext('2d')).Pie(data)
