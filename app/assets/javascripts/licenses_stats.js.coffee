$(()->
  $('body').on('change', '.licenses-select', ()->
    url = '/account/licenses/product_stats'
    $el = $(this)
    $.ajax
      url: url
      data: { product_id: $(this).val() }
      success: (response)->
        $el.closest('.container').find('.product-stats').replaceWith(response)
  )
)
