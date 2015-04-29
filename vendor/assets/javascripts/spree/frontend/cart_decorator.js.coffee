Spree.fetch_cart = ->
  $.ajax
    url: Spree.pathFor("/store/cart_link"),
    cache: false,
    success: (data) ->
      $('#link-to-cart').html data
