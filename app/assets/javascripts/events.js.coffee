# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  $('#event_shopping_periods_attributes_0_min, #event_shopping_periods_attributes_0_max, #event_reservation_start, #event_reservation_end, #event_handover_start, #event_handover_end, #event_pickup_start, #event_pickup_end').datetimepicker({
    locale: 'de',
    stepping: 5,
    showTodayButton: true,
    showClose: true,
    widgetPositioning: { vertical: 'bottom' }
  });
