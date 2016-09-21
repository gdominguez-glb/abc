class MarketingEditorApp.Views.PageView extends Backbone.View

  initialize: (attrs={})->
    @tiles = attrs.tiles
    @renderTilesEditor()

  renderTilesEditor: ->
    @editor = new MarketingEditorApp.Views.Editor(
      el: @$('#editor'),
      tilesData: @tiles
    )
    @editor.render()

  events:
    "click input[type='submit']": "submitForm"

  submitForm: (e)->
    e.preventDefault()
    @$('.save-page-btn').attr('disabled', true).val('Saving Page')
    formData = @$el.serialize()
    formData = formData + '&' + $.param({'tiles': @editor.tilesJSON() })
    url = @$el.attr('action')
    method = @$el.attr('method')
    $.ajax({
      url: url,
      method: method,
      dataType: 'script'
      data: formData
      complete: (res)=>
        func = => $('.save-page-btn').attr('disabled', false).val('Save Page')
        setTimeout(
          func
          2000
        )
    })
