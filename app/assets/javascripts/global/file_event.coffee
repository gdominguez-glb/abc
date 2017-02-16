class window.FileEvent
  @simulateClick: (element) ->
    $(element).click()

  @fillWithName: (fill, element) ->
    $(fill).html($(element).val().replace(/C:\\fakepath\\/i, ''))
