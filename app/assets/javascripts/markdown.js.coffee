$(document).on 'ready', ->
  $('.markdown_editor').each ->
    new SimpleMDE element: this, spellChecker: false, status: false, hideIcons: ['guide'], toolbarTips: false
