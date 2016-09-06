# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready', ->
  $('select[multiple]').multiselect
    enableClickableOptGroups: true
    disableIfEmpty: true
    maxHeight: 400
    nonSelectedText: 'Bitte auswählen'
    nSelectedText: ' ausgewählt'
    allSelectedText: 'Alle ausgewählt'
    selectAllText: 'Alles auswählen'
    includeSelectAllOption: true
    enableCaseInsensitiveFiltering: true
    filterPlaceholder: 'Suche'
    buttonContainer: '<div class="checkbox" />'