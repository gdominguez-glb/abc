submitForm = ($form)->
  $.ajax(
    url: $form.attr('action')
    type: 'POST'
    data: $form.serializeArray()
  )

Spree.bindSimpleCartEvents  = ->
  if ($ 'form#simple-update-cart').length > 0
    ($ 'form#simple-update-cart .line_item_quantity').unbind('change')
    ($ 'form#simple-update-cart .line_item_quantity').bind 'change', ->
      submitForm(($ this).parents('form').first())

    ($ 'form#simple-update-cart a.delete').unbind('click')
    ($ 'form#simple-update-cart a.delete').bind 'click', ->
      ($ this).parents('.line-item').first().find('input.line_item_quantity').val 0
      submitForm(($ this).parents('form').first())

Spree.fetch_cart = ->
  $.ajax
    url: Spree.pathFor("/cart_link"),
    cache: false,
    success: (data) ->
      $('#link-to-cart').html data
      Spree.bindSimpleCartEvents()
