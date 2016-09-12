# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

itemEditCategorySelected = ->
  form_group = 'form.edit_item .item_category, form.new_item .item_category'
  selector = 'form.edit_item #item_category_id option:selected, form.new_item #item_category_id option:selected'
  donation_enforced = $(selector).attr('data-donation-enforced') == 'true'
  $('#item_donation').prop('disabled', donation_enforced)
  if donation_enforced
    $('#item_donation').prop('checked', true)
    $('#donation-enforced-hint').addClass('show')
  else
    $('#donation-enforced-hint').removeClass('show')
$(document).on 'change', 'form.edit_item #item_category_id', itemEditCategorySelected
$(document).on 'change', 'form.new_item #item_category_id', itemEditCategorySelected
$(document).on 'ready', itemEditCategorySelected
