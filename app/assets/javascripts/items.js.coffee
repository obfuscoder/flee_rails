addFixedSize = (size) -> $('#item_fixed_size').append($('<option>', value: size, text: size))
removeFixedSizes = -> $('#item_fixed_size option').remove()

itemEditCategorySelected = ->
  return unless $('#item_category_id').length > 0
  selector = '#item_category_id option:selected'

  donation_enforced = $(selector).attr('data-donation-enforced') == 'true'
  $('#item_donation').prop('disabled', donation_enforced)
  if donation_enforced
    $('#item_donation').prop('checked', true)
    $('#donation-enforced-hint').addClass('show')
  else
    $('#donation-enforced-hint').removeClass('show')

  gender = $(selector).attr('data-gender') == 'true'
  $('.item_gender input').prop('disabled', !gender)
  if gender
    $('.item_gender .radio').removeClass('disabled')
  else
    $('.item_gender .radio').addClass('disabled')
    $('.item_gender .radio input').prop('checked', false)

  size_option = $(selector).attr('data-size-option') || 'size_optional'
  value = switch
    when $('#item_size').is(':visible')
      $("#item_size").val()
    when $('#item_fixed_size').is(':visible')
      $("#item_fixed_size option:selected").text()
    else ''

  switch size_option
    when 'size_disabled'
      $('#item_size').show()
      $('#item_size').prop('disabled', true)
      $('#item_size').val('')
      $('#item_fixed_size').hide()
    when 'size_optional'
      $('#item_size').show()
      $('#item_size').prop('disabled', false)
      $('#item_size').val(value)
      $('#item_fixed_size').hide()
    when 'size_required'
      $('#item_size').val($("#item_fixed_size option:selected").text()) if $('#item_fixed_size').is(':visible')
      $('#item_size').show()
      $('#item_size').val(value)
      $('#item_size').prop('disabled', false)
      $('#item_fixed_size').hide()
    when 'size_fixed'
      $('#item_size').hide()
      $('#item_fixed_size').show()
      removeFixedSizes()
      sizes = $(selector).attr('data-sizes').split("|")
      addFixedSize size for size in sizes
      value = $("#item_fixed_size option:first").val() unless $("#item_fixed_size option[value='" + value + "']").length > 0
      $('#item_fixed_size').val(value)
      $('#item_size').val(value)

itemFixedSizeSelected = ->
  return if $('#item_fixed_size').is(':hidden')
  $('#item_size').val($("#item_fixed_size option:selected").text())

$(document).on 'change', '#item_category_id', itemEditCategorySelected
$(document).on 'ready', itemEditCategorySelected
$(document).on 'change', '#item_fixed_size', itemFixedSizeSelected
