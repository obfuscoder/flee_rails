# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready cocoon:after-insert', ->
  $('.form_datetime').datetimepicker({
    locale: 'de',
    stepping: 5,
    showTodayButton: true,
    showClose: true,
    widgetPositioning: { vertical: 'bottom' }
  });
  if $('#canvas_top_sellers[data-url]').length
    new BarChart().create '#canvas_top_sellers'
  if $('#items_per_category_for_event[data-url]').length
    new DonatChart().create 'items_per_category_for_event'
  if $('#sold_items_per_category_for_event[data-url]').length
    new DonatChart().create 'sold_items_per_category_for_event'
  if $('#sellers_per_city[data-url]').length
    new DonatChart().create 'sellers_per_city'
