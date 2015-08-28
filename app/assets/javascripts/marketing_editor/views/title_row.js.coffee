class MarketingEditorApp.Views.TileRowView extends Backbone.View

  template: JST['marketing_editor/templates/row']

  events:
    'click .remove-row-btn': 'removeRow'

  initialize: (options={})->
    @rowType = options.rowType

  render: ()->
    @$el.html(@template({rowType: @rowType}))
    @

  removeRow: ->
    @$el.remove()

