# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.remove_relation_fields').live 'click', (event) ->
  event.preventDefault()
  $(this).prev('input[type=hidden]').val('1')
  $(this).parent().hide()

$('#add_relation_fields').click (event) ->
  event.preventDefault()
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + $(this).attr('data-association'), 'g')
  $($('#relation_fields_template').html().replace(regexp, new_id)).insertBefore $(this)

$ ->
  $('.graph').error () ->
    $(this).parentsUntil('.sub_category').hide()
