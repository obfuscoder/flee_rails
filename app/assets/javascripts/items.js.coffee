# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

itemEditCategorySelected = ->
  selector = 'form.edit_item #item_category_id option:selected, form.new_item #item_category_id option:selected'
  donation_enforced = $(selector).attr('data-donation-enforced') == 'true'
  $('#item_donation').prop('disabled', donation_enforced)
  hint = $('.item_category p.help-block')
  hint.addClass('alert alert-warning')
  if donation_enforced
    $('#item_donation').prop('checked', true)
    hint.show()
  else
    hint.hide()
$(document).on 'change', 'form.edit_item #item_category_id', itemEditCategorySelected
$(document).on 'change', 'form.new_item #item_category_id', itemEditCategorySelected
$(document).on 'ready page:load', itemEditCategorySelected
