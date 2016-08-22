# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  if $('#items_per_category[data-url]').length
    new DonatChart().create 'items_per_category'
  if $('#canvas_items_per_day[data-url]').length
    new BarChart().create '#canvas_items_per_day'
  if $('#canvas_sellers_per_day[data-url]').length
    new BarChart().create '#canvas_sellers_per_day'
