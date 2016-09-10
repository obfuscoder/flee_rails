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
