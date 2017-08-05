# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '#new_custom_email input[type=radio][data-ref]', ->
  event_id = $(this).attr('data-ref')
  value = $(this).attr('value')
  value_given = typeof value != typeof undefined && value != false
  $('#' + event_id).prop('disabled', !value_given)

get_choice = (option) ->
  $('#new_custom_email input[name="custom_email[' + option + ']"]:checked').val()
filter_for_option = (array, option) ->
  choice = get_choice(option)
  event = $('#custom_email_' + option + '_event').val()
  filter_function(choice)(array, sellers.events[event][option])
inclusion_filter = (array, another_array) ->
  _.intersection array, another_array
exclusion_filter = (array, another_array) ->
  _.difference array, another_array
passthru_filter = (array, anything) ->
  array
filter_function = (choice) ->
  return inclusion_filter if choice == 'true'
  return exclusion_filter if choice == 'false'
  passthru_filter
$(document).on 'change', '#new_custom_email [data-update]', ->
  $('select[multiple]').multiselect('deselectAll', false)
  result = filter_function(get_choice('active'))(sellers.all, sellers.active)
  result = filter_for_option(result, 'items')
  result = filter_for_option(result, 'reservation')
  result = filter_for_option(result, 'notification')
  $('select[multiple]').multiselect('select', result)
