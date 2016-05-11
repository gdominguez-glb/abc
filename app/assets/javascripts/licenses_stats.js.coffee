$(()->
  $('#licensesDropdown').find('.dropdown-menu a').on('click', ()->
    url = '/account/licenses/licenses_stats'
    $el = $(this)
    licensesId = $el.data('product')

    $.ajax
      url: url
      data: { licenses_ids: licensesId }
      success: (response)->
        $el.closest('form').find('.product-stats').replaceWith(response)
  )
)
