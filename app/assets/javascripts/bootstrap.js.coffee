$(document).on 'ready', ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()
  $('#confirm-modal').on 'show.bs.modal', ->
    target = $(event.target)
    href = target.data('link') || target.parent().data('link')
    link = $('#confirm-link')
    link.attr('href', href)

    message = target.data('message') || target.parent().data('message')
    $('#confirm-message').text(message) if message
