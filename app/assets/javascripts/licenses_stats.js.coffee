$(()->
  $('body').on('change', '.licenses-select', ()->
    url = '/account/licenses/licenses_stats'
    $el = $(this)
    $.ajax
      url: url
      data: { licenses_ids: $(this).val() }
      success: (response)->
        $el.closest('form').find('.product-stats').replaceWith(response)
  )
)
